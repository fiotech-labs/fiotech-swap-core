import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("ERC20Module", (m) => {
  const initialSupply = m.getParameter<bigint>(
    "initialSupply",
    1_000_000n * 10n ** 18n
  );

  const token = m.contract("ERC20", [initialSupply]);

  return { token };
});
