[
    {
        "function_name": "removeBuyFee",
        "code": "function removeBuyFee(uint256 _liqFee, uint256 _devFee) public onlyOwner { require(_liqFee.add(_devFee) <= 5, \"tax too high\"); liquidityBuyFee = _liqFee; devBuyFee = _devFee; }",
        "vulnerability": "Potential fee manipulation by owner",
        "reason": "The `removeBuyFee` function allows the owner to set the liquidity and development buy fees, but it only restricts the sum of these fees to be less than or equal to 5%. This means the owner can set any combination of fees within this limit, potentially allowing them to manipulate the token's buy fee structure to their advantage or to the detriment of users.",
        "file_name": "0x039f7a065382b064c95f8409b7eff4a45cea3e23.sol"
    },
    {
        "function_name": "removeSellFee",
        "code": "function removeSellFee(uint256 _devFee, uint256 _burnFee) public onlyOwner { require(_devFee.add(_burnFee) <= 5, \"tax too high\"); devSellFee = _devFee; burnSellFee = _burnFee; }",
        "vulnerability": "Potential fee manipulation by owner",
        "reason": "The `removeSellFee` function allows the owner to set the development and burn sell fees while only ensuring that their sum is less than or equal to 5%. This flexibility can be exploited by the owner to change the sell fee structure in ways that might not align with the expectations of token holders, which could lead to unexpected economic impacts on the token's trading.",
        "file_name": "0x039f7a065382b064c95f8409b7eff4a45cea3e23.sol"
    },
    {
        "function_name": "swapTokensForEth",
        "code": "function swapTokensForEth(uint256 tokenAmount, address _to) private { address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) { _approve(address(this), address(uniswapV2Router), ~uint256(0)); } uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, _to, block.timestamp ); }",
        "vulnerability": "Infinite allowance approval",
        "reason": "In the `swapTokensForEth` function, the contract approves an infinite allowance for the Uniswap V2 Router if the current allowance is less than the token amount. This could lead to potential security risks if the Uniswap V2 Router's contract is compromised, as it would have unlimited access to the contract's tokens.",
        "file_name": "0x039f7a065382b064c95f8409b7eff4a45cea3e23.sol"
    }
]