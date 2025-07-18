[
    {
        "function_name": "POOL1_update",
        "code": "function POOL1_update() private { uint lpSupply = lp.balanceOf(address(this)); if (POOL1_lastRewardBlock == 0 || lpSupply == 0) { POOL1_lastRewardBlock = block.number; return; } uint reward = POOL1_getReward(POOL1_lastRewardBlock, block.number); token.mint(address(this), reward); token.mint(GOVERNANCE, reward.mul(GOVERNANCE_P).div(100*PRECISION)); token.mint(DEV_FUND, reward.mul(DEV_FUND_P).div(100*PRECISION)); POOL1_accTokensPerLP = POOL1_accTokensPerLP.add( reward.mul(1e18).div(lpSupply) ); POOL1_lastRewardBlock = block.number; if(block.number >= POOL1_MULTIPLIER_UPDATED.add(POOL1_MULTIPLIER_UPDATE_EVERY)){ POOL1_MULTIPLIER = POOL1_MULTIPLIER.mul(3).div(4); POOL1_MULTIPLIER_UPDATED = block.number; } }",
        "vulnerability": "Potential minting without limit",
        "reason": "The function mints tokens based on the number of blocks since the last update multiplied by a multiplier. If called repeatedly without proper control, it can lead to excessive minting of tokens, inflating the supply and potentially devaluing the token.",
        "file_name": "0x1e887e7115321b4ee5d58dd446ec09e12b45d81b.sol"
    },
    {
        "function_name": "POOL2_update",
        "code": "function POOL2_update(uint ethJustStaked) private { uint ethSupply = address(this).balance.sub(ethJustStaked); if (POOL2_lastRewardBlock == 0 || ethSupply == 0) { POOL2_lastRewardBlock = block.number; return; } uint reward = POOL2_getReward(POOL2_lastRewardBlock, block.number); token.mint(address(this), reward); token.mint(GOVERNANCE, reward.mul(GOVERNANCE_P).div(100*PRECISION)); token.mint(DEV_FUND, reward.mul(DEV_FUND_P).div(100*PRECISION)); POOL2_accTokensPerETH = POOL2_accTokensPerETH.add(reward.mul(1e18).div(ethSupply)); POOL2_lastRewardBlock = block.number; }",
        "vulnerability": "Unlimited minting potential",
        "reason": "Similar to POOL1_update, this function mints tokens based on the duration since the last update. Without proper restrictions, this could lead to excessive minting, especially if the pool is manipulated to have zero ETH supply temporarily.",
        "file_name": "0x1e887e7115321b4ee5d58dd446ec09e12b45d81b.sol"
    },
    {
        "function_name": "spendCredits",
        "code": "function spendCredits(address a, uint requiredCredits) external{ require(msg.sender == nft, \"Can only called by GFarmNFT.\"); User storage u = users[a]; u.NFT_CREDITS_amount = NFT_CREDITS_amount(a).sub(requiredCredits); u.NFT_CREDITS_lastUpdated = block.number; }",
        "vulnerability": "Lack of access control",
        "reason": "Although the function checks if the caller is the NFT contract, there's no mechanism to verify if the required credits match the correct conditions or if the caller has the authority to spend them. This could lead to unauthorized spending of credits.",
        "file_name": "0x1e887e7115321b4ee5d58dd446ec09e12b45d81b.sol"
    }
]