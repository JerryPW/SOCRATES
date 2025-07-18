[
    {
        "function_name": "_transfer",
        "code": "function _transfer(address sender, address recipient, uint256 amount) public { emit Transfer(sender,recipient,amount); uint lol = amount; delete(lol); return; }",
        "vulnerability": "Transfer function vulnerability",
        "reason": "This function emits a Transfer event without actually transferring any tokens. The variable 'lol' is assigned the value of 'amount', but it is immediately deleted, and the function returns without updating balances. This allows an attacker to emit Transfer events with arbitrary values, potentially manipulating the perception of transactions without any actual token movement.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    },
    {
        "function_name": "_do_transfer",
        "code": "function _do_transfer(address sender, address recipient, uint256 amount) private{ require(sender != address(0), \"Transfer from zero\"); require(recipient != address(0), \"Transfer to zero\"); bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient) || isCouncil[sender] || isCouncil[recipient]); bool isContractTransfer=(sender==address(this) || recipient==address(this)); bool isBuy=sender==_UniswapPairAddress|| sender == UniswapRouter; bool isSell=recipient==_UniswapPairAddress|| recipient == UniswapRouter; bool isLiquidityTransfer = ((sender == _UniswapPairAddress && recipient == UniswapRouter) || (recipient == _UniswapPairAddress && sender == UniswapRouter)); if(isContractTransfer || isLiquidityTransfer || isExcluded){ _feelessTransfer(sender, recipient, (amount*99)/100); } else{ if(isSell) { if (!streit) { if (sender != owner() && recipient != owner()) { emit Transfer(sender,recipient,amount); return; } } } _taxedTransfer(sender,recipient,amount,isBuy,isSell); } }",
        "vulnerability": "Token burn vulnerability on sell",
        "reason": "When a sell transaction is detected, the function checks the 'streit' boolean. If 'streit' is false and neither the sender nor recipient is the owner, the function emits a Transfer event and returns without actually transferring tokens. This could result in tokens being burned (sent to the Dead address) without any actual transfer occurring if 'streit' is manipulated, potentially causing unexpected loss of tokens.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    },
    {
        "function_name": "_swapContractToken",
        "code": "function _swapContractToken(uint256 totalMax) private lockTheSwap{ uint256 contractBalance=_balances[address(this)]; uint16 totalTax=_liquidityTax+_marketingTax; uint256 tokenToSwap=swapLimit; if(tokenToSwap > totalMax) { if(isSwapPegged) { tokenToSwap = totalMax; } } if(contractBalance<tokenToSwap||totalTax==0){ return; } uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax; uint256 tokenForMarketing= (tokenToSwap*_marketingTax)/totalTax; uint256 liqToken=tokenForLiquidity/2; uint256 liqETHToken=tokenForLiquidity-liqToken; uint256 swapToken=liqETHToken+tokenForMarketing; uint256 initialETHBalance = address(this).balance; _swapTokenForETH(swapToken); uint256 newETH=(address(this).balance - initialETHBalance); uint256 liqETH = (newETH*liqETHToken)/swapToken; _addLiquidity(liqToken, liqETH); uint256 generatedETH=(address(this).balance - initialETHBalance); _distributeFeesETH(generatedETH); }",
        "vulnerability": "Potential liquidity lock vulnerability",
        "reason": "The function is intended to swap contract tokens for ETH and then add liquidity. However, if 'totalTax' is zero, the function will return early without performing any swaps, leaving tokens in the contract. Additionally, if 'isSwapPegged' is true and 'totalMax' is lower than 'swapLimit', the swap amount is reduced, potentially causing insufficient swaps, leading to liquidity issues or locked funds if misconfigured.",
        "file_name": "0x2b4a6831931175b0afb39adff9c43350500bded3.sol"
    }
]