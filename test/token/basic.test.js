const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ALONEA basic", function() {
  it("deploys and mints", async function() {
    const [owner] = await ethers.getSigners();
    const Alonea = await ethers.getContractFactory("AloneaToken");
    const token = await Alonea.deploy(owner.address, owner.address);
    await token.deployed();
    const total = await token.totalSupply();
    expect(total).to.be.gt(0);
  });
});