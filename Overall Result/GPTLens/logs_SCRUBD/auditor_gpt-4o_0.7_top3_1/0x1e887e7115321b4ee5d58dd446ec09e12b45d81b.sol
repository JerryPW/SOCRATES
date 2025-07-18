[
    {
        "function_name": "POOL1_update",
        "code": "function POOL1_update() private { uint lpSupply = lp.balanceOf(address(this)); if (POOL1_lastRewardBlock == 0 || lpSupply == 0) { POOL1_lastRewardBlock = block.number; return; } uint reward = POOL1_getReward(POOL1_lastRewardBlock, block.number); token.mint(address(this), reward); token.mint(GOVERNANCE, reward.mul(GOVERNANCE_P).div(100*PRECISION)); token.mint(DEV_FUND, reward.mul(DEV_FUND_P).div(100*PRECISION)); POOL1_accTokensPerLP = POOL1_accTokensPerLP.add( reward.mul(1e18).div(lpSupply) ); POOL1_lastRewardBlock = block.number; if(block.number >= POOL1_MULTIPLIER_UPDATED.add(POOL1_MULTIPLIER_UPDATE_EVERY)){ POOL1_MULTIPLIER = POOL1_MULTIPLIER.mul(3).div(4); POOL1_MULTIPLIER_UPDATED = block.number; } }",
        "vulnerability": "Unrestricted token minting",
        "reason": "The function allows unrestricted minting of tokens without any validation of the 'reward'. This could potentially lead to infinite inflation of tokens, allowing an attacker to mint unlimited tokens and transfer them to an address they control.",
        "file_name": "0x1e887e7115321b4ee5d58dd446ec09e12b45d81b.sol"
    },
    {
        "function_name": "POOL2_update",
        "code": "function POOL2_update(uint ethJustStaked) private { uint ethSupply = address(this).balance.sub(ethJustStaked); if (POOL2_lastRewardBlock == 0 || ethSupply == 0) { POOL2_lastRewardBlock = block.number; return; } uint reward = POOL2_getReward(POOL2_lastRewardBlock, block.number); token.mint(address(this), reward); token.mint(GOVERNANCE, reward.mul(GOVERNANCE_P).div(100*PRECISION)); token.mint(DEV_FUND, reward.mul(DEV_FUND_P).div(100*PRECISION)); POOL2_accTokensPerETH = POOL2_accTokensPerETH.add(reward.mul(1e18).div(ethSupply)); POOL2_lastRewardBlock = block.number; }",
        "vulnerability": "Unrestricted token minting",
        "reason": "Similar to POOL1_update, this function also allows unrestricted minting of tokens without any validation checks. The lack of validation can lead to infinite inflation of tokens, benefiting an attacker who can mint and control a massive amount of tokens.",
        "file_name": "0x1e887e7115321b4ee5d58dd446ec09e12b45d81b.sol"
    },
    {
        "function_name": "POOL1_stake",
        "code": "function POOL1_stake(uint amount, address referral) external{ require(tx.origin == msg.sender, \"Contracts not allowed.\"); require(block.number >= POOLS_START, \"Pool hasn't started yet.\"); require(amount > 0, \"Staking 0 lp.\"); uint lpSupplyBefore = lp.balanceOf(address(this)); _POOL1_harvest(msg.sender); lp.transferFrom(msg.sender, address(this), amount); User storage u = users[msg.sender]; u.POOL1_provided = u.POOL1_provided.add(amount); u.POOL1_rewardDebt = u.POOL1_provided.mul(POOL1_accTokensPerLP).div(1e18); if(!u.NFT_CREDITS_receiving && u.POOL1_provided >= lpSupplyBefore.mul(POOL1_CREDITS_MIN_P).div(100)){ u.NFT_CREDITS_receiving = true; u.NFT_CREDITS_lastUpdated = block.number; } if(u.POOL1_referral == address(0) && referral != address(0) && referral != msg.sender){ u.POOL1_referral = referral; } }",
        "vulnerability": "Reentrancy attack potential",
        "reason": "The function calls an external contract's transferFrom method before updating the user's state variables. This sequence could potentially be exploited by a reentrancy attack if the external call allows reentrancy, leading to inconsistencies in state variables and possible double-spending.",
        "file_name": "0x1e887e7115321b4ee5d58dd446ec09e12b45d81b.sol"
    }
]