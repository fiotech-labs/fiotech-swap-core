import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("FiotechSwapFactoryModule", (m) => {
  const feeToSetter = m.getAccount(0);

  const factory = m.contract("FiotechSwapFactory", [feeToSetter]);

  return { factory };
});
