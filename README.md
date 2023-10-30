# Maxi Gain - Multi-Asset Strategy

MaxiGain is a smart contract-based solution that provides users with a secure and flexible way to manage their funds in DeFi. It offers features such as depositing, earning, and withdrawing funds while implementing risk management controls, deposit fees, and TVL caps. This README provides an overview of the MaxiVault project, how to use it, and important details for developers and users.

MaxiGain is a multi-asset strategy that converts the base asset into high-yield assets and deposits them into the Reaper Vault.

## Set up

```shell
git clone git@github.com:0xBcamp/Sept23_Granary_Strategy.git

cd Sept23_Granary_Strategy

forge install

```

- Now create .env file and add your RPC_URL. see .env.example

```
forge test
```

## How to run frontend

if you would like to run the frontend for this project you will need to setup a few things first.This is because we are using a fork test environment to simulate real world transactions.

follow the below steps carefully

- Create .env and fill the RPC_URL_ALCHEMY. You can get one from alchemy make sure to get the optimism mainnet rpc.
- Initialize fork in local anvil chain using `make start-fork`
- If you did the above steps correctly, anvil should display some private key and their corresponding addresses.
- Now copy that private key and corresponding address, add to the .env(reference .env.example).
- Go to metamask and add new network.
- Add RPC as http://http://127.0.0.1:8545, chain id as 10 and Currency symbol as GO.
- After adding network, click on the import account and paste anvil private key in there.
- You should see the address with 1000GO token.

You have successfully completed the wallet setup :)

## Now last step

- `make deploy`, this will deploy all the neccessary contracts to the anvil op fork.
- `make fund`, this will fund your wallet with 3 WBTC to play with, if for some reason this fails check your wallet address in .env or go to makefile and make sure the address we are doing anvil_impersonateAccount have 3 WBTC and some OP ETH.

- `cd frontend`
- `npm run dev`

You should be good to goo.

### Completed tasks

- [x] setup vault contract
- [x] deposit and borrow from aave successful
- [x] Fork test environment setup
- [x] Successfully run vault tests for deposits.
- [x] Handled the number of decimal places for the "want" token during deposit.
- [x] added functions for risk management, fee handling and security.

### TODO

Specific Strategy Enhancements:

- [ ] Complete vault test
- [ ] Maintain the collateral ratio at 200% while borrowing from Aave
- [ ] Monitor the health factor with each deposit. If the health factor falls below 2e18, calculate the amount that can be repaid to raise the health factor to 2e18. Note that the minimum health factor to maintain is still undetermined.
- [ ] Thoroughly test the strategy.
- [ ] Monitor potential profit/loss by subtracting Reaper Deposit - Debt. Determine the course of action in the event of a loss.
- [ ] Determine whether \_adjustPosition function will be triggered manually or automatically

Implement Automated Position Management:

- [ ] Define rules for auto-adjustments.
- [ ] Optimize positions based on health, profit/loss, and assets.

Monitor Health Factor:

- [ ] Continuously track health factor
- [ ] Set a critical threshold
- [ ] Handle Profit/Loss
- [ ] Create logic for profit/loss
- [ ] Plan actions for losses and profit optimization.

Test Thoroughly:

- [ ] Ensure new features work as expected.
- [ ] Validate strategy compliance.

Update Documentation:

- [ ] Explain new features.
