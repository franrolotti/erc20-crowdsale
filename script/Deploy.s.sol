// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Mala.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
        new Mala(0x3f1424B1a5bF6EE3C9D5A87d0a61721350601ea4);
        vm.stopBroadcast();
    }
}
