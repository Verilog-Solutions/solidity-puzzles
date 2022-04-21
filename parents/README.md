# Solidity Puzzles

```
 __      __       _ _                _____       _       _   _                 
 \ \    / /      (_| |              / ____|     | |     | | (_)                
  \ \  / ___ _ __ _| | ___   __ _  | (___   ___ | |_   _| |_ _  ___  _ __  ___ 
   \ \/ / _ | '__| | |/ _ \ / _` |  \___ \ / _ \| | | | | __| |/ _ \| '_ \/ __|
    \  |  __| |  | | | (_) | (_| |  ____) | (_) | | |_| | |_| | (_) | | | \__ \
     \/ \___|_|  |_|_|\___/ \__, | |_____/ \___/|_|\__,_|\__|_|\___/|_| |_|___/
                             __/ |                                             
                            |___/                                              
                                               
Verilog Solutions Inc. https://www.verilog.solutions
Verilog is a full-stack web3 security firm, covering smart contract auditing, 
validator operations, venture investment, and incubation.
Glad to prepare and present the materials for Game Day Remix in DevConnect Amsterdam!
```

This repo inlcudes three puzzles on smart contract written for Remix Game Day in DevConnect Amsterdam.

## Who Are They?

- **Puzzle One**: Yesterday Once More
	Time traveled back to 2016, you are the one who hard-fork the Ethereum blockchain.

- **Puzzle Two**: Safe and Sound
	No worry, our transfer is secured.

> Puzzle 3 is an extra puzzle. Try solve it and write the unit tests yourself!

## Play with Remix

### 1 Load files in remix

- Load files using `dGit` plugin
  1. Open [remix](https://remix.ethereum.org/);
  2. Enable `dGit` plugin in the `PLUGIN MANAGER` tab;
  3. In `dGit` > `CLONE, PUSH, PULL & REMOTES` > `CLONE`, enter URL to this github repo, then click `clone`; 
  4. Go to `FILE EXPLORERS` > drag down `workspace` > select the latest workspace,

### 2 Play Transactions Recordings

> Remix has a cool feature. It can record transactions as a scenario files and all the saved transactions can just be executed in one click.

We record the transactions which includes the contract deployments and attack executions. You can find a series transactions pop up automatically in remix console after playing the transactions. 

1. Open a scenario file `tx_records/puzzle*.json`
2. go to  `DEPLOY & RUN TRANSACTIONS`  > `Transactions recorded`
3. click the play button

### 3 Explore the Remix Debugger

Inside the remix console, you can see all the transactions. Pick one transaction and click the `Debug` button. 

You can pick the attacking transaction and try debugging it and see what happens exactly inside the exploits.

### 4 Run Tests & Try Fix bugs

We have prepared two kinds of tests. Try run the tests and fix bugs.

 1. solidity tests for remix unit tests (`tests/solidity_tests/*`)

    You can run it with the `SOLIDITY UNIT TESTING` plugin (need to activate it first inside the `PLUGIN MANAGER`).

 2.  javascripts unit tests which can be run both on remix and hardhat (`tests/js_tests/*`)

     - run on remix. (make sure you compiled all the contracts first)
      
       Just right click test file at the file explorer and choose `run`. 

     - run with hardhat locally with `yarn hardhat test`

