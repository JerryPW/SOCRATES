[
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { bool success; (success,) = address(owner()).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function allows transferring all ETH balance to the owner's address without using a reentrancy guard. This could potentially be exploited if the owner's address is a contract with a fallback function that interacts with this contract, enabling a reentrancy attack.",
        "file_name": "0x00b25822e3b8f8720b327f2df8e7c6f96271c8dc.sol"
    },
    {
        "function_name": "withdrawStuckTokens",
        "code": "function withdrawStuckTokens() external onlyOwner { ContractTransfer(address(this), owner(), balanceOf(address(this))); }",
        "vulnerability": "Token theft by owner",
        "reason": "This function allows the owner to withdraw all tokens from the contract to their address without restriction. If the owner is compromised or malicious, they can steal all tokens, negatively impacting token holders.",
        "file_name": "0x00b25822e3b8f8720b327f2df8e7c6f96271c8dc.sol"
    },
    {
        "function_name": "OpenMarket",
        "code": "function OpenMarket() external onlyOwner returns (bool){ require(!active, \"ERC20: Trades already active!\"); LiveBlock = block.number; EndSniperPen = block.timestamp.add(7 days); IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniV2Router = _uniV2Router; _MaxExclude[address(uniV2Router)] = true; ContractApprove(address(this), address(uniV2Router), _Supply); uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).createPair(address(this), _uniV2Router.WETH()); _MaxExclude[address(uniV2Pair)] = true; require(address(this).balance > 0, \"ERC20: Must have ETH on contract to Go active!\"); addLiquidity(balanceOf(address(this)), address(this).balance); setLiquidityAddress(DEAD); maxWalletOn = true; sals = true; actions = true; active = true; return true; }",
        "vulnerability": "Potential frontrunning attack during market opening",
        "reason": "The function enables market trading and adds liquidity to a Uniswap pair. If the function is called without precautions, such as enabling trading before liquidity is added, it creates a window for frontrunning attacks where attackers could exploit the difference in timing to their advantage.",
        "file_name": "0x00b25822e3b8f8720b327f2df8e7c6f96271c8dc.sol"
    }
]