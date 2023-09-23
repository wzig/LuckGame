export TEST_DEPLOY=1 && forge script script/Luck.s.sol:LotteryScript --rpc-url http://127.0.0.1:8545 --broadcast

export USDT=0xdac17f958d2ee523a2206206994597c13d831ec7
export LUCKY_USER=0x47ac0Fb4F2D84898e4D9E7b4DaB3C24507a6D503

export ALICE=0x5E661B79FE2D3F6cE70F5AAC07d8Cd9abb2743F1

cast call $USDT \
    "balanceOf(address)(uint256)" \
    $LUCKY_USER

# This calls Anvil and lets us impersonate our lucky user

cast rpc anvil_impersonateAccount $LUCKY_USER

cast send $USDT \
    --unlocked \
    --from $LUCKY_USER \
    "transfer(address,uint256)(bool)" \
    $ALICE \
    1220000115485

cast call $USDT \
    "balanceOf(address)(uint256)" \
    $ALICE
# =====>
export ALICE=0x9DCCe783B6464611f38631e6C851bf441907c710

cast call $USDT \
    "balanceOf(address)(uint256)" \
    $LUCKY_USER

# This calls Anvil and lets us impersonate our lucky user

cast rpc anvil_impersonateAccount $LUCKY_USER

cast send $USDT \
    --unlocked \
    --from $LUCKY_USER \
    "transfer(address,uint256)(bool)" \
    $ALICE \
    1220000115485124

cast call $USDT \
    "balanceOf(address)(uint256)" \
    $ALICE
