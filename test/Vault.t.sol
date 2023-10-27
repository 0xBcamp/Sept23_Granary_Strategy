// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ForkHelper} from "./ForkHelper.sol";
import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract VaultTest is ForkHelper {
    uint256 DEPOSIT_AMT = 10e8;
    uint256 PRECISION_DECIMALS = 1e10;
    uint256 REAPER_SHARES_AFTER_FEES = 130095919192963941529041;

    function setUp() public override {
        super.setUp(); // setup the contracts and state
    }

    /* ------------------------------- HELPERS------------------------------- */

    /**
     * @dev simulate the rewards from reaper vaults
     */
    function increaseVaultWantBalance(uint256 amount) internal {
        deal(address(want), address(maxiVault), amount, true);
    }

    modifier fundUsers() {
        deal(address(want), user1, DEPOSIT_AMT, true); // fund user1 with 10 WBTC
        deal(address(want), user2, DEPOSIT_AMT, true); // fund user2 with 10 WBTC
        deal(address(loanToken), address(user1), 1000e18, true);
        _;
    }
    /* ------------------------------- CONSTRUCTOR ------------------------------ */

    function test_constructor() public {
        assertEq(address(maxiVault.token()), address(want));
        assertEq(maxiVault.name(), "MaxiVault WBTC");
        assertEq(maxiVault.symbol(), "mvWBTC");
        assertEq(maxiVault.depositFee(), 0);
        assertEq(maxiVault.tvlCap(), 50e8);
        assertEq(maxiVault.PERCENT_DIVISOR(), 10000);
        assertEq(maxiVault.initialized(), true);
        assertEq(maxiVault.balance(), 0);
        assertEq(maxiVault.available(), 0);
    }

    function test_depositShoulFailIfAmountIsZero() public {
        vm.expectRevert("please provide amount");
        maxiVault.deposit(0);
    }

    function test_shouldFailWhenDepositCapIsReached() public fundUsers {
        vm.startPrank(user1);
        want.approve(address(maxiVault), 60e8);
        vm.expectRevert("vault is full!");
        maxiVault.deposit(60e8);
        vm.stopPrank();
    }

    function test_mintSharesOnDepositSuccess() public fundUsers {
        vm.startPrank(user1);
        want.approve(address(maxiVault), DEPOSIT_AMT);
        maxiVault.deposit(DEPOSIT_AMT);
        assertEq(maxiVault.balanceOf(user1), DEPOSIT_AMT);
        vm.stopPrank();
    }

    function test_shouldIncreaseCummulativeDeposit() public fundUsers {
        vm.startPrank(user1, user1); // set sender and origin to user1

        want.approve(address(maxiVault), DEPOSIT_AMT);
        maxiVault.deposit(DEPOSIT_AMT);
        assertEq(maxiVault.cumulativeDeposits(user1), DEPOSIT_AMT);

        vm.stopPrank();
    }

    function test_shouldReceiveReaperVaultTokenOnDeposit() public fundUsers {
        vm.startPrank(user1, user1); // set sender and origin to user1

        want.approve(address(maxiVault), DEPOSIT_AMT);
        maxiVault.deposit(DEPOSIT_AMT);
        assertEq(IERC20(address(reaperVault)).balanceOf(address(strategy)), REAPER_SHARES_AFTER_FEES);

        vm.stopPrank();
    }

    function test_shouldWithdrawPortionOfShares() public fundUsers {
        vm.startPrank(user1, user1); // set sender and origin to user1

        want.approve(address(maxiVault), DEPOSIT_AMT);
        maxiVault.deposit(DEPOSIT_AMT);
        console2.log("User want bal before withdraw", want.balanceOf(address(user1)));
        assertEq(maxiVault.balanceOf(user1), DEPOSIT_AMT);
        assertEq(want.balanceOf(address(user1)), 0);
        maxiVault.withdraw(5e8); //only 1e8 shares out of 10e8
        assertEq(maxiVault.balanceOf(user1), DEPOSIT_AMT - 5e8);
        assertEq(want.balanceOf(address(user1)), 5e8);
        console2.log("User want bal after withdraw", want.balanceOf(address(user1)));
        vm.stopPrank();
    }

    function test_shouldWithdrawWithReturns() public fundUsers {
        //NOTE: This test is not complete

        vm.startPrank(user1, user1); // set sender and origin to user1

        want.approve(address(maxiVault), DEPOSIT_AMT);
        maxiVault.deposit(DEPOSIT_AMT);
        assertEq(maxiVault.balanceOf(user1), DEPOSIT_AMT);
        assertEq(want.balanceOf(address(user1)), 0);
        IERC20(address(loanToken)).transfer(address(reaperVault), 1000e18);

        console2.log("bal beforewithdraw", IERC20(loanToken).balanceOf(address(reaperVault)));
        maxiVault.withdraw(5e8); //only 5e8 shares out of 10e8
        console2.log("bal after withdraw", IERC20(loanToken).balanceOf(address(reaperVault)));
        assertEq(maxiVault.balanceOf(user1), DEPOSIT_AMT - 5e8);
        console2.log("User want bal after withdraw", want.balanceOf(address(user1)));
        // assertEq(want.balanceOf(address(user1)), 5e8);
        vm.stopPrank();
    }

    function test_shouldWithdrawAllShares() public fundUsers {
        vm.startPrank(user1, user1); // set sender and origin to user1

        want.approve(address(maxiVault), DEPOSIT_AMT);
        maxiVault.deposit(DEPOSIT_AMT);
        console2.log("User want bal before withdraw", want.balanceOf(address(user1)));
        assertEq(maxiVault.balanceOf(user1), DEPOSIT_AMT);
        assertEq(want.balanceOf(address(user1)), 0);

        // maxiVault.withdraw(maxiVault.balanceOf(user1));
        maxiVault.withdraw(10e8);
        assertEq(maxiVault.balanceOf(user1), 0);
        console2.log("User want bal after withdraw", want.balanceOf(address(user1)));
        vm.stopPrank();
    }
}
