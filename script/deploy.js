const { ethers } = require("hardhat");
async function main() {
  const want = " 0x68f180fcCe6836688e9084f035309E29Bf0A2095"; // WBTC
  const loanToken = " 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1"; //DAI
  const lendingPool = " 0x794a61358D6845594F94dc1DB02A252b5b4814aD"; //Aave lending pool
  const dataProvider = " 0x69FA688f1Dc47d4B5d8029D5a35FB7a548310654"; //Aave data provider
  const incentiveController = " 0x929EC64c34a17401F460460D4B9390518E5B473e"; //Aave incentive controller
  const priceOracle = " 0xD81eb3728a631871a7eBBaD631b5f424909f0c77"; //Aave price oracle returns 8dec
  const reaperVault = " 0xc0F5DA4FB484CE6d8a6832819299F7cD0D15726E"; //DAI vault

  const vault = await ethers.deployContract("MaxiVault", [
    want,
    "MaxiVault WBTC",
    "mvWBTC",
    0,
    50e8,
  ]);
  await vault.waitForDeployment();

  const strategy = await ethers.deployContract("Strategy", [
    vault.target,
    want,
    loanToken,
    lendingPool,
    dataProvider,
    incentiveController,
    priceOracle,
    reaperVault,
  ]);

  console.log(`vault  deployed to ${vault.target}`);
  console.log(`strategy deployed to ${vault.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
