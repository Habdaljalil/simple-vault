# Vault
[Git Source](https://github.com/Habdaljalil/simple-vault/blob/679c4aff369dc8f894cce326ba0c1d0e1dceed05/src/Vault.sol)

**Author:**
Hassan Abdaljalil

A handler for different accounts

Creates a manager contract for multiple accounts


## State Variables
### userToAccounts

```solidity
mapping(address => VaultAccount[]) private userToAccounts
```


## Functions
### accountExists

Checks to see if an account exists

Runs the function _accountExists before proceeding


```solidity
modifier accountExists(address payable _accountAddress) ;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_accountAddress`|`address payable`| Address of the account(could be any address)|


### _accountExists

Checks to see if a given address is an account

Checks if the address is compatible with VaultAccount and can implement getOwner()


```solidity
function _accountExists(address payable _accountAddress) private view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_accountAddress`|`address payable`| The adderess of the desired account|


### accountIDExists

Checks to see if an account exists given its ID

Attempts to locate specic account in a user's list of accounts


```solidity
modifier accountIDExists(uint256 _id) ;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_id`|`uint256`|Position of an account in a dynamic array|


### _accountIDExists

Checks the existence of an account in a user's account

Verifies that msg.sender has position _id in their list of accounts


```solidity
function _accountIDExists(uint256 _id) private view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_id`|`uint256`| Position of account in the dynamic array|


### createAccount

Creates an account

Instantiates a new account contract and adds it to the user's list of account


```solidity
function createAccount(string memory _name) external payable returns (VaultAccount account);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_name`|`string`| Name of the new account to be created|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`account`|`VaultAccount`|The new account created by the user|


### fundAccount

Funds a user's account

Acts as a proxy for transfering funds from the user to an account


```solidity
function fundAccount(address payable _accountAddress) external payable accountExists(_accountAddress);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_accountAddress`|`address payable`| Address of the account that the user wants to fund|


### getAccounts

Gets all the accounts of user

Returns all values in a user's list of accounts


```solidity
function getAccounts() external view returns (VaultAccount[] memory accounts);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`accounts`|`VaultAccount[]`|The user's list of accounts|


### getAccountByID

Gets an account

Searches the user's list of accounts and returns it by its position in the array


```solidity
function getAccountByID(uint256 _id) external view accountIDExists(_id) returns (VaultAccount account);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_id`|`uint256`| Position of an account in the user's list of accounts|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`account`|`VaultAccount`|A user's account|


## Errors
### ACCOUNT__DOES__NOT__EXIST

```solidity
error ACCOUNT__DOES__NOT__EXIST();
```

