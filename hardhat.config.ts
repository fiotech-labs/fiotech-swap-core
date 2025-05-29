import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-ignition";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const { BNW_RPC_URL, PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    mainnet: {
      url: BNW_RPC_URL || "",
      chainId: 714,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      initialBaseFeePerGas: 0,
      gasPrice: 10_000_000_000,
    },
  },
};

export default config;
