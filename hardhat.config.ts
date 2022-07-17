import { HardhatUserConfig } from "hardhat/types";
import "hardhat-deploy";
import "hardhat-deploy-ethers";
import "solidity-coverage";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.13",
  },
  namedAccounts: {
    deployer: 0,
  },
  paths: {
    sources: "src",
  },
};
export default config;
