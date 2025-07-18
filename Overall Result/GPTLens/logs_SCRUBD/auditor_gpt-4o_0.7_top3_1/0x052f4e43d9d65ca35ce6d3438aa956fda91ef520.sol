[
    {
        "function_name": "swapBack",
        "code": "function swapBack() private nonReentrant { uint256 splitLiquidityPortion = lpPortionOfSwap.div(2); uint256 amountToLiquify = balanceOf(address(this)).mul(splitLiquidityPortion).div(FEES_DIVISOR); uint256 amountToSwap = balanceOf(address(this)).sub(amountToLiquify); uint256 balanceBefore = address(this).balance; swapTokensForETH(amountToSwap); uint256 amountBNB = address(this).balance.sub(balanceBefore); uint256 amountBNBMarketing = amountBNB.mul(marketingPortionOfSwap).div(FEES_DIVISOR); uint256 amountBNBDevolpment = amountBNB.mul(devolpmentPortionOfSwap).div(FEES_DIVISOR); uint256 amountBNBLiquidity = amountBNB.mul(splitLiquidityPortion).div(FEES_DIVISOR); transferToAddress(payable(marketingWallet), amountBNBMarketing); transferToAddress(payable(devolpmentWallet), amountBNBDevolpment); _addLiquidity(amountToLiquify, amountBNBLiquidity); }",
        "vulnerability": "Reentrancy attack",
        "reason": "Although the function is marked as nonReentrant, it is technically possible for reentrancy to occur due to the external call to swapTokensForETH, which swaps tokens for ETH. This function swaps tokens and then uses BNB balance to distribute amounts to marketing and development wallets and add liquidity. If swapTokensForETH involves any callback that could interact with this contract again before the balances are updated, it could lead to double-spend exploits.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address recipient, uint256 amount) external override returns (bool){ _transfer(_msgSender(), recipient, amount); return true; }",
        "vulnerability": "Lack of checks for locked funds",
        "reason": "The transfer function lacks checks for locked funds or time-based restrictions, which could result in users being able to transfer tokens that should be locked or restricted based on certain conditions. This could be exploited by attackers to bypass the intended locking mechanism and transfer tokens prematurely.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    },
    {
        "function_name": "burn",
        "code": "function burn(uint256 amount) external nonReentrant { address sender = _msgSender(); require(sender != address(0), \"ERC20: burn from the zero address\"); require(sender != address(deadAddress), \"ERC20: burn from the burn address\"); uint256 balance = balanceOf(sender); require(balance >= amount, \"ERC20: burn amount exceeds balance\"); uint256 reflectedAmount = amount.mul(_getCurrentRate()); _reflectedBalances[sender] = _reflectedBalances[sender].sub(reflectedAmount); if (_isExcludedFromRewards[sender]) _balances[sender] = _balances[sender].sub(amount); _burnTokens( sender, amount, reflectedAmount ); }",
        "vulnerability": "Potential loss of funds",
        "reason": "The burn function allows any user to burn their own tokens. While this might seem harmless, users might unintentionally burn their tokens due to a misunderstanding of the function's purpose, resulting in an irreversible loss of funds. Furthermore, if any external call is added later within this function, it might lead to reentrancy issues as it manipulates balances.",
        "file_name": "0x052f4e43d9d65ca35ce6d3438aa956fda91ef520.sol"
    }
]