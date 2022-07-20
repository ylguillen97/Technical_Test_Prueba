const hre = require ("hardhat");
const ethers = hre.ethers;

async function main() 
{

const Vesting = await hre.ethers.getContractFactory("Vesting");
const vesting = await Vesting.deploy("0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199","0xdD2FD4581271e230360230F9337D5c0430Bf44C0");

await vesting.deployed();

console.log("Vesting deployed to: ", vesting.address);


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});