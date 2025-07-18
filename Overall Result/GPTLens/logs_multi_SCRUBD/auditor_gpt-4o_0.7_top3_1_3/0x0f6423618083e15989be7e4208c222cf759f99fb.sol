[
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) internal override { require(!isBot[from] && !isBot[to]); if (from == uniswapV2Pair && !_isExcludedFromFee[to]) { uint256 incrementCount = (block.timestamp - incrementTime) / (maxBuyIncrementMinutesTimer * 1 minutes); if (incrementCount > 0) { if (maxBuy < _totalSupply) maxBuy += maxBuyIncrementValue * incrementCount; incrementTime = block.timestamp; } require(tradingEnable); if (!_autoBanBots) require(_balances[to] + amount <= maxBuy); if (_autoBanBots) isBot[to] = true; amount = _getFeeBuy(amount); } if (!_inSwap && uniswapV2Pair != address(0) && to == uniswapV2Pair) { amount = _getFeeSell(amount, from); uint256 contractTokenBalance = balanceOf(address(this)); if (contractTokenBalance > 0) { uint256 maxContractBalance = (balanceOf(uniswapV2Pair) * getMaxContractBalancePercent()) / 100; if (contractTokenBalance > maxContractBalance) { uint256 burnCount; unchecked { burnCount = contractTokenBalance - maxContractBalance; } contractTokenBalance = maxContractBalance; _totalSupply -= burnCount; emit Transfer(address(this), address(0), burnCount); } uint256 swapCount = contractTokenBalance; uint256 maxSwapCount = 2 * amount; if (swapCount > maxSwapCount) swapCount = maxSwapCount; swapTokensForEth(swapCount); } } super._transfer(from, to, amount); }",
        "vulnerability": "Automatic Bot Banning",
        "reason": "The function automatically marks addresses that buy tokens from the Uniswap pair as bots if `_autoBanBots` is enabled. This can be exploited by anyone to block legitimate users from trading by simply enabling `_autoBanBots`, thus preventing them from further participating in the token's economy.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) internal override { require(!isBot[from] && !isBot[to]); if (from == uniswapV2Pair && !_isExcludedFromFee[to]) { uint256 incrementCount = (block.timestamp - incrementTime) / (maxBuyIncrementMinutesTimer * 1 minutes); if (incrementCount > 0) { if (maxBuy < _totalSupply) maxBuy += maxBuyIncrementValue * incrementCount; incrementTime = block.timestamp; } require(tradingEnable); if (!_autoBanBots) require(_balances[to] + amount <= maxBuy); if (_autoBanBots) isBot[to] = true; amount = _getFeeBuy(amount); } if (!_inSwap && uniswapV2Pair != address(0) && to == uniswapV2Pair) { amount = _getFeeSell(amount, from); uint256 contractTokenBalance = balanceOf(address(this)); if (contractTokenBalance > 0) { uint256 maxContractBalance = (balanceOf(uniswapV2Pair) * getMaxContractBalancePercent()) / 100; if (contractTokenBalance > maxContractBalance) { uint256 burnCount; unchecked { burnCount = contractTokenBalance - maxContractBalance; } contractTokenBalance = maxContractBalance; _totalSupply -= burnCount; emit Transfer(address(this), address(0), burnCount); } uint256 swapCount = contractTokenBalance; uint256 maxSwapCount = 2 * amount; if (swapCount > maxSwapCount) swapCount = maxSwapCount; swapTokensForEth(swapCount); } } super._transfer(from, to, amount); }",
        "vulnerability": "Lack of Maximum Supply Cap",
        "reason": "There is no mechanism to prevent the '_totalSupply' from being increased indefinitely through 'makeLiquidity' or other means. This can lead to token inflation, reducing the value of tokens held by users. An attacker can repeatedly call functions that affect '_totalSupply' to exploit this vulnerability, devaluing the token and potentially disrupting the market.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() external { _withdraw(address(this).balance); }",
        "vulnerability": "Unrestricted Withdrawals",
        "reason": "The 'withdraw' function allows any user to withdraw the entire balance of the contract to a specific address, as there is no access control modifier like 'onlyOwner'. This enables any attacker to drain all ETH from the contract, leading to a complete loss of funds for the contract.",
        "file_name": "0x0f6423618083e15989be7e4208c222cf759f99fb.sol"
    }
]