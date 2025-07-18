[
    {
        "function_name": "setMarketingAddress",
        "code": "function setMarketingAddress(address payable wallet) external onlyOwner { marketingaddress = wallet; }",
        "vulnerability": "Potential misuse by owner",
        "reason": "The function allows the contract owner to change the marketing address at any time. This could be misused to redirect marketing funds to an address controlled by a malicious actor, leading to loss of funds intended for marketing purposes.",
        "file_name": "0x05b902c7fd6d221d582bb973fe6e253921568717.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint amount) internal{ require(sender != address(0), \"ERC20: transfer from the zero address\"); require(recipient != address(0), \"ERC20: transfer to the zero address\"); if(sender != owner() && recipient != owner()) { require(amount <= maxTxAmount, \"Transaction size limit reached\"); } uint256 contractTokenBalance = balanceOf(address(this)); bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity; if ( overMinTokenBalance && !swapping && sender != uniswapV2Pair && swapAndLiquifyEnabled ) { swapping = true; uint256 walletTokens = contractTokenBalance.mul(SELLmarketingFee).div(SELLtotalFee); uint256 contractBalance = address(this).balance; swapTokensForEth(walletTokens); uint256 newBalance = address(this).balance.sub(contractBalance); uint256 marketingShare = newBalance.mul(SELLmarketingFee).div((SELLmarketingFee)); payable(marketingaddress).transfer(marketingShare); uint256 swapTokens = contractTokenBalance.mul(SELLliquidityFee).div(SELLtotalFee); swapAndLiquify(swapTokens); swapping = false; } bool takeFee = !swapping; if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){ takeFee = false; } if(sender != uniswapV2Pair && recipient != uniswapV2Pair) { takeFee = false; } if(takeFee){ if(sender == uniswapV2Pair) { marketingFee = BUYmarketingFee; liquidityFee = BUYliquidityFee; burnFee = BUYburnFee; totalFee = BUYtotalFee; } if(recipient == uniswapV2Pair) { marketingFee = SELLmarketingFee; liquidityFee = SELLliquidityFee; burnFee = SELLburnFee; totalFee = SELLtotalFee; } } if(takeFee) { uint256 taxAmount = amount.mul(totalFee).div(100); uint256 burnAmount = taxAmount.mul(burnFee).div(totalFee); uint256 TotalSent = amount.sub(taxAmount); _balances[sender] = _balances[sender].sub(amount, \"ERC20: transfer amount exceeds balance\"); _balances[recipient] = _balances[recipient].add(TotalSent); _balances[address(this)] = _balances[address(this)].add(taxAmount); _balances[address(0)] = _balances[address(0)].add(burnAmount); emit Transfer(sender, recipient, TotalSent); emit Transfer(sender, address(this), taxAmount); emit Transfer(sender, address(0), burnAmount); } else { _balances[sender] = _balances[sender].sub(amount, \"ERC20: transfer amount exceeds balance\"); _balances[recipient] = _balances[recipient].add(amount); emit Transfer(sender, recipient, amount); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `swapTokensForEth` is called within `_transfer` which involves external calls. Although the `lockTheSwap` modifier is present in `swapAndLiquify`, the `_transfer` function itself does not prevent reentrancy attacks before the swap occurs, potentially allowing an attacker to exploit this vulnerability to manipulate token balances.",
        "file_name": "0x05b902c7fd6d221d582bb973fe6e253921568717.sol"
    },
    {
        "function_name": "withdrawStuckETh",
        "code": "function withdrawStuckETh() external onlyOwner{ require (address(this).balance > 0, \"Can't withdraw negative or zero\"); payable(owner()).transfer(address(this).balance); }",
        "vulnerability": "Complete balance withdrawal by owner",
        "reason": "This function allows the contract owner to withdraw the entire Ether balance of the contract. If the owner account is compromised, an attacker could drain all Ether, leading to loss of funds. Additionally, there\u2019s no restriction on how often this function can be called.",
        "file_name": "0x05b902c7fd6d221d582bb973fe6e253921568717.sol"
    }
]