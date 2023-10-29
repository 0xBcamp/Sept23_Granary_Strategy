-include .env
.PHONY: all test deploy

deploy:; forge script script/DeployVault.s.sol:DeployVault --rpc-url ${RPC_URL_TENDERLY}  --broadcast -vvv
#  && cast rpc anvil_impersonateAccount 0xeC53aB6f6A2c5112c2a361D1f2B01F170824A5Ce  && cast send 0x68f180fcCe6836688e9084f035309E29Bf0A2095 --unlocked --from 0xeC53aB6f6A2c5112c2a361D1f2B01F170824A5Ce "transfer(address,uint256)(bool)" ${WALLET_ADDRESS} 300000000 

start-fork:; anvil --fork-url ${RPC_URL} 