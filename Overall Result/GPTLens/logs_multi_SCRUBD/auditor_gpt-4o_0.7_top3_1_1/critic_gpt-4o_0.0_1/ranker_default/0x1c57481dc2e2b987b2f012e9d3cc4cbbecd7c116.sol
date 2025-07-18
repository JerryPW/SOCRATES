[
    {
        "function_name": "deposit",
        "vulnerability": "Incorrect Accounting of Shares",
        "criticism": "The reasoning is correct. The calculation of shares is indeed dependent on the pool value before the deposit is completed, which could potentially be manipulated by an attacker. This could result in incorrect share allocations, leading to potential loss of funds for other users. The severity and profitability of this vulnerability are high.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The calculation of shares in the deposit function can be manipulated by an attacker due to the dependency on the pool value before the deposit is completed. This could result in incorrect share allocations, allowing an attacker to gain more shares than they should, leading to potential loss of funds for other users.",
        "code": "function deposit(uint256 _amount) external nonReentrant { require(_amount > 0, \"deposit must be greater than 0\"); pool = _calcPoolValueInToken(); IERC20(token).safeTransferFrom(msg.sender, address(this), _amount); if (getGeneratedYelds() > 0) extractYELDEarningsWhileKeepingDeposit(); depositBlockStarts[msg.sender] = block.number; uint256 shares = 0; if (pool == 0) { shares = _amount; pool = _amount; } else { shares = (_amount.mul(_totalSupply)).div(pool); } pool = _calcPoolValueInToken(); _mint(msg.sender, shares); rebalance(); }",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol",
        "final_score": 8.5
    },
    {
        "function_name": "buyNBurn",
        "vulnerability": "Arbitrary Token Transfer",
        "criticism": "The reasoning is partially correct. The function does send tokens to the zero address, effectively burning them. However, the claim that an attacker could modify the Uniswap router to redirect tokens is incorrect. The Uniswap router is a smart contract on the Ethereum blockchain and cannot be modified by an attacker. Therefore, the severity and profitability of this vulnerability are very low.",
        "correctness": 4,
        "severity": 1,
        "profitability": 0,
        "reason": "The buyNBurn function sets the recipient of the swap to the zero address, which means tokens could be sent to an address that cannot use them, effectively burning them. However, an attacker could modify the Uniswap router to direct these tokens to an address they control, resulting in a loss of funds for the contract.",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol",
        "final_score": 2.25
    },
    {
        "function_name": "withdraw",
        "vulnerability": "Reentrancy Attack Risk",
        "criticism": "The reasoning is incorrect. The function uses the nonReentrant modifier, which prevents reentrancy attacks by not allowing the function to be re-entered until it has finished executing. Therefore, the function is not vulnerable to reentrancy attacks. The severity and profitability of this vulnerability are very low.",
        "correctness": 0,
        "severity": 0,
        "profitability": 0,
        "reason": "The withdraw function does not use the checks-effects-interactions pattern, which makes it vulnerable to reentrancy attacks. An attacker could potentially call the withdraw function recursively before the state is fully updated, allowing them to drain funds from the contract.",
        "code": "function withdraw(uint256 _shares) external nonReentrant { require(_shares > 0, \"withdraw must be greater than 0\"); uint256 ibalance = balanceOf(msg.sender); require(_shares <= ibalance, \"insufficient balance\"); pool = _calcPoolValueInToken(); uint256 generatedYelds = getGeneratedYelds(); uint256 stablecoinsToWithdraw = (pool.mul(_shares)).div(_totalSupply); _balances[msg.sender] = _balances[msg.sender].sub(_shares, \"redeem amount exceeds balance\"); _totalSupply = _totalSupply.sub(_shares); emit Transfer(msg.sender, address(0), _shares); uint256 b = IERC20(token).balanceOf(address(this)); if (b < stablecoinsToWithdraw) { _withdrawSome(stablecoinsToWithdraw.sub(b)); } uint256 onePercent = stablecoinsToWithdraw.div(100); depositBlockStarts[msg.sender] = block.number; yeldToken.transfer(msg.sender, generatedYelds); uint256 stakingProfits = tusdToETH(onePercent); uint256 tokensAlreadyBurned = yeldToken.balanceOf(address(0)); if (tokensAlreadyBurned < maximumTokensToBurn) { uint256 ethToSwap = stakingProfits.mul(98).div(100); buyNBurn(ethToSwap); uint256 retirementYeld = stakingProfits.mul(2).div(100); retirementYeldTreasury.transfer(retirementYeld); } else { uint256 retirementYeld = stakingProfits; retirementYeldTreasury.transfer(retirementYeld); } IERC20(token).safeTransfer(msg.sender, stablecoinsToWithdraw.sub(onePercent)); pool = _calcPoolValueInToken(); rebalance(); }",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol",
        "final_score": 0.0
    }
]