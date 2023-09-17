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

---

export PRIVATE_KEY=0xdbda1821b80551c9d65939329250298aa3472ba22feea921c0cf5d620ea67b97
0xa0Ee7A142d267C1f36714E4a8F75612F20a79720
