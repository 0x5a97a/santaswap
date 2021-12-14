import { useContractCall, useContractFunction, useEthers } from "@usedapp/core";
import { Contract } from "ethers";
import { getConfig } from "../config/contracts";

export function useChristmasMagic() {
  const { chainId } = useEthers();
  const config = getConfig(chainId);
  const [christmasMagic] =
    useContractCall({
      abi: config.santaswap.abi,
      address: config.santaswap.address,
      method: "christmasMagic",
      args: [],
    }) ?? [];
  console.log(christmasMagic);
  return { christmasMagic };
}

export function useChristmasMorning() {
  const { chainId } = useEthers();
  const config = getConfig(chainId);
  const [christmasMorning] =
    useContractCall({
      abi: config.santaswap.abi,
      address: config.santaswap.address,
      method: "CHRISTMAS_MORNING",
      args: [],
    }) ?? [];
  return { christmasMorning };
}

export function useTotalGifts() {
  const { chainId } = useEthers();
  const config = getConfig(chainId);
  const [totalGifts] =
    useContractCall({
      abi: config.santaswap.abi,
      address: config.santaswap.address,
      method: "totalGifts",
      args: [],
    }) ?? [];
  return { totalGifts };
}

export function useNiceList(address: string) {
  const { chainId } = useEthers();
  const config = getConfig(chainId);
  const [id] =
    useContractCall(
      address && {
        abi: config.santaswap.abi,
        address: config.santaswap.address,
        method: "niceList",
        args: [address],
      }
    ) ?? [];
  const onList = id && id.gt(0);
  return { onList };
}

export function useClaims(address: string) {
  const { chainId } = useEthers();
  const config = getConfig(chainId);
  const [claimed] =
    useContractCall(
      address && {
        abi: config.santaswap.abi,
        address: config.santaswap.address,
        method: "claims",
        args: [address],
      }
    ) ?? [];
  return { claimed };
}

export function useUnwrapGift() {
  const { chainId } = useEthers();
  const config = getConfig(chainId);
  const contract = new Contract(config.santaswap.address, config.santaswap.abi);
  return useContractFunction(contract, "unwrapGift", {
    transactionName: "Unwrap Gift",
  });
}

export function useSafeTransferFrom(erc721Address: string) {
  const { chainId } = useEthers();
  const config = getConfig(chainId);
  const contract = new Contract(erc721Address, config.erc721.abi);
  return useContractFunction(contract, "safeTransferFrom", {
    transactionName: "Send Token",
  });
}
