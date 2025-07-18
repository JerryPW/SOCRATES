[
    {
        "function_name": "setTaxFees",
        "code": "function setTaxFees(uint256 buyFee, uint256 sellFee) external onlyOwner { taxFees.buyFee = buyFee; taxFees.sellFee = sellFee; }",
        "vulnerability": "Unrestricted fee setting",
        "reason": "The function setTaxFees allows the contract owner to set buy and sell fees to any value, up to 100%. This can be exploited by the owner to set exorbitant fees, effectively preventing token transfers or draining a significant portion of tokens during transfers.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); _approve(address(this), address(uniswapV2Router), _totalSupply); uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max); }",
        "vulnerability": "Liquidity manipulation",
        "reason": "The function openTrading allows the contract owner to open trading and add liquidity at their discretion. The owner could manipulate the liquidity pool in a way that benefits them at the expense of other token holders, such as by adding liquidity with unfavorable conditions or withdrawing liquidity suddenly.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    },
    {
        "function_name": "sendEth",
        "code": "function sendEth() external { uint256 ethBalance = address(this).balance; payable(devAddress).transfer(ethBalance); }",
        "vulnerability": "Unrestricted ETH withdrawal",
        "reason": "The function sendEth allows any caller to trigger the transfer of the contract's entire ETH balance to the developer address. This can be exploited by anyone to drain the ETH balance from the contract to the developer address without restrictions.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    }
]