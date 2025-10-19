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

    modifier accountIDExists(uint256 _id) {
        _accountIDExists(_id);
        _;
    }

    function _accountIDExists(uint256 _id) private view {
        if (_id > (userToAccounts[msg.sender].length - 1)) {
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

    function getAccounts() external view returns (VaultAccount[] memory) {
        return userToAccounts[msg.sender];
    }

    function getAccountByID(uint256 _id) external view accountIDExists(_id)returns (VaultAccount) {
        return userToAccounts[msg.sender][_id];
    }
}