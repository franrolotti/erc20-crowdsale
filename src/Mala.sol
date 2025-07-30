// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

/// @title Mala Token (ERC-20)
/// @dev Owner can mint & burn *token-units* that are already expressed in 18-decimals.
contract Mala is ERC20, Ownable {
    /// @param initialOwner  address that will own the contract and receive the initial supply
    /// @param initialSupply whole-token units ( *not* wei ) that the owner receives on deployment
    constructor(address initialOwner, uint256 initialSupply)
        ERC20("Mala Token", "MALA")
        Ownable(initialOwner)
    {
        _mint(initialOwner, initialSupply);
    }

    /// @notice Mint new tokens to an account (onlyOwner)
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /// @notice Burn tokens from an account (onlyOwner)
    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
