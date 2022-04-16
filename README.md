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

Each puzzle has an `*Attacker.sol` in the `contract/puzzle[1-3]/` folder. The `*Attacker.sol` are the walkthrough to this puzzle: calling their `attack(...)` function with correct parameters nail the puzzle.

Similarly, Each puzzle has an `test/puzzle[1-3].test.js` hardhat test file. The test file includes $3$ unit tests for legit usages and $1$ test for attack purpose. The legit tests can run w/o the `*Attacker.sol` file but the attack tests cannot.

## With Remix

### Run Hardhat Test Cases in Remix

1. Open [remix](https://remix.ethereum.org/);
2. Enable `dGit` plugin in the `PLUGIN MANAGER` tab;
3. In `dGit` > `CLONE, PUSH, PULL & REMOTES` > `CLONE`, enter URL to this github repo, then click `clone`; 
4. Go to `FILE EXPLORERS` > drag down `workspace` > select the latest workspace,
    1. for each `*.sol` file in `contracts/` folder:
        1. Go to `SOLIDITY COMPILER`, compile `*.sol`.
5. Go to `FILE EXPLORERS` > `test/` folder,
    1. for each `*.test.js` file in `test/` folder
        1.Right click `*.test.js` and choose `run`.

### Play with Recordings

TBD