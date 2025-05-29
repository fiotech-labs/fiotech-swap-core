import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-ignition";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: false,
    },
    bnw: {
      url: `http://174.138.18.77:8545`,
    },
  },
};

export default config;
