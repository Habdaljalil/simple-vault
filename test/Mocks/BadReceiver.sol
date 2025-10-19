// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract BadReceiver {
    receive() external payable {
        revert("Bad send");
    }
}
