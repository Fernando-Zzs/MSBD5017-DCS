# 🏗 MSBD5017 Project (Based on Scaffold-ETH 2)

## Decentralized Compensation System

This is a salary distribution solution based on blockchain technology. Everyone can openly and transparently decide the salary allocation of team members within a cycle through voting. Team members can be effectively motivated through salary allocation that is more in line with their actual level of contribution.

## Brief Roadmap
### V1.0 minimum viable product

**Owner**
* Initialize the contract
* Initialize the variables in the contract at the beginning of an epoch

**participant**
* View all participants to dicide who to transfer
* Within a period of epoch, transfer your token to other participants
* View the token acquisition status of all participants after the epoch

## Requirements

Before you begin, you need to install the following tools:

- [Node (v18 LTS)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

## Quickstart

To get started with Scaffold-ETH 2, follow the steps below:

1. Clone this repo & install dependencies

```
git clone https://github.com/Fernando-Zzs/MSBD5017-DCS.git
cd MSBD5017-DCS
yarn install
```

2. Run a local network in the first terminal:

```
yarn chain
```

This command starts a local Ethereum network using Hardhat. The network runs on your local machine and can be used for testing and development. You can customize the network configuration in `hardhat.config.ts`. To use your own API key, you should add a file called `.env` in `packages/hardhat`. Here is an example:

```
# Replace your own KEY, these keys are unvalid
ALCHEMY_API_KEY="ZN_xwZowaO1j8ICZgfyY9YXwB2JH6-fN"
DEPLOYER_PRIVATE_KEY="efe18d5e50c6bf38a9d24d48e7ee60723f8b0df0d64f0d5560988bd80ba96890"
ETHERSCAN_API_KEY="XJUZVQN1SRS1ECH6TDTTQZ4MY3NE5I4KX8"
```

3. On a second terminal, deploy the test contract:

```
yarn deploy
```

This command deploys a test smart contract to the local network. The contract is located in `packages/hardhat/contracts` and can be modified to suit your needs. The `yarn deploy` command uses the deploy script located in `packages/hardhat/deploy` to deploy the contract to the network. You can also customize the deploy script.

4. On a third terminal, start your NextJS app:

```
yarn start
```

Visit your app on: `http://localhost:3000`. You can interact with your smart contract using the contract component or the example ui in the frontend. You can tweak the app config in `packages/nextjs/scaffold.config.ts`.

Run smart contract test with `yarn hardhat:test`

- Edit your smart contract `YourContract.sol` in `packages/hardhat/contracts`
- Edit your test file in `packages/hardhat/test`
- Edit your frontend in `packages/nextjs/pages`
- Edit your deployment scripts in `packages/hardhat/deploy`

## Learn about Scaffold-ETH 2
<h4 align="center">
  <a href="https://docs.scaffoldeth.io">Documentation</a> |
  <a href="https://scaffoldeth.io">Website</a>
</h4>

🧪 An open-source, up-to-date toolkit for building decentralized applications (dapps) on the Ethereum blockchain. It's designed to make it easier for developers to create and deploy smart contracts and build user interfaces that interact with those contracts.

⚙️ Built using NextJS, RainbowKit, Hardhat, Wagmi, and Typescript.

- ✅ **Contract Hot Reload**: Your frontend auto-adapts to your smart contract as you edit it.
- 🔥 **Burner Wallet & Local Faucet**: Quickly test your application with a burner wallet and local faucet.
- 🔐 **Integration with Wallet Providers**: Connect to different wallet providers and interact with the Ethereum network.

![Debug Contracts tab](https://github.com/scaffold-eth/scaffold-eth-2/assets/55535804/1171422a-0ce4-4203-bcd4-d2d1941d198b)