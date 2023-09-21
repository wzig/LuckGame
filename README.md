## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
forge build --extra-output=abi
```

### Test

```shell
forge test
```

### Format

```shell
forge fmt
```

### Gas Snapshots

```shell
forge snapshot
```

### Anvil

```shell
anvil
```

### Deploy

```shell
forge script script/Lottery.s.sol:LotteryScript --rpc-url http://127.0.0.1:8545 --broadcast
forge script script/Wallet.s.sol:WalletScript --rpc-url http://127.0.0.1:8545 --broadcast

```

### Cast

```shell
cast <subcommand>
```

### Help

```shell
forge --help
anvil --help
cast --help
```

### Misc

(0) "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" (10000.000000000000000000 ETH)
(1) "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" (10000.000000000000000000 ETH)
(2) "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" (10000.000000000000000000 ETH)
(3) "0x90F79bf6EB2c4f870365E785982E1f101E93b906" (10000.000000000000000000 ETH)
(4) "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" (10000.000000000000000000 ETH)
(5) "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" (10000.000000000000000000 ETH)
(6) "0x976EA74026E726554dB657fA54763abd0C3a0aa9" (10000.000000000000000000 ETH)
(7) "0x14dC79964da2C08b23698B3D3cc7Ca32193d9955" (10000.000000000000000000 ETH)
(8) "0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f" (10000.000000000000000000 ETH)
(9) "0xa0Ee7A142d267C1f36714E4a8F75612F20a79720" (10000.000000000000000000 ETH)
(10) "0xBcd4042DE499D14e55001CcbB24a551F3b954096" (10000.000000000000000000 ETH)
(11) "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" (10000.000000000000000000 ETH)
(12) "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" (10000.000000000000000000 ETH)
(13) "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" (10000.000000000000000000 ETH)
(14) "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" (10000.000000000000000000 ETH)
(15) "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" (10000.000000000000000000 ETH)
(16) "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" (10000.000000000000000000 ETH)
(17) "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" (10000.000000000000000000 ETH)
(18) "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" (10000.000000000000000000 ETH)
(19) "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" (10000.000000000000000000 ETH)
(20) "0x09DB0a93B389bEF724429898f539AEB7ac2Dd55f" (10000.000000000000000000 ETH)
(21) "0x02484cb50AAC86Eae85610D6f4Bf026f30f6627D" (10000.000000000000000000 ETH)
(22) "0x08135Da0A343E492FA2d4282F2AE34c6c5CC1BbE" (10000.000000000000000000 ETH)
(23) "0x5E661B79FE2D3F6cE70F5AAC07d8Cd9abb2743F1" (10000.000000000000000000 ETH)
(24) "0x61097BA76cD906d2ba4FD106E757f7Eb455fc295" (10000.000000000000000000 ETH)
(25) "0xDf37F81dAAD2b0327A0A50003740e1C935C70913" (10000.000000000000000000 ETH)
(26) "0x553BC17A05702530097c3677091C5BB47a3a7931" (10000.000000000000000000 ETH)
(27) "0x87BdCE72c06C21cd96219BD8521bDF1F42C78b5e" (10000.000000000000000000 ETH)
(28) "0x40Fc963A729c542424cD800349a7E4Ecc4896624" (10000.000000000000000000 ETH)
(29) "0x9DCCe783B6464611f38631e6C851bf441907c710" (10000.000000000000000000 ETH)

# Private Keys

(0) 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
(1) 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
(2) 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a
(3) 0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6
(4) 0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a
(5) 0x8b3a350cf5c34c9194ca85829a2df0ec3153be0318b5e2d3348e872092edffba
(6) 0x92db14e403b83dfe3df233f83dfa3a0d7096f21ca9b0d6d6b8d88b2b4ec1564e
(7) 0x4bbbf85ce3377467afe5d46f804f221813b2bb87f24d81f60f1fcdbf7cbf4356
(8) 0xdbda1821b80551c9d65939329250298aa3472ba22feea921c0cf5d620ea67b97
(9) 0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6
(10) 0xf214f2b2cd398c806f84e317254e0f0b801d0643303237d97a22a48e01628897
(11) 0x701b615bbdfb9de65240bc28bd21bbc0d996645a3dd57e7b12bc2bdf6f192c82
(12) 0xa267530f49f8280200edf313ee7af6b827f2a8bce2897751d06a843f644967b1
(13) 0x47c99abed3324a2707c28affff1267e45918ec8c3f20b8aa892e8b065d2942dd
(14) 0xc526ee95bf44d8fc405a158bb884d9d1238d99f0612e9f33d006bb0789009aaa
(15) 0x8166f546bab6da521a8369cab06c5d2b9e46670292d85c875ee9ec20e84ffb61
(16) 0xea6c44ac03bff858b476bba40716402b03e41b8e97e276d1baec7c37d42484a0
(17) 0x689af8efa8c651a91ad287602527f3af2fe9f6501a7ac4b061667b5a93e037fd
(18) 0xde9be858da4a475276426320d5e9262ecfc3ba460bfac56360bfa6c4c28b4ee0
(19) 0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e
(20) 0xeaa861a9a01391ed3d587d8a5a84ca56ee277629a8b02c22093a419bf240e65d
(21) 0xc511b2aa70776d4ff1d376e8537903dae36896132c90b91d52c1dfbae267cd8b
(22) 0x224b7eb7449992aac96d631d9677f7bf5888245eef6d6eeda31e62d2f29a83e4
(23) 0x4624e0802698b9769f5bdb260a3777fbd4941ad2901f5966b854f953497eec1b
(24) 0x375ad145df13ed97f8ca8e27bb21ebf2a3819e9e0a06509a812db377e533def7
(25) 0x18743e59419b01d1d846d97ea070b5a3368a3e7f6f0242cf497e1baac6972427
(26) 0xe383b226df7c8282489889170b0f68f66af6459261f4833a781acd0804fafe7a
(27) 0xf3a6b71b94f5cd909fb2dbb287da47badaa6d8bcdc45d595e2884835d8749001
(28) 0x4e249d317253b9641e477aba8dd5d8f1f7cf5250a5acadd1229693e262720a19
(29) 0x233c86e887ac435d7f7dc64979d7758d69320906a0d340d2b6518b0fd20aa998

cast call 0xA15BB66138824a1c7167f5E85b957d04Dd34E468 "totalSupply()(uint256)" --rpc-url http://127.0.0.1:8545

cast call 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 "getBalance()(uint256)" --rpc-url http://127.0.0.1:8545

8603853182003814300330472690

anvil -f https://mainnet.infura.io/v3/e5ebbe58d5c644478647da843d5b465c

anvil -f https://goerli.infura.io/v3/e5ebbe58d5c644478647da843d5b465c

anvil -a 30 -f https://mainnet.base.org --chain-id 31337 -b 2

---

export PRIVATE_KEY=0xdbda1821b80551c9d65939329250298aa3472ba22feea921c0cf5d620ea67b97
0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f

tusdc.mint(0x5E661B79FE2D3F6cE70F5AAC07d8Cd9abb2743F1, 100000 ether);
tusdc.mint(0x61097BA76cD906d2ba4FD106E757f7Eb455fc295, 100000 ether);
tusdc.mint(0x87BdCE72c06C21cd96219BD8521bDF1F42C78b5e, 100000 ether);
tusdc.mint(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc, 100000 ether);
tusdc.mint(0x9DCCe783B6464611f38631e6C851bf441907c710, 100000 ether);
