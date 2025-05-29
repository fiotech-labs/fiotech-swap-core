import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("BnwSwapFactoryModule", (m) => {
  const feeToSetter = m.getAccount(0);

  const factory = m.contract("BnwSwapFactory", [feeToSetter]);

  return { factory };
});
