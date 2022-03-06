// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "./VoteStateMachine.sol";

contract NaiveVoteFactory {
  function createVote(string calldata _name) public returns(address) {
    VoteStateMachine vote = new VoteStateMachine();
    VoteStateMachine(vote).initialize(_name);
    return address(vote);
  }
}