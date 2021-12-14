import { ChainId, Config } from "@usedapp/core";

const config: Config = {
  notifications: {
    checkInterval: 500,
    expirationPeriod: 15000,
  },
  readOnlyChainId: ChainId.Mainnet,
  readOnlyUrls: {
    [ChainId.Mainnet]:
      "https://eth-mainnet.alchemyapi.io/v2/-dtoNUGXZ_H-LqbnB9DPGJbxMYxAYIUv",
    [ChainId.Hardhat]: "http://localhost:8545",
    [ChainId.Rinkeby]:
      "https://eth-rinkeby.alchemyapi.io/v2/cpnGlVveYOl5GWhUvnjWEDY5YCrxVUSo",
  },
  multicallAddresses: {
    [ChainId.Hardhat]: "0x5c74c94173F05dA1720953407cbb920F3DF9f887",
  },
};

export default config;
