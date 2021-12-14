import { useEthers } from "@usedapp/core";
import React, { useState } from "react";
import { getConfig } from "../config/contracts";
import { useNiceList, useSafeTransferFrom } from "../hooks/contracts";
import { constants, utils } from "ethers";
import { getProof, onTree } from "../merkleTree";

const Send = () => {
  const { chainId, account } = useEthers();
  const config = getConfig(chainId);
  const { onList } = useNiceList(account || "");

  const [tokenAddress, setTokenAddress] = useState<string>(
    constants.AddressZero
  );
  const [tokenId, setTokenId] = useState<string>("");
  const {
    state: { status, errorMessage },
    send: sendSafeTransferFrom,
  } = useSafeTransferFrom(tokenAddress);

  const onTokenAddressChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    try {
      setTokenAddress(utils.getAddress(e.target.value));
    } catch {
      setTokenAddress(constants.AddressZero);
    }
  };

  const onTokenIdChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setTokenId(e.target.value);
  };

  const sendToken = async () => {
    const proof = getProof(chainId, tokenAddress);
    const bytes = utils.defaultAbiCoder.encode(["bytes32[]"], [proof]);
    await sendSafeTransferFrom(
      account,
      config.santaswap.address,
      tokenId,
      bytes
    );
  };

  return (
    <div className="flex flex-col mb-8 md:w-1/2 lg:w-1/3">
      <p className="mb-6 text-center font-semibold">
        ✨ Santa hasn't visited yet. ✨
      </p>
      {onList ? (
        <div className="text-center">
          <p>You're on Santa's Nice List.</p>
          <p>Come back on Christmas morning to unwrap your gift.</p>
        </div>
      ) : (
        <>
          <label className="mb-2">
            Token address
            <input
              className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              onChange={onTokenAddressChange}
            />
          </label>
          {onTree(chainId, tokenAddress) ? (
            <div>
              <label className="mb-2">
                Token ID
                <input
                  className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                  onChange={onTokenIdChange}
                />
              </label>
              <button
                className="my-4 w-1/2 bg-gradient-to-tr from-red-800 to-red-600 hover:from-red-900 hover:to-red-800 text-white font-semibold py-2 px-4 rounded-lg shadow"
                disabled={status === "Mining"}
                onClick={sendToken}
              >
                Send token
              </button>
              <div>
                <p>{errorMessage}</p>
              </div>
            </div>
          ) : (
            <p>
              {tokenAddress === constants.AddressZero
                ? "Enter an ERC721 token address."
                : "This token is not on Santa's Christmas tree."}
            </p>
          )}
        </>
      )}
    </div>
  );
};

export default Send;
