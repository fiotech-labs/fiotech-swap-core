import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-ignition";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const { BNW_RPC_URL, BNW_TESTNET_RPC_URL, PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: false,
    },
    bnw: {
      url: BNW_TESTNET_RPC_URL || "",
      chainId: 999,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      gasPrice: 5_000_000_000,
    },
    bnwTestnet: {
      url: BNW_TESTNET_RPC_URL || "",
      chainId: 714,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      gasPrice: 5_000_000_000,
    },
  },
};

export default config;
