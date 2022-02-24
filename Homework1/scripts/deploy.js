const hre = require("hardhat");

async function main() {
  const DogCoin = await hre.ethers.getContractFactory("DogCoin");
  const dogCoin = await DogCoin.deploy();

  await dogCoin.deployed();

  console.log("DogCoin deployed to:", dogCoin.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
