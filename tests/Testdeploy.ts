
const { expect } = require("chai");
import { ethers } from "hardhat";
import { ThoronyToken, IndoorCompostNFT, StakingERC1155 } from "../typechain-types";

describe("Test Deployed", function () {

    let thoronyToken: ThoronyToken;
    let indoorCompostNFT: IndoorCompostNFT;
    let stakingERC1155: StakingERC1155;
    let thoronyContractAddress: String;
    let indoorComposeNFTContractAddress: string;

    it("Should deploy and print account", async function () {
        let ThoronyToken = await ethers.getContractFactory("ThoronyToken");
        thoronyToken = await ThoronyToken.deploy();
        await thoronyToken.deployed();

        thoronyContractAddress = thoronyToken.address;
        console.log(thoronyContractAddress);

        let IndoorCompostNFT = await ethers.getContractFactory("IndoorCompostNFT");
        indoorCompostNFT = await IndoorCompostNFT.deploy();
        await indoorCompostNFT.deployed();

        indoorComposeNFTContractAddress = indoorCompostNFT.address;
        console.log(indoorComposeNFTContractAddress);

        let StakingERC1155 = await ethers.getContractFactory("StakingERC1155");
        stakingERC1155 = await StakingERC1155.deploy(indoorComposeNFTContractAddress, thoronyContractAddress);
        await stakingERC1155.deployed();

        console.log(stakingERC1155.address);
    });
})

  // Deploy ERC20 
  // Deploy NFT
  // Deploy Stake prividing ERC20 and NFT Address
  // const ThoronyToken

  /*
  const IndoorComposeNFT = await ethers.getContractFactory("IndoorComposeNFT");
  const indoorComposeNFT = await IndoorComposeNFT.deploy();

  await indoorComposeNFT.deployed();

  console.log(`deployed to ${indoorComposeNFT.address}`);
  */