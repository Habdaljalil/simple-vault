// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @author  Hassan Abdaljalil
 * @title   Accounts
 * @dev     Creates a basic account for depositing and withdrawing funds
 * @notice  A basic smart contract for managing funds
 */

contract VaultAccount {
    string private s_name;
    address private I_OWNER;

    constructor(address _owner, string memory _name) {
        I_OWNER = _owner;
        s_name = _name;
    }

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    error NOT__OWNER();
    error NOT__ENOUGH__FUNDS();

    /**
     * @notice  Only allows the owner of the contract to access a function
     * @dev     Checks to see if msg.sender == the owner; if not, it reverts
     */
    modifier onlyOwner() {
        if (msg.sender != I_OWNER) {
            revert NOT__OWNER();
        } else {
            _;
        }
    }

    /**
     * @notice  Checks to see if enough funds exist before proceeding with a function
     * @dev     Compares the input to the contract's balance; it reverts if the desired action costs more than the balance of the account
     * @param   _amount  Amount of ether
     */
    modifier enoughFunds(uint256 _amount) {
        if (_amount > payable(this).balance) {
            revert NOT__ENOUGH__FUNDS();
        } else {
            _;
        }
    }

    /**
     * @notice  Adds funds to the account
     * @dev     Payable function that emits the deposit amount publicly
     */
    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @notice  Allows the owner to withdraw funds from the account
     * @dev     Assuming that the desired withdraw amount is less than the contract's balance, it sends the given funds to the owner and checks to see if any errors occur
     * @param   _amount  Amount of ether
     * @return  success Whether the send function to the owner failed or not
     */
    function withdraw(uint256 _amount) external payable onlyOwner enoughFunds(_amount) returns (bool success) {
        (bool success,) = payable(I_OWNER).call{value: _amount}("");
        require(success, "CALL FAILED");
        emit Withdraw(msg.sender, _amount);
        return success;
    }

    receive() external payable {
        deposit();
    }

    fallback() external payable {
        deposit();
    }

    /**
     * @notice  Gets the number of funds in the account
     * @dev     Returns the contract's balance
     * @return  balance Balance of the account
     */
    function getBalance() external view returns (uint256 balance) {
        return payable(this).balance;
    }

    /**
     * @notice  Returns the owner's identity
     * @dev     Displays the address(public key) of the owner of the contract
     * @return  owner The address of the owner
     */
    function getOwner() external view returns (address owner) {
        return I_OWNER;
    }

    /**
     * @notice  Gets the name of the account
     * @dev     Returns the value of the storage variable s_name
     * @return  name Name of the account
     */
    function getName() external view returns (string memory name) {
        return s_name;
    }
}
