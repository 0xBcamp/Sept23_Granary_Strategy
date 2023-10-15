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
- [ ] Determine whether _adjustPosition function will be triggered manually or automatically

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

