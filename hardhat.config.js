require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: process.env.NODE_URL_SEPOLIA || "https://sepolia.drpc.org",
      accounts: process.env.PRIVATE_KEY_DEPLOYER
        ? [process.env.PRIVATE_KEY_DEPLOYER]
        : [],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
