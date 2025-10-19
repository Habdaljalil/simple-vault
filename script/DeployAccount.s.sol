// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "../lib/forge-std/src/Script.sol";
import {VaultAccount} from "../src/VaultAccount.sol";
// Fix default sender
contract DeployAccount is Script {
    VaultAccount account;
    function run() public returns (address) {
        vm.startBroadcast();
        account = new VaultAccount(DEFAULT_SENDER, "Account 1");
        vm.stopBroadcast();

        return address(account);
    }
}