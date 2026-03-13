// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

error AlreadyClaimed();
error InvalidProof();
error TransferFailed();

contract MerkleAirdrop is ReentrancyGuard {
    address public immutable token;
    bytes32 public immutable merkleRoot;

    // Track claimed status for each index to prevent double claims
    mapping(uint256 => bool) private claimedBitMap;

    event Claimed(uint256 index, address account, uint256 amount);

    constructor(address _token, bytes32 _merkleRoot) {
        token = _token;
        merkleRoot = _merkleRoot;
    }

    function isClaimed(uint256 index) public view returns (bool) {
        return claimedBitMap[index];
    }

    /**
     * @dev Claim tokens using a Merkle proof.
     * @param index The index in the original list.
     * @param account The address claiming the tokens.
     * @param amount The amount of tokens to claim.
     * @param merkleProof The cryptographic proof that the leaf exists in the tree.
     */
    function claim(
        uint256 index,
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external nonReentrant {
        if (isClaimed(index)) revert AlreadyClaimed();

        // Verify the merkle proof
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        if (!MerkleProof.verify(merkleProof, merkleRoot, node)) revert InvalidProof();

        // Mark it claimed and send tokens
        claimedBitMap[index] = true;
        bool success = IERC20(token).transfer(account, amount);
        if (!success) revert TransferFailed();

        emit Claimed(index, account, amount);
    }
}
