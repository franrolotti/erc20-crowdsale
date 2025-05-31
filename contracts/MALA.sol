// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC1155, Ownable {
    constructor() ERC1155("https://myapi.com/api/item/{id}.json") {}

    event TokenMinted(address indexed to, uint256 id, uint256 amount);

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
        emit TokenMinted(account, id, amount);
    }
}
