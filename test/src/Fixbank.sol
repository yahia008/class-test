// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract FixBank {
    mapping(address => uint256) public balances;

    bool internal locked;

    modifier nonreentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() internal {
        require(!locked, "call reenntrant");
        locked = true;
    }

    function _nonReentrantAfter() internal {
        locked = false;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public nonreentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;

        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "Failed to send Ether");
    }
}
