// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Mala.sol";

contract MalaTest is Test {
    Mala public mala;
    address public owner;
    address public user;

    function setUp() public {
        owner = address(this);          // The test contract is the owner
        user = address(0xBEEF);
        mala = new Mala(owner);         // ✅ Constructor requires initialOwner
    }

    function testMintByOwner() public {
        uint256 tokenId = 1;
        uint256 amount = 100;

        mala.mint(user, tokenId, amount, "");

        assertEq(mala.balanceOf(user, tokenId), amount);
        assertEq(mala.totalSupply(tokenId), amount);
    }

    function testMintByNonOwnerShouldRevert() public {
        vm.prank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        mala.mint(user, 1, 100, "");
    }

    function testBurnByOwner() public {
        uint256 tokenId = 2;
        mala.mint(user, tokenId, 50, "");
        mala.burn(user, tokenId, 20);

        assertEq(mala.balanceOf(user, tokenId), 30);
        assertEq(mala.totalSupply(tokenId), 30);
    }

    function testBurnExceedingAmountShouldRevert() public {
        uint256 tokenId = 3;
        mala.mint(user, tokenId, 10, "");
        vm.expectRevert("Burn exceeds supply");
        mala.burn(user, tokenId, 20);
    }

    function testExists() public {
        uint256 tokenId = 4;
        assertFalse(mala.exists(tokenId));
        mala.mint(user, tokenId, 1, "");
        assertTrue(mala.exists(tokenId));
    }
}
