-include .env
.PHONY: all test deploy

deploy:; forge script script/DeployVault.s.sol:DeployVault --rpc-url http://127.0.0.1:8545 --broadcast -vvv && cast rpc anvil_impersonateAccount 0xF6858Cb1AA854D7856afC5e7B2d160CE3ea63F5f && cast send 0x68f180fcCe6836688e9084f035309E29Bf0A2095 --unlocked --from 0xF6858Cb1AA854D7856afC5e7B2d160CE3ea63F5f "transfer(address,uint256)(bool)" ${WALLET_ADDRESS} 1000000000

start-fork:; anvil --fork-url ${RPC_URL} 