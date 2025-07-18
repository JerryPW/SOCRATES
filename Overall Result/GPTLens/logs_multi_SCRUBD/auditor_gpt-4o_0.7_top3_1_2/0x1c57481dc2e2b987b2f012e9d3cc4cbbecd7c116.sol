[
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Improper recipient address in swapExactETHForTokens",
        "reason": "The function `buyNBurn` uses `address(0)` as the recipient address for the Uniswap swap function `swapExactETHForTokens`. This implies that the tokens received from the swap will be sent to the zero address, effectively burning them. However, this might not be the intended behavior if the purpose was to burn the tokens received by the contract itself or another specific address. Additionally, if the smart contract does not have a fallback function to receive tokens, this could result in a loss of the swapped tokens.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    },
    {
        "function_name": "extractYELDEarningsWhileKeepingDeposit",
        "code": "function extractYELDEarningsWhileKeepingDeposit() public { uint256 ibalance = balanceOf(msg.sender); uint256 accomulatedStablecoins = (calcPoolValueInToken().mul(ibalance)).div(_totalSupply); require(depositBlockStarts[msg.sender] > 0 && accomulatedStablecoins > 0, 'Must have deposited stablecoins beforehand'); uint256 generatedYelds = getGeneratedYelds(); depositBlockStarts[msg.sender] = block.number; yeldToken.transfer(msg.sender, generatedYelds); }",
        "vulnerability": "Lack of reentrancy guard",
        "reason": "The function `extractYELDEarningsWhileKeepingDeposit` allows users to extract YELD earnings. However, it does not have a reentrancy guard, which could potentially allow an attacker to exploit this by calling the function multiple times in a single transaction to extract more YELD tokens than intended, if another vulnerability allows reentrant calls.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _shares) external nonReentrant { require(_shares > 0, \"withdraw must be greater than 0\"); uint256 ibalance = balanceOf(msg.sender); require(_shares <= ibalance, \"insufficient balance\"); pool = _calcPoolValueInToken(); uint256 generatedYelds = getGeneratedYelds(); uint256 stablecoinsToWithdraw = (pool.mul(_shares)).div(_totalSupply); _balances[msg.sender] = _balances[msg.sender].sub(_shares, \"redeem amount exceeds balance\"); _totalSupply = _totalSupply.sub(_shares); emit Transfer(msg.sender, address(0), _shares); uint256 b = IERC20(token).balanceOf(address(this)); if (b < stablecoinsToWithdraw) { _withdrawSome(stablecoinsToWithdraw.sub(b)); } uint256 onePercent = stablecoinsToWithdraw.div(100); depositBlockStarts[msg.sender] = block.number; yeldToken.transfer(msg.sender, generatedYelds); uint256 stakingProfits = tusdToETH(onePercent); uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0)); if (tokensAlreadyBurned < maximumTokensToBurn) { uint256 ethToSwap = stakingProfits.mul(98).div(100); buyNBurn(ethToSwap); uint256 retirementYeld = stakingProfits.mul(2).div(100); retirementYeldTreasury.transfer(retirementYeld); } else { uint256 retirementYeld = stakingProfits; retirementYeldTreasury.transfer(retirementYeld); } IERC20(token).safeTransfer(msg.sender, stablecoinsToWithdraw.sub(onePercent)); pool = _calcPoolValueInToken(); rebalance(); }",
        "vulnerability": "Potential front-running due to oracle manipulation",
        "reason": "The `withdraw` function calculates the amount of stablecoins to withdraw based on the pool value at the time of the call. If the pool value is derived from an external price oracle that is not resistant to manipulation, an attacker could potentially manipulate the oracle to withdraw more stablecoins than they are entitled to, leading to financial loss for other participants in the pool.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    }
]