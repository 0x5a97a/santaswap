import { MerkleTree } from "merkletreejs";
import { getContracts } from "./contracts";
import { ChainId } from "@usedapp/core";
import keccak256 from "keccak256";

export const onTree = (chainId: ChainId | undefined, address: string) => {
  return getContracts(chainId).includes(address.toLowerCase());
};

export const getProof = (chainId: ChainId | undefined, address: string) => {
  const leaves = getContracts(chainId).map(keccak256);
  const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
  return tree.getHexProof(keccak256(address.toLowerCase()));
};
