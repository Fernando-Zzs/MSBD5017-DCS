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
    // If you wanna change timestamps, refer to: https://www.beijing-time.org/shijianchuo/
    await yourContract.initEpochInfo(
      1696835264,
      1796835264,
      addresses.map(addr => addr.address),
    );
  });

  describe("Check Initial State", function () {
    it("should have balances of 100 for all addresses", async function () {
      for (const value of Object.values(await yourContract.balances)) {
        expect(value).to.equal(100);
      }
    });

    it("should have credits of 0 for all addresses", async function () {
      for (const value of Object.values(await yourContract.credits)) {
        expect(value).to.equal(0);
      }
    });
  });

  describe("Function Of Players", function () {
    it("transfer 50 from owner to addr1", async function () {
      const owner = yourContract.participants(0);
      const addr1 = yourContract.participants(1);

      await yourContract.transferTokens(addr1, 50);
      expect(await yourContract.balances(owner)).to.equal(50);
      expect(await yourContract.credits(addr1)).to.equal(50);
    });

    it("transfer 30 from addr1 to addr2", async function () {
      const addr1 = yourContract.participants(1);
      const addr2 = yourContract.participants(2);

      await yourContract.connect(addresses[1]).transferTokens(addr2, 30);
      expect(await yourContract.balances(addr1)).to.equal(70);
      expect(await yourContract.credits(addr2)).to.equal(30);
    });
  });
});
