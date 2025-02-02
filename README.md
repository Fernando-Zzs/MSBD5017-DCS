# 🏗 MSBD5017 Project (Based on Scaffold-ETH 2)

## Decentralized Compensation System

This is a salary distribution solution based on blockchain technology. Everyone can openly and transparently decide the salary allocation of team members within a cycle through voting. Team members can be effectively motivated through salary allocation that is more in line with their actual level of contribution.

## Requirements

Before you begin, you need to install the following tools:

- [Node (v18 LTS)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

## Quickstart

To get started with DCS, follow the steps below:

1. Clone this repo & install dependencies

```
git clone https://github.com/Fernando-Zzs/MSBD5017-DCS.git
cd MSBD5017-DCS
yarn install
```

2. Add a '.env' file in `packages/hardhat`:

```
ALCHEMY_API_KEY="ZN_xwZowaO1j8ICZgfyY9YXwB2JH6-fN"
DEPLOYER_PRIVATE_KEY="efe18d5e50c6bf38a9d24d48e7ee60723f8b0df0d64f0d5560988bd80ba96890"
ETHERSCAN_API_KEY="XJUZVQN1SRS1ECH6TDTTQZ4MY3NE5I4KX8"
```
Note: Replace your own KEY, these keys are unvalid.

3. Get some SepoliaETH and deploy the contracts:

Get SepoliaETH on https://sepoliafaucet.com/
```
yarn deploy
```

The contract is located in `packages/hardhat/contracts` and can be modified to suit your needs. The `yarn deploy` command uses the deploy script located in `packages/hardhat/deploy` to deploy the contract to the network. You can also customize the deploy script.

4. On another terminal, start your NextJS app:

```
yarn start
```

Visit your app on: `http://localhost:3000`. You can interact with your smart contract using the contract component or the example ui in the frontend. You can tweak the app config in `packages/nextjs/scaffold.config.ts`.

5. Here is the process of initializing the entire contract as a contract deployer

```
1. Click `Debug Contracts` on the nav bar
In `YourContract` tab
2. Click `mockUser` to add users in batch
3. Click `addUsers` to add yourself (Set level to be [0, 3])
4. Set the period to one month (2592000) or something else and click `initEpoch`
5. Click `mockTransfer` to simulate a voting environment
6. Set tokenAddress and click `setTokenAddr` to bind your token to the contract
In `DCSTOKEN` tab
7. Set contracvt address and `mint` some DCSToken to the main contract
```

6. (Optional) Add new features and test them

```
yarn hardhat:test
```

- Edit your smart contract `YourContract.sol` in `packages/hardhat/contracts`
- Edit your test file in `packages/hardhat/test`
- Edit your frontend in `packages/nextjs/pages`
- Edit your deployment scripts in `packages/hardhat/deploy`


## Demo on Vercel
You can also visit the demo through:
https://msbd-5017-dcs-nextjs-6ty7ra1xx-fernando-zzs-projects.vercel.app/

But you can only call the interfaces of the Home page and the Vote page if you are a participant.

There are currently six participants in the system, and you can import the private key of the following participant in the wallet software.

```
private key of 0x90F79bf6EB2c4f870365E785982E1f101E93b906
7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6
```

Most of the interfaces in debug contracts can only be called by the contract deployer.

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