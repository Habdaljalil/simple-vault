// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {DeployVaultAccount} from "../../script/DeployVaultAccount.s.sol";
import {VaultAccount} from "../../src/VaultAccount.sol";
import {console} from "../../lib/forge-std/src/console.sol";
import {BadReceiver} from "../Mocks/BadReceiver.sol";

contract TestVaultAccount is Test {
    VaultAccount vaultAccount;
    address OWNER = makeAddr("Hassan");
    address NON_OWNER = makeAddr("Not Hassan");
    string constant ACCOUNT_NAME = "Account 1";
    uint256 constant DEPOSIT_AMOUNT = 1 ether;
    uint256 constant INITIAL_BALANCE = 10 ether;

    function setUp() public {
        DeployVaultAccount deployVaultAccount = new DeployVaultAccount();
        vaultAccount = deployVaultAccount.run(payable(OWNER), ACCOUNT_NAME);
        vm.deal(OWNER, INITIAL_BALANCE);
    }

    function testOwnerAndNameValidity() public view {
        assertEq(vaultAccount.getOwner(), OWNER);
        assertEq(vaultAccount.getName(), ACCOUNT_NAME);
    }

    modifier ownerDeposited() {
        vm.startPrank(OWNER);
        vm.expectEmit(true, false, false, true);
        emit VaultAccount.Deposit(OWNER, DEPOSIT_AMOUNT);
        vaultAccount.deposit{value: DEPOSIT_AMOUNT}();
        vm.stopPrank();
        _;
    }

    function testDeposit() public payable ownerDeposited {
        assertEq(vaultAccount.getBalance(), DEPOSIT_AMOUNT);
    }

    function testWithdraw() public payable ownerDeposited {
        vm.startPrank(OWNER);
        vm.expectEmit(true, false, false, true);
        emit VaultAccount.Withdraw(OWNER, DEPOSIT_AMOUNT);
        vaultAccount.withdraw(DEPOSIT_AMOUNT);
        vm.stopPrank();
        assertEq(vaultAccount.getBalance(), 0);
        assertEq((payable(OWNER).balance - (INITIAL_BALANCE - DEPOSIT_AMOUNT)), DEPOSIT_AMOUNT);
    }

    function testWithdrawWithNotEnoughFunds() public payable ownerDeposited {
        vm.expectRevert(VaultAccount.NOT__ENOUGH__FUNDS.selector);
        vm.startPrank(OWNER);
        vaultAccount.withdraw(INITIAL_BALANCE);
        vm.stopPrank();
    }

    function testWithdrawWithNonOwner() public payable ownerDeposited {
        vm.expectRevert(VaultAccount.NOT__OWNER.selector);
        vm.startPrank(NON_OWNER);
        vaultAccount.withdraw(DEPOSIT_AMOUNT);
        vm.stopPrank();
    }

    function testWithdrawFailsWhenOwnerCannotReceive() public payable {
        BadReceiver badReceiver = new BadReceiver();
        VaultAccount badAccount = new VaultAccount((address(badReceiver)), "bad");

        vm.deal(address(badReceiver), INITIAL_BALANCE);

        vm.startPrank(address(badReceiver));
        badAccount.deposit{value: DEPOSIT_AMOUNT}();
        vm.expectRevert(bytes("CALL FAILED"));
        badAccount.withdraw(DEPOSIT_AMOUNT);
        vm.stopPrank();
    }

    function testReceive() public payable {
        vm.startPrank(OWNER);
        (bool success,) = payable(address(vaultAccount)).call{value: DEPOSIT_AMOUNT}("");
        assertEq(success, true);
        assertEq(vaultAccount.getBalance(), DEPOSIT_AMOUNT);
    }

    function testFallback() public payable {
        vm.startPrank(OWNER);
        (bool success,) = payable(address(vaultAccount)).call{value: DEPOSIT_AMOUNT}("Hello");
        assertEq(success, true);
        assertEq(vaultAccount.getBalance(), DEPOSIT_AMOUNT);
    }
}
