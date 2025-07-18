[
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen, \"trading is already open\"); IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); uniswapV2Router = _uniswapV2Router; _approve(address(this), address(uniswapV2Router), _tTotal); uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()) .createPair(address(this), _uniswapV2Router.WETH()); uniswapV2Router.addLiquidityETH{value: address(this).balance}( address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp ); swapEnabled = true; _maxTxAmount = 20000000000 * 10**9; launchBlock = block.number; tradingOpen = true; IERC20(uniswapV2Pair).approve( address(uniswapV2Router), type(uint256).max ); }",
        "vulnerability": "Potential frontrunning",
        "reason": "The current implementation of openTrading does not include any mechanism to prevent frontrunning. As soon as trading is opened, malicious actors can potentially take advantage of this by executing trades before others, possibly influencing token prices unfairly.",
        "file_name": "0x0003ed19f80564745e84b4cc411a7b6be4f0cf31.sol"
    },
    {
        "function_name": "setBots",
        "code": "function setBots(address[] memory bots_) public onlyOwner() { for (uint256 i = 0; i < bots_.length; i++) { bots[bots_[i]] = true; } }",
        "vulnerability": "Centralized control of blacklist",
        "reason": "The setBots function allows the contract owner to arbitrarily blacklist addresses, preventing them from trading tokens. This centralized control can be exploited by a malicious owner to restrict legitimate users, leading to potential loss of funds and trust issues.",
        "file_name": "0x0003ed19f80564745e84b4cc411a7b6be4f0cf31.sol"
    },
    {
        "function_name": "manualswapcustom",
        "code": "function manualswapcustom(uint256 percentage) external { require(_msgSender() == _Dev); uint256 contractBalance = balanceOf(address(this)); uint256 swapbalance = contractBalance.div(10**5).mul(percentage); swapTokensForEth(swapbalance); }",
        "vulnerability": "Potential manipulation by privileged role",
        "reason": "The manualswapcustom function allows the privileged _Dev role to swap tokens for ETH. The percentage parameter is unchecked, which could allow the _Dev to manipulate the contract balance by specifying a large percentage, leading to potential misuse of funds.",
        "file_name": "0x0003ed19f80564745e84b4cc411a7b6be4f0cf31.sol"
    }
]