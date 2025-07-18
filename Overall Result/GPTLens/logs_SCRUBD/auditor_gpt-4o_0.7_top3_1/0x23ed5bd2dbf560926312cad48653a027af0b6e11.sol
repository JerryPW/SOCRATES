[
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Improper handling of received tokens",
        "reason": "The function 'buyNBurn' swaps ETH for YELD tokens but sends them to the zero address (address(0)). This results in tokens being sent to the zero address, effectively burning them, rather than utilizing them in a beneficial way for the contract or its stakeholders. This can result in a loss of tokens that could otherwise be used for beneficial purposes.",
        "file_name": "0x23ed5bd2dbf560926312cad48653a027af0b6e11.sol"
    },
    {
        "function_name": "usdcToETH",
        "code": "function usdcToETH(uint256 _amount) internal returns(uint256) { IERC20(usdc).safeApprove(uniswapRouter, 0); IERC20(usdc).safeApprove(uniswapRouter, _amount); address[] memory path = new address[](2); path[0] = usdc; path[1] = weth; uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Potential frontrunning risk due to slippage",
        "reason": "The function 'usdcToETH' allows swapping USDC for ETH on Uniswap with an amountOutMin of zero, which makes it susceptible to frontrunning attacks. An attacker can monitor the transaction, place a large order to change the price just before the swap, and then profit from the new price, leading to less ETH being received than expected.",
        "file_name": "0x23ed5bd2dbf560926312cad48653a027af0b6e11.sol"
    },
    {
        "function_name": "extractTokensIfStuck",
        "code": "function extractTokensIfStuck(address _token, uint256 _amount) public onlyOwner { IERC20(_token).transfer(msg.sender, _amount); }",
        "vulnerability": "Lack of validation for token extraction",
        "reason": "The function 'extractTokensIfStuck' allows the contract owner to transfer any tokens from the contract to their own address without any validation or restriction. This can be abused by the owner to drain any tokens held by the contract, which might be intended for other purposes or stakeholders.",
        "file_name": "0x23ed5bd2dbf560926312cad48653a027af0b6e11.sol"
    }
]