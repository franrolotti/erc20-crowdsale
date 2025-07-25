// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./interfaces/IMala.sol";


contract Mala is ERC1155, Ownable, IMalaEvents {
    // Track total supply per token ID
    mapping(uint256 => uint256) private _totalSupply;

    constructor(address initialOwner)
        ERC1155("https://myapi.com/api/item/{id}.json")
        Ownable(initialOwner)
    {}


    // Return total supply for a token ID
    function totalSupply(uint256 id) public view returns (uint256) {
        return _totalSupply[id];
    }


    // Check if a token ID exists (has non-zero supply)
    function exists(uint256 id) public view returns (bool) {
        return _totalSupply[id] > 0;
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
        _totalSupply[id] += amount;
        emit TokenMinted(account, id, amount);
    }

    function burn(address account, uint256 id, uint256 amount) public onlyOwner {
        require(_totalSupply[id] >= amount, "Burn exceeds supply");
        _burn(account, id, amount);
        _totalSupply[id] -= amount;
        emit TokenBurned(account, id, amount);
    }


}
