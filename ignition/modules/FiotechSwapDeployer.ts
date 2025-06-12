import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import FiotechSwapFactoryModule from "./FiotechSwapFactoryModule";

export default buildModule("FiotechSwapDeployer", (m) => {
  const tokenA = m.contract("ERC20", [1_000_000n * 10n ** 18n], {
    id: "TokenA",
  });
  const tokenB = m.contract("ERC20", [2_000_000n * 10n ** 18n], {
    id: "TokenB",
  });

  // Deploy Factory
  const { factory } = m.useModule(FiotechSwapFactoryModule);

  // Create Pair
  const createPairTx = m.call(factory, "createPair", [tokenA, tokenB]);
  const pairAddress = m.readEventArgument(createPairTx, "PairCreated", "pair");

  // Get Pair Address
  // Note: The PairCreated event is emitted by the factory when a new pair is created.
  const pair = m.contractAt("FiotechSwapPair", pairAddress);

  return { factory, tokenA, tokenB, pair };
});
