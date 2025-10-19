// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

error NOT__OWNER();
error NOT__ENOUGH__FUNDS();

event Deposit(address indexed user, uint256 amount);
event Withdraw(address indexed user, uint256 amount);

/// @title
/// @author
/// @notice
contract VaultAccount {
    string private s_name;
    address private I_OWNER;

    constructor(address _owner, string memory _name) {
        I_OWNER = _owner;
        s_name = _name;
    }

    modifier onlyOwner() {
        if (msg.sender != I_OWNER) {
            revert NOT__OWNER();
        } else {
            _;
        }
    }

    modifier enoughFunds(uint256 _amount) {
        if (_amount > payable(this).balance) {
            revert NOT__ENOUGH__FUNDS();
        } else {
            _;
        }
    }

    function deposit(uint256 _amount) public payable {
        emit Deposit(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) external payable onlyOwner enoughFunds(_amount) returns (bool){
        (bool success, ) = payable(I_OWNER).call{value: _amount}("");
        require(success, "CALL FAILED");
        return success;
    }

    receive() external payable {
        deposit(msg.value);
    }

    fallback() external payable {
        deposit(msg.value);
    }

    // IMPLEMENT FALLBACK

    // Create --> constructor
    // Send/withdraw
    // Ownership
    // Receive/fallback function

    function getBalance() external view returns(uint256) {
        return payable(this).balance;
    }

    function getOwner() external view returns (address) {
        return I_OWNER;
    }
}
