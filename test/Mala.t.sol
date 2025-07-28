// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Mala.sol";

contract MalaTest is Test {
    Mala    public mala;
    address public owner;
    address public user;

    // 1 000 000 MALA initial supply
    uint256 constant INIT_SUPPLY = 1_000_000;

    function setUp() public {
        owner = address(this);      // test contract = owner
        user  = address(0xBEEF);

        mala = new Mala(owner, INIT_SUPPLY);
    }

    function testInitialSupplyToOwner() public view {
        assertEq(mala.totalSupply(), INIT_SUPPLY * 1e18);
        assertEq(mala.balanceOf(owner), INIT_SUPPLY * 1e18);
    }

    function testMintByOwner() public {
        uint256 amt = 1_000;
        mala.mint(user, amt);

        assertEq(mala.balanceOf(user), amt * 1e18);
        assertEq(mala.totalSupply(), (INIT_SUPPLY + amt) * 1e18);
    }

    function testMintByNonOwnerShouldRevert() public {
        vm.prank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        mala.mint(user, 1_000);
    }

    function testBurnByOwner() public {
        mala.mint(user, 2_000);
        mala.burn(user, 500);

        assertEq(mala.balanceOf(user), 1_500 * 1e18);
        assertEq(mala.totalSupply(), (INIT_SUPPLY + 1_500) * 1e18);
    }

    function testBurnExceedingBalanceShouldRevert() public {
        vm.expectRevert("ERC20: burn amount exceeds balance");
        mala.burn(user, 1);
    }
}
