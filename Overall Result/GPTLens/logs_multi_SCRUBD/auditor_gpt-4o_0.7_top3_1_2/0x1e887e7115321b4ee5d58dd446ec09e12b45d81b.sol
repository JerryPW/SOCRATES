[
    {
        "function_name": "POOL1_update",
        "code": "function POOL1_update() private { uint lpSupply = lp.balanceOf(address(this)); if (POOL1_lastRewardBlock == 0 || lpSupply == 0) { POOL1_lastRewardBlock = block.number; return; } uint reward = POOL1_getReward(POOL1_lastRewardBlock, block.number); token.mint(address(this), reward); token.mint(GOVERNANCE, reward.mul(GOVERNANCE_P).div(100*PRECISION)); token.mint(DEV_FUND, reward.mul(DEV_FUND_P).div(100*PRECISION)); POOL1_accTokensPerLP = POOL1_accTokensPerLP.add( reward.mul(1e18).div(lpSupply) ); POOL1_lastRewardBlock = block.number; if(block.number >= POOL1_MULTIPLIER_UPDATED.add(POOL1_MULTIPLIER_UPDATE_EVERY)){ POOL1_MULTIPLIER = POOL1_MULTIPLIER.mul(3).div(4); POOL1_MULTIPLIER_UPDATED = block.number; } }",
        "vulnerability": "Potential mint overflow",
        "reason": "The mint function is called without verifying if the reward calculation could lead to an overflow. While the SafeMath library is used, the unchecked external mint function might lead to an unintended token supply increase if the reward value is extremely large.",
        "file_name": "0x1e887e7115321b4ee5d58dd446ec09e12b45d81b.sol"
    },
    {
        "function_name": "POOL2_unstake",
        "code": "function POOL2_unstake(uint amount) external{ User storage u = users[msg.sender]; require(amount > 0, \"Unstaking 0 ETH.\"); require(u.POOL2_provided >= amount, \"Unstaking more than currently staked.\"); _POOL2_harvest(msg.sender, 0); msg.sender.transfer(amount); u.POOL2_provided = u.POOL2_provided.sub(amount); u.POOL2_rewardDebt = u.POOL2_provided.mul(POOL2_accTokensPerETH).div(1e18); }",
        "vulnerability": "Reentrancy risk",
        "reason": "The function allows an external call (transfer of ETH) before updating the user\u2019s state (u.POOL2_provided and u.POOL2_rewardDebt). This can be exploited for reentrancy attacks to manipulate the contract state maliciously.",
        "file_name": "0x1e887e7115321b4ee5d58dd446ec09e12b45d81b.sol"
    },
    {
        "function_name": "POOL1_stake",
        "code": "function POOL1_stake(uint amount, address referral) external{ require(tx.origin == msg.sender, \"Contracts not allowed.\"); require(block.number >= POOLS_START, \"Pool hasn't started yet.\"); require(amount > 0, \"Staking 0 lp.\"); uint lpSupplyBefore = lp.balanceOf(address(this)); _POOL1_harvest(msg.sender); lp.transferFrom(msg.sender, address(this), amount); User storage u = users[msg.sender]; u.POOL1_provided = u.POOL1_provided.add(amount); u.POOL1_rewardDebt = u.POOL1_provided.mul(POOL1_accTokensPerLP).div(1e18); if(!u.NFT_CREDITS_receiving && u.POOL1_provided >= lpSupplyBefore.mul(POOL1_CREDITS_MIN_P).div(100)){ u.NFT_CREDITS_receiving = true; u.NFT_CREDITS_lastUpdated = block.number; } if(u.POOL1_referral == address(0) && referral != address(0) && referral != msg.sender){ u.POOL1_referral = referral; } }",
        "vulnerability": "Incorrect use of tx.origin",
        "reason": "Using tx.origin to prevent contract calls is not recommended as it can be easily bypassed by attackers through intermediate contracts. This vulnerability can lead to unexpected behavior and can be exploited to bypass security checks.",
        "file_name": "0x1e887e7115321b4ee5d58dd446ec09e12b45d81b.sol"
    }
]