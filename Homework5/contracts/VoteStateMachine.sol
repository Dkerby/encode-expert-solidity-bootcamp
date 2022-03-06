// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

// State Machine: https://fravoll.github.io/solidity-patterns/state_machine.html
contract VoteStateMachine is Initializable {
    
    enum Stages {
        Proposed,
        Voting,
        Accepted,
        Rejected
    }

    Stages public stage = Stages.Proposed;

    uint public creationTime;

    uint public votesFor;
    uint public voteAgainst;

    mapping(address => bool) public addressHasVoted;

    string public name;

    modifier atStage(Stages _stage) {
        require(stage == _stage);
        _;
    }
    
    modifier transitionAfter() {
        _;
        _calculateStage();
    }
    
    modifier timedTransitions() {
        if (stage == Stages.Proposed && block.timestamp >= creationTime) {
            _nextStage();
        }
        else if (stage == Stages.Voting && block.timestamp >= creationTime + 1 minutes) {
            _nextStage();
        }
        _;
    }

    function initialize(string calldata _name) public initializer {
        name = _name;
        creationTime = block.timestamp;
    }

    function startVote() public atStage(Stages.Proposed) timedTransitions  {

    }

    function castVote(bool _vote) public atStage(Stages.Voting) timedTransitions  {
        require(!addressHasVoted[msg.sender], "address already voted");

        addressHasVoted[msg.sender] = true;
        if(_vote) {
            votesFor++;
        } else {
            voteAgainst++;
        }
    }

    function endVote() public atStage(Stages.Voting) timedTransitions  transitionAfter {
        // Implement reveal of bids here

    }
    
    function _nextStage() internal {
        stage = Stages(uint8(stage) + 1);
    }

    function _calculateStage() internal {
        if(votesFor > voteAgainst) {
            stage = Stages(2);
        } else {
            stage = Stages(3);
        }
    }
}