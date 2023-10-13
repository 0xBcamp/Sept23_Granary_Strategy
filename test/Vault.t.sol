// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ForkHelper} from "./ForkHelper.sol";
import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

contract VaultTest is ForkHelper {
    uint256 public constant DEPOSIT_AMT = 10e8;
    uint256 public constant PRECISION_DECIMALS = 1e10;

    function setUp() public override {
        super.setUp(); // setup the contracts and state
    }

    modifier fundUsers() {
        deal(address(want), user1, DEPOSIT_AMT, true); // fund user1 with 100 WBTC
        deal(address(want), user2, DEPOSIT_AMT, true); // fund user2 with 10 WBTC
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
}
