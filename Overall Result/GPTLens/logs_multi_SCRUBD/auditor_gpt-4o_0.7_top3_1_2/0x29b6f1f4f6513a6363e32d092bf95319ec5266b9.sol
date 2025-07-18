[
    {
        "function_name": "setMarketingWallet",
        "code": "function setMarketingWallet(address _address) public { require(msg.sender == marketingWallet, 'only accept by marketing wallet'); marketingWallet = _address; emit NewMarketingWallet(_address); }",
        "vulnerability": "Unauthorized access to change marketing wallet",
        "reason": "The setMarketingWallet function allows the current marketing wallet address to change the marketing wallet to any address without any restrictions or multi-signature checks. If an attacker gains control of the marketing wallet private key, they can redirect funds by changing the marketing wallet address to one they control.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    },
    {
        "function_name": "setTreasury",
        "code": "function setTreasury(address _treasury) external onlyOwner { require(_treasury != address(treasury), 'Treasury is already set to that address'); require(_treasury != address(0), 'Treasury can not be the zero address'); treasury = Treasury(_treasury); _isExcludedFromFees[_treasury] = true; emit TreasuryChanged(_treasury); }",
        "vulnerability": "Treasury contract replacement",
        "reason": "The setTreasury function allows the owner to change the treasury contract address. If the owner is compromised or malicious, they can set the treasury to a contract they control, enabling them to redirect and potentially steal funds intended for the treasury.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify(uint256 tokens) private { uint256 half = tokens / 2; uint256 otherHalf = tokens - half; uint256 initialBalance = address(this).balance; address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( half, 0, path, address(this), block.timestamp ); uint256 newBalance = address(this).balance - initialBalance; uniswapV2Router.addLiquidityETH{ value: newBalance }(address(this), otherHalf, 0, 0, owner(), block.timestamp); emit SwapAndLiquify(half, newBalance, otherHalf); }",
        "vulnerability": "Reentrancy risk during swap and liquidity add",
        "reason": "The swapAndLiquify function involves external calls to the Uniswap V2 router, which can be potentially reentrant. If an attacker exploits reentrancy in the swapExactTokensForETHSupportingFeeOnTransferTokens or addLiquidityETH function, they might manipulate the contract state in unexpected ways, potentially leading to the loss or theft of funds.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    }
]