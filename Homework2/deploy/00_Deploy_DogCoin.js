const { ethers } = require("hardhat")

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments
  const { deployer } = await getNamedAccounts()

  const initialSupply = ethers.BigNumber.from(10).pow(18).mul(100000)

  const token = await deploy("DogCoin", {
    from: deployer,
    args: [initialSupply],
  })
}

module.exports.tags = ["all", "token"]
