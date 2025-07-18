[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) { require(amount > 0, \"Cannot withdraw 0\"); require(_balances[msg.sender].sub(amount) >= minLp || _balances[msg.sender].sub(amount) == 0, \"wrong amount\"); _totalSupply = _totalSupply.sub(amount); _balances[msg.sender] = _balances[msg.sender].sub(amount); uint256 fee = amount.div(feeRate); stakingToken.transfer(0x1111111111111111111111111111111111111111, fee); stakingToken.transfer(msg.sender, amount.sub(fee)); emit Withdrawn(msg.sender, amount); }",
        "vulnerability": "Funds sent to burn address",
        "reason": "The function sends the fee to a hardcoded burn address (0x1111111111111111111111111111111111111111) rather than the treasury or owner, resulting in a permanent loss of funds. It is exploitable as users can continuously withdraw and burn their funds, leading to unnecessary losses without any benefit to the contract or treasury.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "recoverERC20",
        "code": "function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner { require( tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken), \"Cannot withdraw the staking or rewards tokens\" ); IERC20(tokenAddress).transfer(this.owner(), tokenAmount); emit Recovered(tokenAddress, tokenAmount); }",
        "vulnerability": "Potential token theft by owner",
        "reason": "The function allows the owner to withdraw any ERC20 tokens from the contract, except the staking and rewards tokens. This can be exploited by malicious owners to drain any other valuable tokens sent to the contract inadvertently or otherwise, leading to potential theft from users who might send tokens mistakenly.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "notifyRewardAmount",
        "code": "function notifyRewardAmount(uint256 reward) external onlyOwner updateReward(address(0)) { if (block.timestamp >= periodFinish) { rewardRate = reward.div(rewardsDuration); } else { uint256 remaining = periodFinish.sub(block.timestamp); uint256 leftover = remaining.mul(rewardRate); rewardRate = reward.add(leftover).div(rewardsDuration); } uint256 balance = rewardsToken.balanceOf(address(this)); require( rewardRate <= balance.div(rewardsDuration), \"Provided reward too high\" ); lastUpdateTime = block.timestamp; periodFinish = block.timestamp.add(rewardsDuration); emit RewardAdded(reward); }",
        "vulnerability": "Rewards manipulation",
        "reason": "The owner can arbitrarily call this function to manipulate the reward rate and distribution timing, potentially leading to unfair distribution of rewards. If misused, it could result in the owner setting a reward rate that is unsustainable or unfairly skewed towards specific periods, benefiting certain participants over others.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    }
]