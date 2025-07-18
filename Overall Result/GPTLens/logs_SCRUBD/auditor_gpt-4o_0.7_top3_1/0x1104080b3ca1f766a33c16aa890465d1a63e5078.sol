[
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) internal { require(from != address(0), \"ERC20: transfer from the zero address\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); require(amount <= balanceOf(from), \"RedKnightToken: Cannot transfer more than balance\"); bool isBuyFromLp = automatedMarketMakerPairs[from]; bool isSelltoLp = automatedMarketMakerPairs[to]; bool _isInLaunch = this.isInLaunch(); if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) { require(isTradingEnabled, \"RedKnightToken: Trading is currently disabled.\"); require(!_isBlocked[to], \"RedKnightToken: Account is blocked\"); require(!_isBlocked[from], \"RedKnightToken: Account is blocked\"); if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) { require(amount <= maxTxAmount, \"RedKnightToken: Transfer amount exceeds the maxTxAmount.\"); } if (!_isExcludedFromMaxWalletLimit[to]) { require((balanceOf(to) + amount) <= maxWalletAmount, \"RedKnightToken: Expected wallet amount exceeds the maxWalletAmount.\"); } } _adjustTaxes(isBuyFromLp, isSelltoLp, _isInLaunch); bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap; if ( isTradingEnabled && canSwap && !_swapping && _totalFee > 0 && automatedMarketMakerPairs[to] && from != liquidityWallet && to != liquidityWallet && from != devWallet && to != devWallet && from != marketingWallet && to != marketingWallet && from != buyBackWallet && to != buyBackWallet ) { _swapping = true; _swapAndLiquify(); _swapping = false; } bool takeFee = !_swapping && isTradingEnabled; if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){ takeFee = false; } _tokenTransfer(from, to, amount, takeFee); }",
        "vulnerability": "Trading can be paused by owner",
        "reason": "The owner can deactivate trading at any time using deactivateTrading() function, potentially freezing all transfers for users who are not allowed to trade when trading is disabled. This centralization of control could lead to misuse where the owner halts trading for their benefit or as a malicious act.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    },
    {
        "function_name": "claimETHOverflow",
        "code": "function claimETHOverflow() external onlyOwner { require(address(this).balance > 0, \"RedKnightToken: Cannot send more than contract balance\"); uint256 amount = address(this).balance; (bool success,) = address(owner()).call{value : amount}(\"\"); if (success){ emit ClaimETHOverflow(amount); } }",
        "vulnerability": "Owner can drain contract ETH",
        "reason": "This function allows the owner to transfer the entire ETH balance of the contract to their own address. If the contract generates ETH through its operations, for example from swap and liquify, the owner can drain these funds, potentially leaving nothing for token holders.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    },
    {
        "function_name": "blockAccount",
        "code": "function blockAccount(address account) external onlyOwner { uint256 currentTimestamp = _getNow(); require(!_isBlocked[account], \"RedKnightToken: Account is already blocked\"); if (_isLaunched) { require((currentTimestamp - _launchStartTimestamp) < _blockedTimeLimit, \"RedKnightToken: Time to block accounts has expired\"); } _isBlocked[account] = true; emit BlockedAccountChange(account, true); }",
        "vulnerability": "Owner can block accounts",
        "reason": "The owner has the ability to block any account, preventing them from participating in any transfers. This power can be abused, for example, to target specific users for arbitrary reasons, or to sabotage competitors. The block action is only restricted during certain timeframes, which still gives the owner significant control over user accounts.",
        "file_name": "0x1104080b3ca1f766a33c16aa890465d1a63e5078.sol"
    }
]