[
    {
        "function_name": "removeLimits",
        "code": "function removeLimits() external onlyOwner { txLimitsRemoved = true; maxTxAmount = _tTotal; maxWalletSize = _tTotal; emit ConfigurationChange(\"LimitsRemoved\"); }",
        "vulnerability": "Owner can remove transaction and wallet limits",
        "reason": "The owner can call the `removeLimits` function to remove transaction and wallet size limits. This can allow the owner to perform large transactions or consolidate a large number of tokens into one wallet, potentially manipulating market conditions or liquidity.",
        "file_name": "0x2fd4f0569896b4009ffad793ac6308bfd79b4c35.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address from, address to, uint256 amount) private { require(from != address(0) && from != address(DEAD), \"ERC20: transfer from invalid\"); require(to != address(0), \"ERC20: transfer to the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); if (from == launchContract) { boughtAtLaunch[to] = true; } uint256 taxAmount = 0; hasSold[from] = true; uint256 _collectedTaxThreshold = collectedTaxThreshold; if (!isExcludedFromFee[from] && !isExcludedFromFee[to]) { require(tradingOpen, \"Trading is not open yet\"); bool isTransfer = from != uniswapV2Pair && to != uniswapV2Pair; if(!inInternalSwap && !isTransfer){ taxAmount = amount.mul(feePercentage).div(100); } if (from == uniswapV2Pair && to != address(uniswapV2Router)) { require(amount <= maxTxAmount, \"Exceeds the _maxTxAmount.\"); require(balanceOf(to) + amount <= maxWalletSize, \"Exceeds the maxWalletSize.\"); } uint256 contractTokenBalance = balanceOf(address(this)); if (!inInternalSwap && from != uniswapV2Pair && autoTaxDistributionEnabled && contractTokenBalance > _collectedTaxThreshold) { _distributeTaxes(_collectedTaxThreshold); } } _balances[from]=_balances[from].sub(amount); _balances[to]=_balances[to].add(amount.sub(taxAmount)); emit Transfer(from, to, amount.sub(taxAmount)); if(taxAmount > 0){ _balances[address(this)]=_balances[address(this)].add(taxAmount); emit Transfer(from, address(this),taxAmount); } }",
        "vulnerability": "Potential for tax evasion",
        "reason": "The `_transfer` function allows certain addresses to be excluded from fees, which can be set by the owner. This creates a risk that the owner could exclude their own addresses or those of accomplices to avoid paying transaction fees, leading to potential loss of revenue or imbalance in tokenomics.",
        "file_name": "0x2fd4f0569896b4009ffad793ac6308bfd79b4c35.sol"
    },
    {
        "function_name": "withdrawERC20",
        "code": "function withdrawERC20(IERC20 token) external onlyOwner { uint256 balance = token.balanceOf(address(this)); bool sent = token.transfer(msg.sender, balance); require(sent, \"Failed to send token\"); }",
        "vulnerability": "Owner can withdraw any ERC20 tokens",
        "reason": "The `withdrawERC20` function allows the contract owner to withdraw any ERC20 tokens that might be accidentally or intentionally sent to the contract. This can lead to a situation where users\u2019 tokens are taken by the owner without their consent.",
        "file_name": "0x2fd4f0569896b4009ffad793ac6308bfd79b4c35.sol"
    }
]