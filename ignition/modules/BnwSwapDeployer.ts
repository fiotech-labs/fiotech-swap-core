import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import BnwSwapFactoryModule from "./BnwSwapFactoryModule";

export default buildModule("BnwSwapDeployer", (m) => {
  const tokenA = m.contract("ERC20", [1_000_000n * 10n ** 18n], {
    id: "TokenA",
  });
  const tokenB = m.contract("ERC20", [2_000_000n * 10n ** 18n], {
    id: "TokenB",
  });

  // Deploy Factory
  const { factory } = m.useModule(BnwSwapFactoryModule);

  // Create Pair
  const createPairTx = m.call(factory, "createPair", [tokenA, tokenB]);
  const pairAddress = m.readEventArgument(createPairTx, "PairCreated", "pair");

  // Get Pair Address
  // Note: The PairCreated event is emitted by the factory when a new pair is created.
  const pair = m.contractAt("BnwSwapPair", pairAddress);

  return { factory, tokenA, tokenB, pair };
});
