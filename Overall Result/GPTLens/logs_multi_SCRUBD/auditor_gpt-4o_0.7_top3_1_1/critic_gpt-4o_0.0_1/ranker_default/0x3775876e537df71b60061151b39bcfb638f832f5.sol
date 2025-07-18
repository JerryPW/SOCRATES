[
    {
        "function_name": "distributeDividend",
        "vulnerability": "Gas Limit in distributeDividend",
        "criticism": "The reasoning is correct. The distributeDividend function does use a fixed gas limit of 3000 for the call to transfer ETH. If the receiving account is a contract, this limit may not be sufficient, causing the transfer to fail. However, the severity and profitability of this vulnerability are moderate. The severity is moderate because it can prevent certain accounts from receiving their dividends. The profitability is also moderate because an attacker could potentially exploit this to block others' earnings.",
        "correctness": 7,
        "severity": 5,
        "profitability": 5,
        "reason": "The distributeDividend function uses a fixed gas limit of 3000 for the call to transfer ETH. If the receiving account is a contract, this limit may not be sufficient, causing the transfer to fail. This can be exploited to prevent certain accounts from receiving their dividends, effectively blocking their earnings.",
        "code": "function distributeDividend(address shareholder) internal { if(shares[shareholder].amount == 0){ return; } uint256 amount = getUnpaidEarnings(shareholder); if(amount > 0){ (bool success,) = payable(shareholder).call{value: amount, gas: 3000}(\"\"); if(success){ totalDistributed = totalDistributed.add(amount); shareholderClaims[shareholder] = block.timestamp; shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount); shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount); } } }",
        "file_name": "0x3775876e537df71b60061151b39bcfb638f832f5.sol",
        "final_score": 6.0
    },
    {
        "function_name": "emergencyWithdraw",
        "vulnerability": "Loss of Rewards on Emergency Withdraw",
        "criticism": "The reasoning is correct. The emergencyWithdraw function does reset the user's pending rewards to 0 and adds them back to the pool. However, the severity and profitability of this vulnerability are low. The severity is low because it is a design decision to prevent users from withdrawing rewards without unstaking. The profitability is also low because an external attacker cannot profit from this vulnerability.",
        "correctness": 7,
        "severity": 2,
        "profitability": 0,
        "reason": "When a user calls emergencyWithdraw, their pending rewards in both USDT and ETH are reset to 0 and added back to the pool, meaning they lose any unclaimed rewards. This can be exploited by repeatedly calling emergencyWithdraw to reset rewards, depriving other users of their share of the rewards.",
        "code": "function emergencyWithdraw() external nonReentrant { UserInfo storage user = userInfo[msg.sender]; uint256 amountToTransfer = user.amount; user.amount = 0; user.depositTime = 0; totalStakedAmount = totalStakedAmount.sub(amountToTransfer); user.rewardUsdtDebt = 0; amountUsdtForReward = amountUsdtForReward.add(user.pendingUsdtReward); user.pendingUsdtReward = 0; user.rewardEthDebt = 0; amountEthForReward = amountEthForReward.add(user.pendingEthReward); user.pendingEthReward = 0; if (amountToTransfer > 0) { token.transfer(address(msg.sender), amountToTransfer); } emit EmergencyWithdraw(msg.sender, amountToTransfer); }",
        "file_name": "0x3775876e537df71b60061151b39bcfb638f832f5.sol",
        "final_score": 4.0
    },
    {
        "function_name": "_transfer",
        "vulnerability": "Reentrancy through Uniswap",
        "criticism": "The reasoning is incorrect. The _transfer function does include a swapAndSend call, but it is protected by the inSwapAndLiquify modifier, which prevents reentrancy. Therefore, an attacker cannot reenter the function during the swap. The severity and profitability of this vulnerability are both very low.",
        "correctness": 2,
        "severity": 0,
        "profitability": 0,
        "reason": "The function _transfer includes a swapAndSend call that can be reentered through Uniswap callbacks, even though it is protected with a nonReentrant modifier. This allows an attacker to reenter the function during the swap and manipulate the token balances or dividends distribution, leading to potential financial loss.",
        "code": "function _transfer( address from, address to, uint256 amount ) internal override { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(isInBlacklist[from] == false, \"You're in blacklist\"); if(from == address(uniswapV2Pair) && !_isMaxBuyExempt[to]){ require(amount <= _totalSupply.mul(numMaxPerBuyPercent).div(1000), \"Check max per buy percent\"); } if(from != owner() && from != address(this) && to == address(uniswapV2Pair)){ require(block.timestamp >= _lastSellingTime[from].add(1 hours), \"Only sell once \"); _lastSellingTime[from] = block.timestamp; } if(from == address(uniswapV2Pair)){ distributor.notifyJustBuyRecently(to); } bool swapped = false; uint256 contractTokenBalance = balanceOf(address(this)); bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity; if ( overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled ) { swapAndSend(); swapped = true; } bool takeFee = true; if(_isFeesExempt[from] || _isFeesExempt[to]) { takeFee = false; } if(takeFee) { uint256 fees = amount.mul(_liquidityFee.add(_ethReflectionFee).add(_stakingFee).add(_marketingFee)).div(1000); amount = amount.sub(fees); super._transfer(from, address(this), fees); } if(!_isMaxPerWalletExempt[to]){ require(balanceOf(to).add(amount) <= _totalSupply.mul(numMaxPerWalletPercent).div(1000), \"Check max per wallet percent\"); } super._transfer(from, to, amount); if(!_isDividendExempt[from]){ try distributor.setShare(from, balanceOf(from)) {} catch {} } if(!_isDividendExempt[to]){ try distributor.setShare(to, balanceOf(to)) {} catch {} } if(!swapped) try distributor.process(distributorGas) {} catch {} }",
        "file_name": "0x3775876e537df71b60061151b39bcfb638f832f5.sol",
        "final_score": 1.0
    }
]