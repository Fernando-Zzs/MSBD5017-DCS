import { expect } from "chai";
import { ethers } from "hardhat";
import { YourContract } from "../typechain-types";

describe("YourContract", function () {
  let yourContract: YourContract;
  let addresses: any[];

  before(async () => {
    addresses = await ethers.getSigners();
    const yourContractFactory = await ethers.getContractFactory("YourContract");
    yourContract = (await yourContractFactory.deploy(addresses[0].address)) as YourContract;
    await yourContract.deployed();

    yourContract.addUsers(`0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`, 3); //400
    yourContract.addUsers(`0x70997970C51812dc3A010C7d01b50e0d17dc79C8`, 1); //200
    yourContract.addUsers(`0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC`, 2); //300
    yourContract.addUsers(`0x90F79bf6EB2c4f870365E785982E1f101E93b906`, 3); //400
    yourContract.addUsers(`0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65`, 0); //100
    yourContract.initBalancesAndCredits();

    yourContract.transferTokens(`0x70997970C51812dc3A010C7d01b50e0d17dc79C8`, 120);
    yourContract.transferTokens(`0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC`, 60);
    yourContract.transferTokens(`0x90F79bf6EB2c4f870365E785982E1f101E93b906`, 70);
    yourContract.transferTokens(`0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65`, 150);

    yourContract.connect(addresses[1]).transferTokens(`0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`, 120);
  });

  describe("testSorting", function () {
    it("test", async function () {
      const sortedUsers = await yourContract.sortUsersByCredits();

      for (let i = 1; i < sortedUsers.length; i++) {
        expect(sortedUsers[i].credits).to.be.at.most(sortedUsers[i - 1].credits);
      }
    });
  });
});
