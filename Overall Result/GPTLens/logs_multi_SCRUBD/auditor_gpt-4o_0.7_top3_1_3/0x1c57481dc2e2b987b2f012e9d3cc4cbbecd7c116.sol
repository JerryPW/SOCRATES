[
    {
        "function_name": "extractTokensIfStuck",
        "code": "function extractTokensIfStuck(address _token, uint256 _amount) public onlyOwner { IERC20(_token).transfer(msg.sender, _amount); }",
        "vulnerability": "Token extraction by owner",
        "reason": "This function allows the contract owner to extract any amount of tokens from the contract without any restriction. This could be exploited by a malicious owner to drain the contract's token balance, leading to loss for other users who rely on the contract to hold their tokens securely.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    },
    {
        "function_name": "extractETHIfStuck",
        "code": "function extractETHIfStuck() public onlyOwner { owner().transfer(address(this).balance); }",
        "vulnerability": "ETH extraction by owner",
        "reason": "This function permits the contract owner to transfer all Ether held by the contract to the owner's address. This could be exploited by a malicious owner to drain all Ether from the contract, potentially affecting users who have deposited Ether or are owed Ether by the contract.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    },
    {
        "function_name": "buyNBurn",
        "code": "function buyNBurn(uint256 _ethToSwap) internal returns(uint256) { address[] memory path = new address[](2); path[0] = weth; path[1] = address(yeldToken); uint[] memory amounts = IUniswap(uniswapRouter).swapExactETHForTokens.value(_ethToSwap)(uint(0), path, address(0), now.add(1800)); return amounts[1]; }",
        "vulnerability": "Potential loss of funds in Uniswap swap",
        "reason": "This function performs a swap on Uniswap with a potential issue in specifying the recipient address as the zero address. This could result in the loss of tokens meant to be received from the swap, as they would be sent to the zero address, effectively burning them. This could lead to unexpected loss of funds when the contract attempts to burn tokens using the swapped ETH.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    }
]