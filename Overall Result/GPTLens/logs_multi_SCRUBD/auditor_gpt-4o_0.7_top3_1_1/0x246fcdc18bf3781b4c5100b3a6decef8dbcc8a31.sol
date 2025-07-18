[
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address token) external onlyOwner { require(token != address(this), \"Owner cannot claim native tokens\"); if (token == address(0x0)) { payable(msg.sender).sendValue(address(this).balance); return; } IERC20 ERC20token = IERC20(token); uint256 balance = ERC20token.balanceOf(address(this)); ERC20token.transfer(msg.sender, balance); }",
        "vulnerability": "Owner can drain contract balance",
        "reason": "The function allows the owner to withdraw any ERC20 tokens or ETH from the contract balance. This means that if any tokens are sent to the contract accidentally or as part of its operations, the owner can transfer them to their own wallet. This can be exploited by a malicious owner to drain the contract's funds, posing a risk to users who expect their tokens to be safe in the contract.",
        "file_name": "0x246fcdc18bf3781b4c5100b3a6decef8dbcc8a31.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) { require(tradingEnabled, \"Trading is not enabled yet\"); } uint256 contractTokenBalance = balanceOf(address(this)); bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount; if ( overMinTokenBalance && !inSwapAndLiquify && to == uniswapV2Pair && swapEnabled ) { inSwapAndLiquify = true; uint256 initialBalance = address(this).balance; address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( contractTokenBalance, 0, path, address(this), block.timestamp); uint256 newBalance = address(this).balance - initialBalance; uint256 marketingShare = marketingFeeonBuy + marketingFeeonSell; uint256 buybackShare = buybackBurnFeeOnBuy + buybackBurnFeeOnSell; uint256 totalShare = marketingShare + buybackShare; if(totalShare > 0) { if(buybackShare > 0) { uint256 buybackBNB = (newBalance * buybackShare) / totalShare; buybackAndBurn(buybackBNB); } if(marketingShare > 0) { uint256 marketingAmount = address(this).balance - initialBalance; payable(marketingWallet).sendValue(marketingAmount); } } inSwapAndLiquify = false; } _tokenTransfer(from,to,amount); }",
        "vulnerability": "Potential reentrancy in swap logic",
        "reason": "The function performs a swap operation and then sends ETH to the marketing wallet within the same transaction. This logic, combined with the use of low-level call 'sendValue', could potentially introduce reentrancy issues if the marketing wallet is a contract that can reenter the swap logic. Although the function sets 'inSwapAndLiquify' to true to prevent reentrancy, the use of sendValue instead of a safe call like 'transfer' still poses a risk in certain edge cases where gas stipends are manipulated.",
        "file_name": "0x246fcdc18bf3781b4c5100b3a6decef8dbcc8a31.sol"
    },
    {
        "function_name": "enableWalletToWalletTransferWithoutFee",
        "code": "function enableWalletToWalletTransferWithoutFee(bool enable) external onlyOwner { require(walletToWalletTransferWithoutFee != enable, \"Wallet to wallet transfer without fee is already set to that value\"); walletToWalletTransferWithoutFee = enable; emit WalletToWalletTransferWithoutFeeEnabled(enable); }",
        "vulnerability": "Potential bypass of fee mechanism",
        "reason": "This function allows the owner to toggle the walletToWalletTransferWithoutFee setting. If enabled, it allows wallet-to-wallet transfers without incurring any fees. This could be exploited by the owner or others through strategic transfers to minimize or entirely avoid paying transaction fees, which could be against the expectations of other token holders who are subject to these fees.",
        "file_name": "0x246fcdc18bf3781b4c5100b3a6decef8dbcc8a31.sol"
    }
]