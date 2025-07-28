// script/Deploy.s.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Mala.sol";

contract Deploy is Script {
    function run() external {
        // read your deployer key however you prefer
        uint256 pk = vm.envUint("PRIVATE_KEY");

        address owner = 0x3f1424B1a5bF6EE3C9D5A87d0a61721350601ea4;
        uint256 initialSupply = 500;   // whole-token units

        vm.startBroadcast(pk);
        new Mala(owner, initialSupply);
        vm.stopBroadcast();
    }
}
