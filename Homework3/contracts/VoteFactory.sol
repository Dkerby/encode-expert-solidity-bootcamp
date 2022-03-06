// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./VoteStateMachine.sol";

contract VoteFactory is Ownable {
  address public template;

  using Clones for address;

  constructor(address _template) {
        template = _template;
  }

  function createVote(string calldata _name) public returns(address) {
    address clone = template.clone();
    VoteStateMachine(clone).initialize(_name);
    return clone;
  }
  
}