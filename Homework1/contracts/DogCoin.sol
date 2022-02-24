// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DogCoin is ERC20 {
    address[] holders;

    constructor(uint256 initialSupply) ERC20("DogCoin", "DOG") {
        holders.push(msg.sender);
        _mint(msg.sender, initialSupply);
    }

    function mint(address account, uint256 amount) public {
        holders.push(account);
        _mint(account, amount);
    }

    function transfer(address account, uint256 amount) public override returns (bool) {
        holders.push(account);
        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == msg.sender && amount == balanceOf(msg.sender)) {
                holders[i] = holders[holders.length - 1];
                holders.pop();
            }
        }

        _transfer(msg.sender, account, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        holders.push(to);
        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == from && amount == balanceOf(from)) {
                holders[i] = holders[holders.length - 1];
                holders.pop();
            }
        }

        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function burn(address account, uint256 amount) public {
        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == account && amount == balanceOf(account)) {
                holders[i] = holders[holders.length - 1];
                holders.pop();
            }
        }
        _burn(account, amount);
    }
}
