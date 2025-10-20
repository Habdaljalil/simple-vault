// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {DeployVault} from "../../script/DeployVault.s.sol";
import {Vault} from "../../src/Vault.sol";
import {VaultAccount} from "../../src/VaultAccount.sol";
import {console2} from "../../lib/forge-std/src/console2.sol";
import {BadReceiver} from "../Mocks/BadReceiver.sol";

contract TestVault is Test {
    Vault vault;
    address OWNER = makeAddr("Hassan");
    uint256 constant STARTING_OWNER_BALANCE = 10 ether;
    uint256 constant DEPOSIT_AMOUNT = 1 ether;
    string constant ACCOUNT_NAME = "ACCOUNT 1";

    function setUp() public {
        DeployVault deployVault = new DeployVault(payable(OWNER));
        vault = deployVault.run();

        vm.deal(OWNER, STARTING_OWNER_BALANCE);
    }

    modifier ownerHasOneAccount() {
        vm.startPrank(OWNER);
        vault.createAccount(ACCOUNT_NAME);
        vm.stopPrank();
        _;
    }

    function testCreateAccount() public ownerHasOneAccount {
        vm.startPrank(OWNER);
        uint256 ownerNumberOfAccounts = vault.getAccounts().length;
        vm.stopPrank();
        assertEq(ownerNumberOfAccounts, 1);
    }

    function testFundAccount() public ownerHasOneAccount {
        vm.startPrank(OWNER);
        VaultAccount ownerAccountOne = vault.getAccountByID(0);
        vault.fundAccount{value: DEPOSIT_AMOUNT}(payable(address(ownerAccountOne)));
        vm.stopPrank();

        uint256 newAccountBalance = ownerAccountOne.getBalance();

        assertEq(newAccountBalance, DEPOSIT_AMOUNT);
    }

    function testFundAccountWithNonExistantAddress() public {
        BadReceiver nonExistantContract = new BadReceiver();

        vm.expectRevert(Vault.ACCOUNT__DOES__NOT__EXIST.selector);
        vm.startPrank(OWNER);
        vault.fundAccount{value: DEPOSIT_AMOUNT}(payable(address(nonExistantContract)));
        vm.stopPrank();
    }

    function testGetAccountByIDWithNonExistantIDAndAccount() public ownerHasOneAccount {
        vm.expectRevert(Vault.ACCOUNT__DOES__NOT__EXIST.selector);
        vm.startPrank(OWNER);
        VaultAccount account = vault.getAccountByID(1);
        console2.log(address(account));
        vm.stopPrank();
    }

    function testGetAccountByIDWithNonExistantIDNoAccount() public {
        vm.expectRevert(Vault.ACCOUNT__DOES__NOT__EXIST.selector);
        vm.startPrank(OWNER);
        VaultAccount account = vault.getAccountByID(0);
        console2.log(address(account));
        vm.stopPrank();
    }
}
