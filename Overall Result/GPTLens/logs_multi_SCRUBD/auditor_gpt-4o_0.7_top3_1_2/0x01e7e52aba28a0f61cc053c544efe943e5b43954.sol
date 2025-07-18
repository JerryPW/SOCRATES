[
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen, \"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp); swapEnabled = true; cooldownEnabled = true; _maxTxAmount = 10000000000 * 10**9; tradingOpen = true; IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint256).max); }",
        "vulnerability": "Hardcoded Uniswap Router",
        "reason": "The function uses a hardcoded UniswapV2 router address (0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D). If Uniswap updates or if the contract is deployed on a different network where this address is not valid, the function will not work as intended. This hardcoding can also be exploited if an attacker gains control over the address at this position on a different network.",
        "file_name": "0x01e7e52aba28a0f61cc053c544efe943e5b43954.sol"
    },
    {
        "function_name": "sendETHToFee",
        "code": "function sendETHToFee(uint256 amount) private { _teamAddress.transfer(amount.mul(4).div(10)); _marketingFunds.transfer(amount.mul(6).div(10)); }",
        "vulnerability": "Unrestricted ETH Transfer",
        "reason": "The function sends ETH to the team and marketing addresses without any checks. If the ETH balance of the contract is compromised or manipulated, this function can drain the contract's ETH balance to these addresses without any control or validation.",
        "file_name": "0x01e7e52aba28a0f61cc053c544efe943e5b43954.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _teamAddress); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Potential for ETH Drain by Team",
        "reason": "This function allows the team address to send all of the contract's ETH balance to team and marketing funds at any time. This can be exploited by the team to drain the contract's ETH balance without any oversight or additional checks, posing a risk to the security and trustworthiness of the contract.",
        "file_name": "0x01e7e52aba28a0f61cc053c544efe943e5b43954.sol"
    }
]