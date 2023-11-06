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
  });

  describe("test", function () {
    it("test", async function () {
      expect(yourContract.startTime < yourContract.endTime);
    });
  });
});
