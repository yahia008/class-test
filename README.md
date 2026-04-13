Reentrancy Attack Demo & Fix
Educational repository demonstrating the Reentrancy Vulnerability in smart contracts and how to fix it securely.
Overview
This project shows:

A vulnerable bank contract that can be drained via reentrancy
A malicious Attacker contract that exploits it
A secure version of the bank using best practices
Tests proving both the attack and the fix

contracts/
├── Attack.sol
├── Attackfiy.sol
└── Bank.sol
└── Fixbank.sol

test/
├── bank.t.sol     
└── fixbank.t.sol