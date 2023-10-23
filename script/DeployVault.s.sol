// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {MaxiVault} from "../src/MaxiVault.sol";
import {Strategy} from "../src/Strategy.sol";

contract DeployVault is Script, Test {
    function run() external returns (address, address) {
        address want = 0x68f180fcCe6836688e9084f035309E29Bf0A2095; // WBTC
        address loanToken = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; //DAI
        address lendingPool = 0x794a61358D6845594F94dc1DB02A252b5b4814aD; //Aave lending pool
        address dataProvider = 0x69FA688f1Dc47d4B5d8029D5a35FB7a548310654; //Aave data provider
        address incentiveController = 0x929EC64c34a17401F460460D4B9390518E5B473e; //Aave incentive controller
        address priceOracle = 0xD81eb3728a631871a7eBBaD631b5f424909f0c77; //Aave price oracle returns 8dec
        address reaperVault = 0xc0F5DA4FB484CE6d8a6832819299F7cD0D15726E; //DAI vault

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);
        MaxiVault vault = new MaxiVault(want, "MaxiVault WBTC", "mvWBTC", 0, 50e8); //50 WBTC cap
        Strategy strategy = new Strategy(
            address(vault),
            want,
            loanToken,
            lendingPool,
            dataProvider,
            incentiveController,
            priceOracle,
            reaperVault
        );
        deal(want, msg.sender, 10e8, true);
        vm.stopBroadcast();
        return (address(vault), address(strategy));
    }
}
