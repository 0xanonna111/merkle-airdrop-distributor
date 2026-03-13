# Merkle Airdrop Distributor

A professional solution for large-scale token distributions. Instead of storing a list of thousands of eligible addresses on-chain (which is prohibitively expensive), this contract stores a single 32-byte Merkle Root.

### How it Works
1. **Off-Chain:** Generate a Merkle Tree from a list of eligible addresses and amounts. 
2. **On-Chain:** Deploy this contract with the Merkle Root.
3. **Claim:** Users provide a "Merkle Proof" to the contract. The contract verifies the proof against the root to validate the claim.

### Advantages
* **Ultra-Low Gas:** Deployment cost is constant regardless of the number of recipients.
* **Security:** Cryptographic proof ensures only intended users can claim intended amounts.
* **Anti-Double Claim:** Uses a mapping to ensure each leaf in the tree can only be claimed once.

### Usage
Use the provided `generateMerkle.js` script to create your root and proofs from a JSON whitelist.
