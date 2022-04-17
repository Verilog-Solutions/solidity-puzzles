# Solidity Puzzles

```
    _    _           _ _             
   | |  | |         (_) |            
   | |  | |___  ____ _| | ___   ____ 
    \ \/ / _  )/ ___) | |/ _ \ / _  |
     \  ( (/ /| |   | | | |_| ( ( | |
    _ \/ \____)_|   |_|_|\___/ \_|| |
   | |        | |      _      (_____|
    \ \   ___ | |_   _| |_ (_) ___  ____   ___ 
     \ \ / _ \| | | | |  _)| |/ _ \|  _ \ /___)
 _____) ) |_| | | |_| | |__| | |_| | | | |___ |
(______/ \___/|_|\____|\___)_|\___/|_| |_(___/ 
                                               
Verilog Solutions Inc. https://www.verilog.solutions
Verilog is a full-stack web3 security firm, covering smart contract auditing, 
validator operations, venture investment, and incubation.
Glad to prepare and present the materials for Game Day Remix in DevConnect Amsterdam!
```

This repo inlcudes three puzzles on smart contract written in Solidity.

## Who Are They?
### Puzzle One: Yesterday Once More
Time traveled back to 2016, you are the one who hard-fork the Ethereum blockchain.

### Puzzle Two: Safe and Sound
No worry, our transfer is secured.

### Puzzle Three: Nothing Is True; Everything Is Permitted
Break through the white list can claim your victory.

## Quick start

```shell
git clone https://github.com/Verilog-Solutions/solidity-puzzles.git
npm install
npx hardhat test
```

## File structure

Each puzzle has an `*Attacker.sol` in the `contract/puzzle[1-3]/` folder. The `*Attacker.sol` are the walk-through to this puzzle: calling their `attack(...)` function with correct parameters nail the puzzle.

Similarly, Each puzzle has an `test/puzzle[1-3].test.js` hardhat test file. The test file includes $3$ unit tests for legit usages and $1$ test for attack purpose. The legit tests can run w/o the `*Attacker.sol` file but the attack tests cannot.

## With Remix

### Run Test Cases in Remix IDE

> Beware: Running tests in Remix IDE eats your RAM (~1.5 GB). Consider running it with a local node.

1. Open [remix](https://remix.ethereum.org/);
2. Enable `dGit` plugin in the `PLUGIN MANAGER` tab;
3. In `dGit` > `CLONE, PUSH, PULL & REMOTES` > `CLONE`, enter URL to this github repo, then click `clone`; 
4. Go to `FILE EXPLORERS` > drag down `workspace` > select the latest workspace,
    1. for each `*.sol` file in `contracts/` folder:
        1. Go to `SOLIDITY COMPILER`, compile `*.sol`.
5. Go to `FILE EXPLORERS` > `test/` folder,
    1. for each `*.test.js` file in `test/` folder
        1. Right click `*.test.js` and choose `run`.

### Run Test Cases in Remix IDE, But in Local Node
1. Follow the same steps as [Run Hardhat Test Cases in Remix IDE](### Run Hardhat Test Cases in Remix IDE) does;
2. Before running the `*.test.js` files, go to `DEPLOY & RUN TRANSACTIONS`, select `Hardhat Provider`, you'll see a pop-up windows;
3. Clone this github repo to your local machine, and run `npm install` to setup local Hardhat environment;
4. In the repo folder, run `npx hardhat node` to start a local Hardhat network node. Wait a few seconds and you'll see `eth_getBalance (20)` pops up.
5. Back to Remix, click `OK` in the a pop-up windows. Now, your environment tab becomes `Hardhat Provider`.
6. Run the `*.test.js` files.

### Play with Recordings

TBD