// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "../lib/forge-std/src/Script.sol";
import {VaultAccount} from "../src/VaultAccount.sol";

// Fix default sender
contract DeployVaultAccount is Script {
    VaultAccount private vaultAccount;
    address payable immutable I_OWNER;
    string private ACCOUNT_NAME;

    constructor(address payable _owner, string memory _accountName) {
        I_OWNER = _owner;
        ACCOUNT_NAME = _accountName;
    }

    function run() public returns (VaultAccount) {
        vm.startBroadcast();
        vaultAccount = new VaultAccount(I_OWNER, ACCOUNT_NAME);
        vm.stopBroadcast();

        return vaultAccount;
    }
}
