// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {DeployVault} from "../../script/DeployVault.s.sol";
import {Vault} from "../../src/Vault.sol";
import {VaultAccount} from "../../src/VaultAccount.sol";

contract TestVaultIntegration is Test {
    Vault vault;
    address OWNER = makeAddr("Hassan");
    uint256 constant STARTING_OWNER_BALANCE = 10 ether;
    uint256 constant DEPOSIT_AMOUNT = 1 ether;

    function setUp() public {
        DeployVault deployVault = new DeployVault(payable(OWNER));
        vault = deployVault.run();
        vm.deal(OWNER, STARTING_OWNER_BALANCE);
    }

    function testOwnerInteractionsWithVault(string memory _name, uint256 _amount, uint256 _numberOfContracts) public {

        _amount = bound(_amount, 0 ether, 10 ether);
        _numberOfContracts = bound(_numberOfContracts, 1, 20);
        vm.startPrank(OWNER);
        for (uint256 i = 0; i < _numberOfContracts; i++) {
            vault.createAccount(_name);
        }

        VaultAccount[] memory ownerAccounts = vault.getAccounts();
        uint256 ownerNumberOfAccounts = ownerAccounts.length;

        for (uint256 i = 0; i < _numberOfContracts; i++) {
            vault.createAccount(_name);
        }

        for (uint256 i = 0; i < ownerNumberOfAccounts; i++) {
            VaultAccount account = ownerAccounts[i];
            for (uint256 j = 0; j < _numberOfContracts; j++) {
                vault.fundAccount{value: _amount}(payable(address(account)));
                account.withdraw(_amount);
            }
        }

        vm.stopPrank();

        assertEq(payable(OWNER).balance, DEPOSIT_AMOUNT*10);
    }
}
