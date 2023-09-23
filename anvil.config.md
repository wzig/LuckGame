```bash
export USDT=0xdac17f958d2ee523a2206206994597c13d831ec7
export ALICE=0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
export LUCKY_USER=0x47ac0Fb4F2D84898e4D9E7b4DaB3C24507a6D503

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



```
