// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DogCoin is ERC20 {
    address[] public holders;
    event HolderAdded(address holder);
    event HolderRemoved(address holder);

    constructor(uint256 initialSupply) ERC20("DogCoin", "DOG") {
        holders.push(msg.sender);
        emit HolderAdded(msg.sender);
        _mint(msg.sender, initialSupply);
    }

    function getHolders() public view returns (address[] memory) {             
        address[] memory addresses = new address[](holders.length);
        for(uint256 i = 0; i < holders.length; i++) {
            addresses[i] = holders[i];
        }
        return addresses;
    }


    function _isHolder(address account) internal view returns (bool) {             
        for(uint256 i = 0; i < holders.length; i++) {
            if(holders[i] == account) return true;
        }
        return false;
    }

    function mint(address account, uint256 amount) public {
        holders.push(account);
        emit HolderAdded(account);
        _mint(account, amount);
    }

    function transfer(address account, uint256 amount) public override returns (bool) {
        if(!_isHolder(account)) {
            holders.push(account);
            emit HolderAdded(account);
        }

        _transfer(msg.sender, account, amount);

        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == msg.sender && balanceOf(msg.sender) == 0) {
                holders[i] = holders[holders.length - 1];
                emit HolderRemoved(msg.sender);
                holders.pop();
            }
        }

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {

        if(!_isHolder(to)) {
            holders.push(to);
            emit HolderAdded(to);
        }

        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);

        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == from && balanceOf(from) == 0) {
                holders[i] = holders[holders.length - 1];
                emit HolderRemoved(from);
                holders.pop();
            }
        }

        return true;
    }
}
