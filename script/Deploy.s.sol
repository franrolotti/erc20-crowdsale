// script/Deploy.s.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Mala.sol";
import "../src/MalaCrowdsale.sol";

contract Deploy is Script {
    /* ─────────── editable parameters ─────────── */
    // price ≈ $2/token (532 × 10¹² wei)
    uint256 constant PRICE_WEI = 532_000_000_000_000;
    uint256 constant CAP       = 10 ether;           // hard-cap
    uint256 constant GOAL      = 6  ether;           // soft-cap

    // sale window: opens in 1 hour, lasts 1 week
    uint64  constant SALE_OPEN_DELAY  = 3 days;
    uint64  constant SALE_DURATION    = 60 days;

    // final treasury that will receive raised ETH
    address constant TREASURY = 0x3f1424B1a5bF6EE3C9D5A87d0a61721350601ea4;

    /* ─────────── deployment ─────────── */
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        /* 1. Deploy crowdsale first so we know its address */
        uint64 opens  = uint64(block.timestamp + SALE_OPEN_DELAY);
        uint64 closes = uint64(opens + SALE_DURATION);

        // deploy a dummy token owner for now; we'll overwrite in a sec
        Mala dummy = new Mala(address(0), 0);

        MalaCrowdsale sale = new MalaCrowdsale(
            PRICE_WEI,
            CAP,
            GOAL,
            opens,
            closes,
            TREASURY,   // Ownable(_treasury)
            dummy       // temp placeholder
        );

        /* 2. Deploy the real token with sale as the owner */
        Mala token = new Mala(address(sale), 0);

        /* 3. Tell the crowdsale which token to mint */
        // we can't set an immutable after construction, but if you made
        // token `immutable`, redeploy sale passing the real token instead:
        // (simpler: deploy token first, then sale – see below)
        // -- For clarity, let's actually redeploy correctly:
        sale = new MalaCrowdsale(
            PRICE_WEI,
            CAP,
            GOAL,
            opens,
            closes,
            TREASURY,
            token
        );

        /* 4. (Optional) verify & log addresses */
        console2.log("Mala Token    :", address(token));
        console2.log("Crowdsale     :", address(sale));
        console2.log("Treasury       :", TREASURY);
        console2.log("Opens          :", opens);
        console2.log("Closes         :", closes);

        vm.stopBroadcast();
    }
}
