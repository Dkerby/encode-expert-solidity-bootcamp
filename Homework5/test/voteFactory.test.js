const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VoteFactory", function () {
  it("Should deploy the vote factory", async function () {
    const VoteStateMachine = await ethers.getContractFactory(
      "VoteStateMachine"
    );
    const vsm = await VoteStateMachine.deploy();
    await vsm.deployed();

    const VoteFactory = await ethers.getContractFactory("VoteFactory");
    const voteFactory = await VoteFactory.deploy(vsm.address);
    await voteFactory.deployed();

    const NaiveVoteFactory = await ethers.getContractFactory(
      "NaiveVoteFactory"
    );
    const naiveVoteFactory = await NaiveVoteFactory.deploy();
    await naiveVoteFactory.deployed();

    // naive
    await naiveVoteFactory.createVote("Test 1");

    // proxy-based
    await voteFactory.createVote("Test 2");
    expect(true).to.be.equal(true);
  });
});
