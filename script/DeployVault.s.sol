// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Vault} from "../src/Vault.sol";

contract DeployVault is Script {
    Vault vault;

    function run() public returns (Vault) {
        vm.startBroadcast();
        vault = new Vault();
        vm.stopBroadcast();
        return vault;
    }
}
