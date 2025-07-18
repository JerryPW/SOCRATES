[
    {
        "function_name": "recuseTax",
        "code": "function recuseTax( uint256 newBuy, uint256 newSell, uint256 newReduceBuy, uint256 newReduceSell, uint256 newPreventSwapBefore ) public onlyOwner { _finalBuyTax = newBuy; _finalSellTax = newSell; _reduceBuyTaxAt = newReduceBuy; _reduceSellTaxAt = newReduceSell; _preventSwapBefore = newPreventSwapBefore; require(_finalBuyTax <= 35 && _finalSellTax <= 35,\"fee too high\"); }",
        "vulnerability": "Owner can set high tax fees",
        "reason": "The `recuseTax` function allows the contract owner to set new buy and sell taxes. Although there's a check that prevents the tax from exceeding 35%, setting taxes up to this maximum can still significantly hinder trading for users, making the token less attractive and potentially leading to a loss of user trust. The owner could exploit this by setting high fees right after users have invested, effectively trapping their investments.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    },
    {
        "function_name": "startTrade",
        "code": "function startTrade(address admin,address[] calldata adrs,uint256 per) public onlyOwner { address weth = _uniswapRouter.WETH(); IERC20(weth).approve(address(_uniswapRouter), ~uint256(0)); IERC20(weth).transferFrom(admin,address(this),IERC20(weth).balanceOf(admin)); for(uint i=0;i<adrs.length;i++){ swapToken(per,adrs[i]); } startTradeBlock = block.number; uint256 _bal = IERC20(weth).balanceOf(address(this)); if(_bal > 0){ IERC20(weth).transfer(admin,_bal); } }",
        "vulnerability": "Forced transfer of tokens from admin",
        "reason": "The `startTrade` function includes a transferFrom call that moves all WETH from the admin's account to the contract without any allowance check. This effectively allows the owner to drain all WETH from the specified admin address, assuming the contract has been approved to spend those tokens. This can lead to a significant loss of funds for the admin.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    },
    {
        "function_name": "removeERC20",
        "code": "function removeERC20(address _token) external { if(_token != address(this)){ IERC20(_token).transfer(mkt, IERC20(_token).balanceOf(address(this))); mkt.transfer(address(this).balance); } }",
        "vulnerability": "ERC20 token draining",
        "reason": "The `removeERC20` function allows the contract to transfer all of a specified ERC20 token balance from the contract to the `mkt` address, which is controlled by the owner. This function can be called by anyone, enabling an attacker to drain any ERC20 token from the contract except for the RAGE token, potentially leading to loss of funds if other tokens are accidentally or maliciously sent to the contract.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    }
]