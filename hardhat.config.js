require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: process.env.NODE_URL_SEPOLIA || "",
      accounts: process.env.PRIVATE_KEY_DEPLOYER ? [process.env.PRIVATE_KEY_DEPLOYER] : []
    }
  }
};
