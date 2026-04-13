// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {FixBank} from "../src/Fixbank.sol";
import {Attack} from "../src/Attackfiy.sol";
import {console} from "forge-std/console.sol";

contract FixBankTest is Test {
    FixBank public fixBank;

    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");
    address public attacker = makeAddr("attacker");
    uint256 constant ATTACK_AMOUNT = 1 ether;

    function setUp() public {
        fixBank = new FixBank();

        vm.deal(user1, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(attacker, 100 ether);
    }

   function test_Revert_fixBank() public {
        vm.prank(user1);
        fixBank.deposit{value: 5 ether}();

        vm.prank(user2);
        fixBank.deposit{value: 5 ether}();

         uint256 contractBalanceBefore = address(fixBank).balance;
        console.log("before", contractBalanceBefore / 1e18);

        vm.startPrank(attacker);
        Attack attackContract = new Attack(address(fixBank));

        vm.expectRevert();

        attackContract.attack{value: ATTACK_AMOUNT}();
        vm.stopPrank();

        uint256 contractBalanceAfter = address(fixBank).balance;

        assertEq(contractBalanceAfter, contractBalanceBefore, "Balance should not change");
    }

}