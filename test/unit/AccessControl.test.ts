import { expect } from "../chai-setup";
import { setupUsers, setupUser } from "../utils";
import {
  ethers,
  deployments,
  getNamedAccounts,
  getUnnamedAccounts,
} from "hardhat";

const setup = async () => {
  await deployments.fixture(["all"]);

  const contracts = {
    test: await ethers.getContract("TestContract"),
  };

  const { deployer } = await getNamedAccounts();

  const users = await setupUsers(await getUnnamedAccounts(), contracts);

  return {
    ...contracts,
    users,
    deployer: await setupUser(deployer, contracts),
  };
};

describe("Access Control", () => {
  describe("Deployment", () => {
    it("Should try to change the owner", async () => {
      const { test, deployer } = await setup();

      await expect(
        deployer.test.changeOwner(deployer.address)
      ).to.be.revertedWith("Not Authorized");
    });

    it("Should grantPermission to deployer", async () => {
      const { test, users, deployer } = await setup();

      const sig = ethers.utils.id("changeOwner(address)");

      const tx = await deployer.test.grantAccess(
        sig.substring(0, 10),
        deployer.address
      );
      await tx.wait();

      const change_tx = await deployer.test.changeOwner(users[0].address);
      await change_tx.wait();

      expect(await test.owner()).to.equal(users[0].address);
    });

    it("Should try to change the admin", async () => {
      const { test, users } = await setup();

      await expect(
        users[0].test.changeAdmin(users[0].address)
      ).to.be.revertedWith("Admin != msg.sender");
    });

    it("Should try to grant Permission to user", async () => {
      const { test, users } = await setup();
      const sig = ethers.utils.id("changeOwner(address");

      await expect(
        users[0].test.grantAccess(sig.substring(0, 10), users[0].address)
      ).to.be.revertedWith("Admin != msg.sender");
    });

    it("Should change the admin", async () => {
      const { test, users, deployer } = await setup();

      const tx = await deployer.test.changeAdmin(users[0].address);
      await tx.wait();

      expect(await test.admin()).to.equal(users[0].address);
    });
  });
});
