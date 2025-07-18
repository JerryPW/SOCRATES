[
    {
        "function_name": "withdrawToken",
        "code": "function withdrawToken(address _tokenContract) external onlyOwner { IERC20 tokenContract = IERC20(_tokenContract); tokenContract.transfer(marketingAddress, balanceOf(address(tokenContract))); }",
        "vulnerability": "No check on transfer success",
        "reason": "The function `withdrawToken` transfers tokens to the marketing address without checking if the transfer was successful. This can lead to loss of tokens if the transfer fails for any reason, such as insufficient token balance or transfer restrictions on the token contract.",
        "file_name": "0x39832e9b4851c76160d754267d4a169617c27d88.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() private lockTheSwap { uint256 contractBalance = balanceOf(address(this)); uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_teamTokensToSwap).add(_marketingTokensToSwap); uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2); uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity); uint256 initialETHBalance = address(this).balance; swapTokensForETH(amountToSwapForETH); uint256 ethBalance = address(this).balance.sub(initialETHBalance); uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap); uint256 ethForTeam = ethBalance.mul(_teamTokensToSwap).div(totalTokensToSwap); uint256 ethForLiquidity = ethBalance.sub(ethForMarketing).sub(ethForTeam); _liquidityTokensToSwap = 0; _marketingTokensToSwap = 0; _teamTokensToSwap = 0; (bool success,) = address(teamAddress).call{value: ethForTeam}(\"\"); (success,) = address(marketingAddress).call{value: ethForMarketing}(\"\"); addLiquidity(tokensForLiquidity, ethForLiquidity); emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity); if(address(this).balance > 1e17){ (success,) = address(marketingAddress).call{value: address(this).balance}(\"\"); } }",
        "vulnerability": "Reentrancy risk during swap",
        "reason": "The `swapBack` function transfers ETH to external addresses using low-level calls without proper checks. This can potentially lead to reentrancy attacks where the called contract could execute code before the state updates, allowing attackers to manipulate balances during the swap process.",
        "file_name": "0x39832e9b4851c76160d754267d4a169617c27d88.sol"
    },
    {
        "function_name": "transferForeignToken",
        "code": "function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) { require(_token != address(0), \"_token address cannot be 0\"); require(_token != address(this), \"Can't withdraw native tokens\"); uint256 _contractBalance = IERC20(_token).balanceOf(address(this)); _sent = IERC20(_token).transfer(_to, _contractBalance); emit TransferForeignToken(_token, _contractBalance); }",
        "vulnerability": "No check on transfer success",
        "reason": "Similar to the `withdrawToken` function, `transferForeignToken` also lacks a check to ensure that the token transfer was successful. This could result in incorrect assumptions about the transfer status and potential token loss.",
        "file_name": "0x39832e9b4851c76160d754267d4a169617c27d88.sol"
    }
]