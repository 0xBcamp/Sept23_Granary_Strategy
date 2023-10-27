// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";
import {Ownable} from "openzeppelin/access/Ownable.sol";
import {SafeERC20} from "openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {IDataProvider} from "./interfaces/IDataProvider.sol";
import {IAaveIncentives} from "./interfaces/IAaveIncentives.sol";
import {ILendingPool} from "./interfaces/ILendingPool.sol";
import {IPriceOracle} from "./interfaces/IPriceOracle.sol";
import {IStrategy} from "./interfaces/IStrategy.sol";
import {IReaperVault} from "./interfaces/IReaperVault.sol";
import {IMaxiVault} from "./interfaces/IMaxiVault.sol";
import {console2} from "forge-std/console2.sol";
import {Math} from "openzeppelin/utils/math/Math.sol";

interface IERC20Extented is IERC20 {
    function decimals() external view returns (uint8);
}

error InvalidAToken();
error DepositFailed();
error NotAVault();
error InvalidAmount();

contract Strategy is Ownable {
    using SafeERC20 for IERC20Extented;

    address public vault;

    // tokens used
    address public want;
    address public loanToken;
    address public aToken;
    // Aave contracts
    address public lendingPool;
    address public dataProvider;
    address public aaveIncentives;
    address public priceOracle;
    //Reaper contracts
    address public reaperVault;

    //Contants
    uint256 public constant PRECISION = 100;
    uint256 public constant LIQUIDATION_TRESHOLD = 50;
    uint256 FEED_PRECISION = 1e10;
    uint256 MIN_HEALTH_FACTOR = 1500000000000000000;
    uint256 PERCENTAGE_BPS = 10000;
    uint256 REAPER_FEE_BPS = 1000;
    uint256 SLIPPAGE_BPS = 20; //0.2%

    uint256 totalLoanTaken;

    modifier onlyVault() {
        if (msg.sender != vault) revert NotAVault();
        _;
    }

    constructor(
        address _vault,
        address _want,
        address _loanToken,
        address _lendingPool,
        address _dataProvider,
        address _aaveIncentives,
        address _priceOracle,
        address _reaperVault
    ) Ownable(msg.sender) {
        vault = _vault;
        want = _want;
        loanToken = _loanToken;
        lendingPool = _lendingPool;
        dataProvider = _dataProvider;
        aaveIncentives = _aaveIncentives;
        priceOracle = _priceOracle;
        reaperVault = _reaperVault;

        (aToken,,) = IDataProvider(dataProvider).getReserveTokensAddresses(address(want));
        if (aToken == address(0)) {
            revert InvalidAToken();
        }
    }

    function deposit() external onlyVault {
        _supplyAndBorrow();
        _depositToReaper();
    }

    function _supplyAndBorrow() internal {
        uint256 wantBal = _balanceOfWant();
        // console2.log("wantBal", wantBal);
        if (wantBal != 0) {
            IERC20Extented(want).approve(lendingPool, wantBal);
            ILendingPool(lendingPool).deposit(want, wantBal, address(this), 0);
            uint256 borrowAmount = _calculateBorrowAmount(wantBal); // get 50% of want in loanToken
            uint256 balBefore = _balanceOfLoanToken();
            ILendingPool(lendingPool).borrow(loanToken, borrowAmount, 2, 0, address(this));
            uint256 balAfter = _balanceOfLoanToken();
            uint256 diff = balAfter - balBefore;
            totalLoanTaken += diff; //Never account for any external deposits

            uint256 healthFactor = _checkHealthFactor();
            if (healthFactor < MIN_HEALTH_FACTOR) {
                _adjustPosition();
            }
        }
    }

    function _calculateBorrowAmount(uint256 _want) internal returns (uint256) {
        uint256 loanTokenAmount = _convertToLoanToken(_want);
        return loanTokenAmount / 2; //borrrow only 50% for now
    }

    function _checkHealthFactor() internal view returns (uint256) {
        (,,,,, uint256 _healthFactor) = ILendingPool(lendingPool).getUserAccountData(address(this));
        return _healthFactor;
    }

    function _depositToReaper() internal {
        uint256 loanTokenBal = IERC20Extented(loanToken).balanceOf(address(this));
        if (loanTokenBal != 0) {
            IERC20Extented(loanToken).approve(reaperVault, loanTokenBal);
            uint256 shares = IReaperVault(reaperVault).deposit(loanTokenBal, address(this));
            if (shares <= 0) {
                revert DepositFailed();
            }
        }
    }

    /**
     * @dev Withdraws funds and sends them back to the vault.
     */
    function withdraw(uint256 _amount) external onlyVault {
        if (_amount == 0) revert InvalidAmount();
        // _adjustPosition(); @audit not sure if we need this here because we will eventually repay loan in this fn
        uint256 currBal = _balanceOfWant();
        if (currBal < _amount) {
            uint256 amountInLoanToken = _convertToLoanToken(_amount);
            uint256 sharesToWithdraw;
            (, uint256 totalLoan) = _userReserves(loanToken); //return loan with interest
            console2.log("amountInLoanToken", amountInLoanToken);
            if (amountInLoanToken > totalLoan) {
                uint256 diff = amountInLoanToken - totalLoan; // amount to withdraw from reaper and repay to aave
                console2.log("diff", diff);
                sharesToWithdraw = IReaperVault(reaperVault).convertToShares(diff); //convert amount into shares
                console2.log("sharesToWithdraw", sharesToWithdraw);
                uint256 wantAmountToWithdraw = _convertToWantToken(diff);
                console2.log("wantAmountToWithdraw", wantAmountToWithdraw);
                uint256 balOfLoanToken = _withdrawFromReaper(sharesToWithdraw);
                console2.log("balOfLoanToken", balOfLoanToken);
                uint256 amountAfterSlippageConsideration =
                    (_convertToLoanToken(wantAmountToWithdraw) * SLIPPAGE_BPS) / PERCENTAGE_BPS;
                console2.log("amountAfterSlippageConsideration", amountAfterSlippageConsideration);
                // check for loss from reaper
                if (balOfLoanToken < amountAfterSlippageConsideration) {
                    // check if loss is in the slippage range
                    // we have a loss
                }
                uint256 profit = balOfLoanToken - _convertToLoanToken(wantAmountToWithdraw);
                _repayAndWithdrawFromAave(balOfLoanToken - profit, wantAmountToWithdraw);
            } else {
                uint256 loanTokenAmount = _convertToLoanToken(_amount - currBal);
                sharesToWithdraw = IReaperVault(reaperVault).convertToShares(loanTokenAmount);
                uint256 loanTokenRepayAmount = _withdrawFromReaper(sharesToWithdraw);
                uint256 wantAmountToWithdraw = _amount - currBal;
                _repayAndWithdrawFromAave(loanTokenRepayAmount, wantAmountToWithdraw);
            }
            //TODO: after repay and withdraw there is a high chance that health factor will be less than 1.5 so we need to adjust position.
            _adjustPosition();
        }

        IERC20Extented(want).safeTransfer(vault, _amount);
    }

    /* --------------------------- INTERNAL FUNCTIONS --------------------------- */
    function _repayAndWithdrawFromAave(uint256 _repayAmount, uint256 _wantAmountToWithdraw) internal {
        IERC20Extented(loanToken).approve(lendingPool, _repayAmount);
        ILendingPool(lendingPool).repay(loanToken, _repayAmount, 2, address(this));
        totalLoanTaken -= _repayAmount;
        ILendingPool(lendingPool).withdraw(want, _wantAmountToWithdraw, address(this));
    }

    function _withdrawFromReaper(uint256 _shares) internal returns (uint256) {
        IReaperVault(reaperVault).withdraw(_shares, address(this), address(this));
        return _balanceOfLoanToken(); //should have loantoken after withdraw
    }

    function _adjustPosition() internal view {
        (uint256 supplyBal, uint256 borrowBal) = _userReserves(want);
        uint256 healthFactor = _checkHealthFactor();
        if (supplyBal == 0 && borrowBal == 0) {
            // No position
            // return;
        }

        if (supplyBal != 0 && borrowBal != 0) {
            // We have a position
            if (healthFactor < MIN_HEALTH_FACTOR) {
                // get funds and repay some loan and check position again if it has increased or not
                // return;
            }
            if (healthFactor > MIN_HEALTH_FACTOR) {
                // We have a profit
                //May be we can take more loan and deposit to reaper
                // return;
            }
        }
    }

    /* ----------------------------- VIEW FUNCTIONS INTERNAL ----------------------------- */
    // return supply and borrow balance
    function _userReserves(address asset) internal view returns (uint256, uint256) {
        (uint256 supplyAmount,, uint256 variableRateBorrowAmount,,,,,,) =
            IDataProvider(dataProvider).getUserReserveData(asset, address(this));
        return (supplyAmount, variableRateBorrowAmount);
    }

    function _balanceOfPool() internal view returns (uint256) {
        (uint256 supplyAmount, uint256 borrowAmount) = _userReserves(want);

        return supplyAmount - borrowAmount;
    }

    function _debtInPool() internal view returns (uint256) {
        ( /*uint256 supplyAmount*/ , uint256 borrowAmount) = _userReserves(loanToken);
        return borrowAmount;
    }

    function _balanceOfLoanToken() internal view returns (uint256) {
        return IERC20Extented(loanToken).balanceOf(address(this));
    }

    function _assetStakedInVault() internal view returns (uint256) {
        IReaperVault _reaperVault = IReaperVault(reaperVault);
        return _reaperVault.convertToAssets(_reaperVault.balanceOf(address(this)));
    }

    function _balanceOfWant() internal view returns (uint256) {
        return IERC20Extented(want).balanceOf(address(this));
    }

    function _earned() internal view returns (uint256) {
        uint256 reaperBal = _assetStakedInVault();
        uint256 debt = _debtInPool();

        if (reaperBal <= debt) {
            // We have a loss or no profit
            return 0; // to prevent underflow if loss
        }
        uint256 diff = reaperBal - debt;
        uint256 wantPrice = IPriceOracle(priceOracle).getAssetPrice(want) * FEED_PRECISION; // covert to 18 decimals
        uint256 profitInWant = diff / wantPrice; //convert to want
        return profitInWant / FEED_PRECISION; // Normalize to 8 decimals
    }

    function _convertToLoanToken(uint256 _wantAmount) internal returns (uint256) {
        uint256 decimalPrecisionWantToken = _calculateDecimals(want);
        uint256 decimalPrecisionLoanToken = _calculateDecimals(loanToken);

        uint256 wantTokenPrice = IPriceOracle(priceOracle).getAssetPrice(want) * FEED_PRECISION; // covert to 18 decimals
        uint256 loanTokenPrice = IPriceOracle(priceOracle).getAssetPrice(loanToken) * FEED_PRECISION; // covert to 18 decimals
        uint256 loanTokenAmount;

        if (decimalPrecisionWantToken != 0 && decimalPrecisionLoanToken == 0) {
            loanTokenAmount = _wantAmount * wantTokenPrice / loanTokenPrice / decimalPrecisionLoanToken;
        } else if (decimalPrecisionWantToken == 0 && decimalPrecisionLoanToken != 0) {
            loanTokenAmount = _wantAmount * decimalPrecisionWantToken * wantTokenPrice / loanTokenPrice;
        } else if (decimalPrecisionWantToken != 0 && decimalPrecisionLoanToken != 0) {
            loanTokenAmount =
                _wantAmount * decimalPrecisionWantToken * wantTokenPrice / loanTokenPrice / decimalPrecisionLoanToken;
        } else {
            loanTokenAmount = _wantAmount * wantTokenPrice / loanTokenPrice;
        }
        return loanTokenAmount;
    }

    function _calculateDecimals(address token) internal returns (uint256) {
        uint256 remainingDecimals = 18 - IERC20Extented(token).decimals();
        uint256 _decimals = 10 ** remainingDecimals;
        return _decimals;
    }

    function _convertToWantToken(uint256 _loanTokenAmount) internal returns (uint256) {
        uint256 decimalPrecisionWantToken = _calculateDecimals(want);
        uint256 decimalPrecisionLoanToken = _calculateDecimals(loanToken);

        uint256 wantTokenPrice = IPriceOracle(priceOracle).getAssetPrice(want) * FEED_PRECISION; // covert to 18 decimals
        uint256 loanTokenPrice = IPriceOracle(priceOracle).getAssetPrice(loanToken) * FEED_PRECISION; // covert to 18 decimals
        uint256 wantAmount;

        if (decimalPrecisionWantToken != 0 && decimalPrecisionLoanToken == 0) {
            wantAmount = _loanTokenAmount * loanTokenPrice / wantTokenPrice / decimalPrecisionWantToken;
        } else if (decimalPrecisionWantToken == 0 && decimalPrecisionLoanToken != 0) {
            wantAmount = _loanTokenAmount * decimalPrecisionLoanToken * loanTokenPrice / wantTokenPrice;
            //How much is 1e36 / 2e18 = 500000000000000000
        } else if (decimalPrecisionWantToken != 0 && decimalPrecisionLoanToken != 0) {
            wantAmount = _loanTokenAmount * decimalPrecisionLoanToken * loanTokenPrice / wantTokenPrice
                / decimalPrecisionWantToken;
        } else {
            wantAmount = _loanTokenAmount * loanTokenPrice / wantTokenPrice;
        }
        return wantAmount;
    }
    /* ------------------------------- PUBLIC VIEW FUNCTIONS ------------------------------ */

    function balanceOf() public view returns (uint256) {
        return _balanceOfWant() + _balanceOfPool() + _earned();
    }

    function adjustPosition() public onlyOwner {
        _adjustPosition();
    }
}
