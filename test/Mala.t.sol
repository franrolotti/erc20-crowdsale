// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Mala.sol";

contract MalaTest is Test {
    Mala    public mala;
    address public owner;
    address public user;

    uint256 constant INIT_SUPPLY = 1_000_000 * 1e18;   // premint in 18-dec units

    function setUp() public {
        owner = address(this);
        user  = address(0xBEEF);

        mala = new Mala(owner, INIT_SUPPLY);
    }

    /* ───────── initial state ───────── */

    function testInitialSupplyToOwner() public view {
        assertEq(mala.totalSupply(),    INIT_SUPPLY);
        assertEq(mala.balanceOf(owner), INIT_SUPPLY);
    }

    /* ───────── mint ───────── */

    function testMintByOwner() public {
        uint256 amt = 1_000 * 1e18;
        mala.mint(user, amt);

        assertEq(mala.balanceOf(user), amt);
        assertEq(mala.totalSupply(),   INIT_SUPPLY + amt);
    }

    function testMintByNonOwnerShouldRevert() public {
        vm.prank(user);
        vm.expectRevert(); 
        mala.mint(user, 1_000 * 1e18);
    }

    /* ───────── burn ───────── */

    function testBurnByOwner() public {
        uint256 mintAmt = 2_000 * 1e18;
        mala.mint(user, mintAmt);

        uint256 burnAmt = 500 * 1e18;
        mala.burn(user, burnAmt);

        assertEq(mala.balanceOf(user), mintAmt - burnAmt);
        assertEq(mala.totalSupply(),   INIT_SUPPLY + (mintAmt - burnAmt));
    }

    function testBurnExceedingBalanceShouldRevert() public {
        vm.expectRevert();
        mala.burn(user, 1e18);   // user has zero balance
    }
}
