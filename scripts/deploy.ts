import hre from "hardhat";
import FiotechSwapDeployer from "../ignition/modules/FiotechSwapDeployer";

async function main() {
  const { factory, tokenA, tokenB, pair } = await hre.ignition.deploy(
    FiotechSwapDeployer
  );

  console.log({
    factory: await factory.getAddress(),
    tokenA: await tokenA.getAddress(),
    tokenB: await tokenB.getAddress(),
    pair: pair,
  });
}

main().catch(console.error);
