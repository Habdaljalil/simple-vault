// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VaultAccount} from "./VaultAccount.sol";

error ACCOUNT__DOES__NOT__EXIST();


contract Vault {
    // creates a new VaultAccount contract when called
    // mostly a manager/proxy for different Accounts
    mapping (address => VaultAccount[]) private userToAccounts;

    modifier accountExists(address payable _accountAddress) {
        _accountExists(_accountAddress);
        _;
    }

    function _accountExists(address payable _accountAddress) private view {
        if (VaultAccount(_accountAddress).getOwner() == address(0)) {
            revert ACCOUNT__DOES__NOT__EXIST();
        }
    }

    function createAccount(string memory _name) external payable returns(address) {
        VaultAccount newAccount = new VaultAccount(msg.sender, _name);
        newAccount.deposit(msg.value);
        VaultAccount[] storage userAccounts = userToAccounts[msg.sender];
        userAccounts.push(newAccount);
        return address(newAccount);
    }

    function fundAccount(address payable _accountAddress) external payable accountExists(_accountAddress) {
        VaultAccount account = VaultAccount(_accountAddress);
        account.deposit(msg.value);
    }

    // Implement delete + clear functions
    // Implement ext view functions
}