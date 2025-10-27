/*******************************************************************************
 * Example Hardhat deployment script for ALONEA (Testnet)
 * Usage: npx hardhat run scripts/deploy/ALONEA.deploy.js --network sepolia
 ******************************************************************************/
const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with", deployer.address);

  const BurnReserve = process.env.BURN_RESERVE || "0x000000000000000000000000000000000000dEaD";
  const TreasuryAddr = deployer.address; // for test we use deployer as treasury

  const Alonea = await ethers.getContractFactory("AloneaToken");
  const token = await Alonea.deploy(BurnReserve, TreasuryAddr);
  await token.deployed();
  console.log("AloneaToken deployed at:", token.address);

  // simple vesting deploy (test)
  const FounderVesting = await ethers.getContractFactory("FounderVesting");
  const now = Math.floor(Date.now()/1000);
  const vest = await FounderVesting.deploy(token.address, deployer.address, now, 180*24*3600, 365*24*3600);
  await vest.deployed();
  console.log("FounderVesting deployed at:", vest.address);

  // transfer founder allocation to vesting contract (test)
  const founderAmount = ethers.utils.parseUnits("4400000000", 18);
  await token.transfer(vest.address, founderAmount);
  console.log("Founder allocation transferred to vesting (test).");
}

main().catch((e) => { console.error(e); process.exit(1); });
