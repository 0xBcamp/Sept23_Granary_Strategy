-include .env
.PHONY: all test deploy

deploy-fork:; forge script script/DeployVault.s.sol:DeployVault --rpc-url http://127.0.0.1:8545 --broadcast -vvv