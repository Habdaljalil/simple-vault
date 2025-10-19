// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Vault} from "../src/Vault.sol";

contract DeployVault is Script {
    Vault vault;
    address payable immutable I_OWNER;

    constructor(address payable _owner) {
        I_OWNER = _owner;
    }

    function run() public returns (Vault) {
        vm.startPrank(I_OWNER);
        vault = new Vault();
        vm.stopPrank();
        return vault;
    }
}
