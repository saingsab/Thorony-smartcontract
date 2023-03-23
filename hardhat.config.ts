import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require('dotenv').config()

const config: HardhatUserConfig = {
  paths: { tests: "tests" },
  solidity: "0.8.18",
  networks: {
    hardhat: {},
    ETH_GOERLI: {
			accounts: [`${process.env.PRIVATE_KEY}`],
			url: `https://eth-goerli.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`
		}
  },
  etherscan: {
		apiKey: `${process.env.ETHERSCAN_API_KEY}`
	}
};

export default config;
