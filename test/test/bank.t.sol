// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Bank} from "../src/Bank.sol";
import {Attack} from "../src/Attack.sol";
//import {Console} from "forge-std/Console.sol";
import {FixBank} from "../src/Fixbank.sol";
import {console} from "forge-std/console.sol";

contract BankTest is Test {
    Bank public bank;
    FixBank public fixBank;

    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");
    address public attacker = makeAddr("attacker");

    uint256 constant INITIAL_DEPOSIT = 10 ether;
    uint256 constant ATTACK_AMOUNT = 1 ether;

    function setUp() public {
        bank = new Bank();
        fixBank = new FixBank();

        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(attacker, 100 ether);
    }

    function test_withdraw() public {
        vm.prank(user1);
        bank.deposit{value: INITIAL_DEPOSIT}();

        uint256 user1initialbal = user1.balance;
        uint256 bankInitbal = address(bank).balance;

        vm.prank(user1);
        bank.withdraw(INITIAL_DEPOSIT);

        assertEq(user1.balance, user1initialbal + INITIAL_DEPOSIT);
    }

    /*function test_reentrantAttack() public {
        vm.prank(user1);
        bank.deposit{value: 5 ether}();

        vm.prank(user2);
        bank.deposit{value: 5 ether}();

        uint256 contractbal = address(bank).balance;

        console.log("hello");
        console.log("before", contractbal / 1e18);
        

        vm.startPrank(attacker);
        Attack attackerContract = new Attack(address(bank));

        vm.expectRevert();
        attackerContract.attack{value: ATTACK_AMOUNT}();
        vm.stopPrank();

        uint256 contractbalAfter = address(bank).balance;
        uint256 attackerContractbal = address(attackerContract).balance;

    

        console.log("hello");
        console.log("after attack", contractbalAfter / 1e18);

        assertEq(address(bank).balance, contractbal);
        
        
    }
    */

    function test_Reentrancy() public {
        vm.prank(user1);
        bank.deposit{value: 5 ether}();

        vm.prank(user2);
        bank.deposit{value: 5 ether}();

        uint256 initialbal = address(bank).balance;
        console.log(initialbal / 1e18);

        vm.startPrank(attacker);
        Attack attackContract = new Attack(address(bank));

        attackContract.attack{value: ATTACK_AMOUNT}();
        vm.stopPrank();

        uint256 contractBalanceAfter = address(bank).balance;
        uint256 attackContractBalance = address(attackContract).balance;

        console.log("contract bal after attack:", contractBalanceAfter / 1e18);
        console.log("acttack contract bal:", attackContractBalance / 1e18);

        assertEq(contractBalanceAfter, 0, "EtherStore should be drained");

     }
     


}
