[
    {
        "function_name": "removeERC20",
        "code": "function removeERC20(address _token) external { if(_token != address(this)){ IERC20(_token).transfer(mkt, IERC20(_token).balanceOf(address(this))); mkt.transfer(address(this).balance); } }",
        "vulnerability": "Unauthorized Token Withdrawal",
        "reason": "The removeERC20 function allows any external caller to transfer any ERC20 tokens held by the contract, except the native token, to the marketing wallet (mkt). The function lacks access control, which could lead to unauthorized token withdrawal by anyone who calls this function. This could be exploited by an attacker to drain all ERC20 tokens from the contract, causing loss to the contract and its stakeholders.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    },
    {
        "function_name": "startTrade",
        "code": "function startTrade(address admin,address[] calldata adrs,uint256 per) public onlyOwner { address weth = _uniswapRouter.WETH(); IERC20(weth).approve(address(_uniswapRouter), ~uint256(0)); IERC20(weth).transferFrom(admin,address(this),IERC20(weth).balanceOf(admin)); for(uint i=0;i<adrs.length;i++){ swapToken(per,adrs[i]); } startTradeBlock = block.number; uint256 _bal = IERC20(weth).balanceOf(address(this)); if(_bal > 0){ IERC20(weth).transfer(admin,_bal); } }",
        "vulnerability": "Potential Unauthorized Token Swap and Transfer",
        "reason": "The startTrade function allows the owner to approve and transfer WETH from an arbitrary admin address without verifying the admin's consent. This could lead to unauthorized withdrawal of WETH from the specified admin address. Furthermore, the function uses a loop to swap tokens to a list of addresses, which could be abused to manipulate token distribution. An attacker who gains owner access could exploit this function to perform unauthorized token swaps and transfers, leading to potential financial loss for the admin address.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    },
    {
        "function_name": "swapTokenForETH",
        "code": "function swapTokenForETH(uint256 tokenAmount) private lockTheSwap { address[] memory path = new address[](2); path[0] = address(this); path[1] = _uniswapRouter.WETH(); try _uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ) {} catch {} uint256 _bal = address(this).balance; if (_bal > 0.01 ether){ mkt.transfer(_bal/10); team.transfer(address(this).balance); } }",
        "vulnerability": "Fund Misallocation",
        "reason": "The swapTokenForETH function swaps tokens for ETH and then transfers a portion of the ETH balance to the marketing wallet (mkt) and the remaining balance to the team wallet. There is no proper accounting for fees or distribution logic, which means that the swapped ETH is fully allocated to these wallets without considering any other potential obligations or stakeholders. This could lead to misallocation of funds where an attacker, if able to influence the swap process, might manipulate the flow of ETH to the marketing and team wallets, resulting in undesired fund distribution and potential financial loss for other stakeholders.",
        "file_name": "0x2aeee16d8412beabc5f38a6995ee5e4d32ab7f9d.sol"
    }
]