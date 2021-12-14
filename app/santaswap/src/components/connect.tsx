import { shortenAddress, useEthers } from "@usedapp/core";
import { useCallback } from "react";

const Connect = () => {
  const { activateBrowserWallet, account } = useEthers();

  const connect = useCallback(() => {
    activateBrowserWallet();
  }, [activateBrowserWallet]);

  return (
    <div className="fixed top-2 right-6 text-sm md:text-lg">
      <button
        className="my-4 bg-gradient-to-tr from-green-800 to-green-600 hover:from-green-900 hover:to-green-800 text-white font-md lg:text-lg font-semibold py-1 px-2 md:px-4 rounded-lg shadow"
        onClick={connect}
      >
        {account ? shortenAddress(account) : "Connect"}
      </button>
    </div>
  );
};

export default Connect;
