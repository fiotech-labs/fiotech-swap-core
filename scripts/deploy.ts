import hre from "hardhat";
import BnwSwapDeployer from "../ignition/modules/BnwSwapDeployer";

async function main() {
  const { factory, tokenA, tokenB, pair } = await hre.ignition.deploy(
    BnwSwapDeployer
  );

  console.log({
    factory: await factory.getAddress(),
    tokenA: await tokenA.getAddress(),
    tokenB: await tokenB.getAddress(),
    pair: pair,
  });
}

main().catch(console.error);
