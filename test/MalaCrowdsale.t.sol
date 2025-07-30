// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Mala.sol";
import "../src/MalaCrowdsale.sol";

contract MalaCrowdsaleTest is Test {
    /* ─── pricing constants ─── */
    uint256 constant PRICE_WEI = 532_000_000_000_000; // ≈$2/token @ 1 ETH=$3 758
    uint256 constant CAP       = 10 ether;
    uint256 constant GOAL      = 6  ether;

    address treasury = address(this);
    address alice    = address(0xA11CE);

    Mala          token;
    MalaCrowdsale sale;
    uint64  open; uint64 close;

    function setUp() public {
        vm.deal(alice, 100 ether);

        token = new Mala(treasury, 0);
        open  = uint64(block.timestamp + 1 hours);
        close = uint64(block.timestamp + 1 weeks);

        sale = new MalaCrowdsale(
            PRICE_WEI, CAP, GOAL, open, close, treasury, token
        );
        token.transferOwnership(address(sale));
    }

    /* ─── helpers ─── */
    function tokens(uint256 weiPaid) internal pure returns (uint256) {
        return (weiPaid / PRICE_WEI) * 1e18;
    }

    /* ─── only whole-token buys succeed ─── */
    function testWholeTokenPurchase() public {
        vm.warp(open);
        uint256 pay = 10 * PRICE_WEI;          // buys 10 tokens exactly
        vm.prank(alice);
        sale.buyTokens{value: pay}();

        assertEq(token.balanceOf(alice), tokens(pay));
    }

    function testFractionalPurchaseReverts() public {
        vm.warp(open);
        vm.expectRevert("must buy whole tokens");
        vm.prank(alice);
        sale.buyTokens{value: PRICE_WEI + 1 wei}();
    }

    /* other cap / goal / refund tests remain identical,
       replacing RATE-based math with PRICE_WEI-based math … */
}
