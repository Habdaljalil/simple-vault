// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "../lib/forge-std/src/Script.sol";
import {VaultAccount} from "../src/VaultAccount.sol";

// Fix default sender
contract DeployVaultAccount is Script {
    VaultAccount private vaultAccount;

    function run(address payable _owner, string memory _accountName) public returns (VaultAccount) {
        vm.startBroadcast();
        vaultAccount = new VaultAccount(_owner, _accountName);
        vm.stopBroadcast();

        return vaultAccount;
    }
}
