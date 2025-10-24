// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VaultAccount} from "./VaultAccount.sol";

/**
 * @author  Hassan Abdaljalil
 * @title   Vault
 * @dev     Creates a manager contract for multiple accounts
 * @notice  A handler for different accounts
 */

contract Vault {
    // creates a new VaultAccount contract when called
    // mostly a manager/proxy for different Accounts
    mapping(address => VaultAccount[]) private userToAccounts;

    /**
     * @notice  Checks to see if an account exists
     * @dev     Runs the function _accountExists before proceeding
     * @param   _accountAddress  Address of the account(could be any address)
     */
    modifier accountExists(address payable _accountAddress) {
        _accountExists(_accountAddress);
        _;
    }

    /**
     * @notice  Checks to see if a given address is an account
     * @dev     Checks if the address is compatible with VaultAccount and can implement getOwner()
     * @param   _accountAddress  The adderess of the desired account
     */
    function _accountExists(address payable _accountAddress) private view {
        try VaultAccount(_accountAddress).getOwner() returns (address) {}
        catch {
            revert ACCOUNT__DOES__NOT__EXIST();
        }
    }

    /**
     * @notice  Checks to see if an account exists given its ID
     * @dev     Attempts to locate specic account in a user's list of accounts
     * @param   _id Position of an account in a dynamic array
     */
    modifier accountIDExists(uint256 _id) {
        _accountIDExists(_id);
        _;
    }

    /**
     * @notice  Checks the existence of an account in a user's account
     * @dev     Verifies that msg.sender has position _id in their list of accounts
     * @param   _id  Position of account in the dynamic array
     */
    function _accountIDExists(uint256 _id) private view {
        if (userToAccounts[msg.sender].length >= 1) {
            if (_id > ((userToAccounts[msg.sender].length) - 1)) {
                revert ACCOUNT__DOES__NOT__EXIST();
            }
        } else {
            revert ACCOUNT__DOES__NOT__EXIST();
        }
    }

    error ACCOUNT__DOES__NOT__EXIST();

    /**
     * @notice  Creates an account
     * @dev     Instantiates a new account contract and adds it to the user's list of account
     * @param   _name  Name of the new account to be created
     * @return  account The new account created by the user
     */
    function createAccount(string memory _name) external payable returns (VaultAccount account) {
        VaultAccount newAccount = new VaultAccount(msg.sender, _name);
        // Implement intial fund
        VaultAccount[] storage userAccounts = userToAccounts[msg.sender];
        userAccounts.push(newAccount);
        return newAccount;
    }

    /**
     * @notice  Funds a user's account
     * @dev     Acts as a proxy for transfering funds from the user to an account
     * @param   _accountAddress  Address of the account that the user wants to fund
     */
    function fundAccount(address payable _accountAddress) external payable accountExists(_accountAddress) {
        VaultAccount account = VaultAccount(_accountAddress);
        account.deposit{value: msg.value}();
    }

    /**
     * @notice  Gets all the accounts of user
     * @dev     Returns all values in a user's list of accounts
     * @return  accounts The user's list of accounts
     */
    function getAccounts() external view returns (VaultAccount[] memory accounts) {
        return userToAccounts[msg.sender];
    }

    /**
     * @notice  Gets an account
     * @dev     Searches the user's list of accounts and returns it by its position in the array
     * @param   _id  Position of an account in the user's list of accounts
     * @return  account A user's account
     */
    function getAccountByID(uint256 _id) external view accountIDExists(_id) returns (VaultAccount account) {
        return userToAccounts[msg.sender][_id];
    }
}
