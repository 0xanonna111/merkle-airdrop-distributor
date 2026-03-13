const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');
const { ethers } = require('ethers');

// Example data
const recipients = [
  { index: 0, address: "0xAbc...", amount: "100" },
  { index: 1, address: "0xDef...", amount: "200" }
];

const leaves = recipients.map(x => 
  keccak256(ethers.solidityPacked(["uint256", "address", "uint256"], [x.index, x.address, x.amount]))
);

const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
const root = tree.getHexRoot();

console.log("Merkle Root:", root);

// Generate proof for the first user
const proof = tree.getHexProof(leaves[0]);
console.log("Proof for User 0:", proof);
