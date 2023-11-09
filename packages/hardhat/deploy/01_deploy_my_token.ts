import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployMyToken: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  await deploy("DCSTOKEN", {
    from: deployer,
    args: [deployer],
    log: true,
    autoMine: true,
  });
};

export default deployMyToken;

deployMyToken.tags = ["DCSTOKEN"];
