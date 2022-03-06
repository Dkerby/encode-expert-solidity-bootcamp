const { ethers } = require("hardhat")

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments
  const { deployer } = await getNamedAccounts()

  let vote = await deploy("VoteStateMachine", {
    from: deployer,
  })

  console.log("Vote deployed at ", vote.address)

  let factory = await deploy("VoteFactory", {
    from: deployer,
    args: [vote.address],
  })

  console.log("Factory deployed at ", factory.address)
}

module.exports.tags = ["all", "factory"]
