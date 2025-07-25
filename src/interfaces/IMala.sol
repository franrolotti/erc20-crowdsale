// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IMalaEvents {
    event TokenMinted(address indexed to, uint256 id, uint256 amount);
    event TokenBurned(address indexed from, uint256 id, uint256 amount);
}
