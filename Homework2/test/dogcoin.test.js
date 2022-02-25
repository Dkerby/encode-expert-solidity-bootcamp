const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("DogCoin", function () {
  let dogCoin
  let owner, addr1, addr2, addr3

  before(async function () {
    signers = await ethers.getSigners()

    owner = signers[0]
    addr1 = signers[1]
    addr2 = signers[2]
    addr3 = signers[3]

    const DogCoin = await ethers.getContractFactory("DogCoin")
    dogCoin = await DogCoin.deploy(1000)
    await dogCoin.deployed()
  })

  it("The owner should have gotten the inital mint", async function () {
    expect(await dogCoin.balanceOf(owner.address)).to.equal(1000)
  })

  it("Owner should be able to transfer balance to addr1", async function () {
    await dogCoin.transfer(addr1.address, 50)
    expect(await dogCoin.balanceOf(addr1.address)).to.equal(50)
  })

  it("Addr1 should be found in the second position in the holders array", async function () {
    expect(await dogCoin.holders(1)).to.equal(addr1.address)
    const holders = await dogCoin.getHolders()
    expect(holders.length).to.be.equal(2)
  })

  it("Addr1 should be removed from the second position in the owners array", async function () {
    await dogCoin.connect(addr1).transfer(owner.address, 50)
    const holders = await dogCoin.getHolders()
    expect(holders.length).to.be.equal(1)
  })

  it("Addr2 and addr3 should be added to the holders array", async function () {
    await dogCoin.transfer(addr2.address, 100)
    await dogCoin.transfer(addr3.address, 100)
    const holders = await dogCoin.getHolders()
    expect(holders.length).to.be.equal(3)
  })
})
