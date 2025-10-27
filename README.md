
# ALONEA (ALO) Testnet Config - Sepolia

This repository is a testnet-ready skeleton for the ALONEA token (test). It includes sample contracts, deploy scripts, and basic configuration for running on Sepolia via Hardhat.

## What is included
- contracts/token/AloneaToken.sol (ERC20 with basic fee/burn logic - test)
- contracts/token/FounderVesting.sol
- contracts/treasury/Treasury.sol
- contracts/liquidity/LockVault.sol
- contracts/proxy/ProxyAdmin.sol
- scripts/deploy/ALONEA.deploy.js
- scripts/migrate/ALONEA.migrate.js
- hardhat.config.js, package.json, .env.example
- metadata/Alo_testnet.json
- test/ (basic example)

## Quickstart (Hardhat)
1. Copy `.env.example` to `.env` and fill values.
2. npm install
3. npx hardhat compile
4. npx hardhat run scripts/deploy/ALONEA.deploy.js --network sepolia

> Note: This is a testnet skeleton. Audit and security hardening required before mainnet deployment.
