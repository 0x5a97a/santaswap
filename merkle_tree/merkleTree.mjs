import { MerkleTree } from 'merkletreejs';
import keccak256 from 'keccak256';
import contracts from './contracts.mjs';

const leaves = contracts.contracts.map(keccak256);
const tree = new MerkleTree(leaves, keccak256, {sortPairs: true});
const root = tree.getHexRoot();

console.log(root);
console.log(tree.getHexProof(keccak256("0x2eeee40b14489acbef91551a9862b962cb2756ce")));
