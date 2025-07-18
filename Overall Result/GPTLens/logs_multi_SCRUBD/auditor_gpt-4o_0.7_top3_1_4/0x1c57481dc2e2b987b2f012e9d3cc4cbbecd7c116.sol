[
    {
        "function_name": "tusdToETH",
        "code": "function tusdToETH(uint256 _amount) internal returns(uint256) {\n    IERC20(tusd).safeApprove(uniswapRouter, 0);\n    IERC20(tusd).safeApprove(uniswapRouter, _amount);\n    address[] memory path = new address[](2);\n    path[0] = tusd;\n    path[1] = weth;\n    uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800));\n    return amounts[1];\n}",
        "vulnerability": "Uniswap slippage vulnerability",
        "reason": "The function sets the amountOutMin parameter to 0 when calling swapExactTokensForETH on Uniswap. This means there is no minimum amount of ETH that is expected in return for the tokens, allowing potential front-running attacks and significant slippage. An attacker can exploit this by manipulating the price during the transaction confirmation, resulting in a poor exchange rate and loss of funds.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    },
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) {\n    address[] memory path = new address[](2);\n    path[0] = weth;\n    path[1] = address(yeldToken);\n    uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800));\n    return amounts[1];\n}",
        "vulnerability": "Uniswap slippage vulnerability",
        "reason": "Similar to the tusdToETH function, the buyNBurn function sets the amountOutMin parameter to 0 when calling swapExactETHForTokens on Uniswap. This allows for front-running attacks where attackers can manipulate the price and profit from the swap, resulting in significant slippage and potential loss of funds.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    },
    {
        "function_name": "extractTokensIfStuck",
        "code": "function extractTokensIfStuck(address _token, uint256 _amount) public onlyOwner {\n    IERC20(_token).transfer(msg.sender, _amount);\n}",
        "vulnerability": "Potential misuse by owner",
        "reason": "This function allows the contract owner to extract any ERC20 tokens held by the contract without any restrictions on the amount or token type. This can be exploited by a malicious owner to drain tokens from the contract, potentially leading to loss of funds for users who have deposited their tokens in the contract.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    }
]