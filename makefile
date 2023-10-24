-include .env
.PHONY: all test deploy

deploy-fork:; forge script script/DeployVault.s.sol:DeployVault --rpc-url http://127.0.0.1:8545 --broadcast -vvv
start-fork:; anvil --fork-url ${RPC_URL} 
send-funds:; cast rpc anvil_impersonateAccount 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1  && cast send 0x68f180fcCe6836688e9084f035309E29Bf0A2095 --unlocked --from 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1 "transfer(address,uint256)(bool)" ${WALLET_ADDRESS} 1000000000