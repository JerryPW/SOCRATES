[
    {
        "function_name": "daiToETH",
        "code": "function daiToETH(uint256 _amount) internal returns(uint256) { IERC20(dai).safeApprove(uniswapRouter, 0); IERC20(dai).safeApprove(uniswapRouter, _amount); address[] memory path = new address[](2); path[0] = dai; path[1] = weth; uint[] memory amounts = IUniswap(uniswapRouter).swapExactTokensForETH(_amount, uint(0), path, address(this), now.add(1800)); return amounts[1]; }",
        "vulnerability": "incorrect_minimum_output_value",
        "reason": "The function sets the minimum output amount to 0 for the Uniswap swap, which can lead to significant slippage or loss if the market price changes unfavorably during the transaction.",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    },
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "vulnerability": "incorrect_minimum_output_value",
        "reason": "Similar to the daiToETH function, this function also sets the minimum output amount to 0 when swapping ETH for tokens on Uniswap, potentially leading to significant slippage and poor execution price.",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    },
    {
        "function_name": "extractTokensIfStuck",
        "code": "function extractTokensIfStuck(address _token, uint256 _amount) public onlyOwner { IERC20(_token).transfer(msg.sender, _amount); }",
        "vulnerability": "lack_of_input_validation",
        "reason": "This function allows the contract owner to extract tokens from the contract without any validation on the amount or token address. An owner could mistakenly or maliciously transfer a large amount of tokens, bypassing any safety checks.",
        "file_name": "0x1c3f78372a8c3e01970b85e1b26b885803011da3.sol"
    }
]