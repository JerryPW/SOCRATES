[
    {
        "function_name": "_transfer",
        "code": "function _transfer(address from, address to, uint256 amount) private {\n    require(from != address(0), \"ERC20: transfer from the zero address\");\n    require(to != address(0), \"ERC20: transfer to the zero address\");\n    require(amount > 0, \"Transfer amount must be greater than zero\");\n    require(amount <= balanceOf(from),\"You are trying to transfer more than your balance\");\n    require(!_isBot[from] && !_isBot[to], \"Fuck you Bots\");\n    if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){\n        require(tradingEnabled, \"Trading is not enabled yet\");\n    }\n    if( from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && from == pair){\n        require(amount <= maxBuyAmount, \"you are exceeding maxBuyAmount\");\n        uint256 walletCurrentBalance = balanceOf(to);\n        require(walletCurrentBalance + amount <= _maxWalletSize, \"Exceeds maximum wallet token amount\");\n    }\n    if( from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && from == pair){\n        require(amount <= maxSellAmount, \"Amount is exceeding maxSellAmount\");\n    }\n    uint256 contractTokenBalance = balanceOf(address(this));\n    bool canSwap = contractTokenBalance >= swapTokensAtAmount;\n    if(!swapping && swapEnabled && canSwap && from != pair){\n        uint256 balance = address(this).balance;\n        if (buyBackEnabled && balance > uint256(1 * 10**18) && to == pair) {\n            if (balance > buyBackUpperLimit) balance = buyBackUpperLimit;\n            buyBackTokens(balance.div(100));\n        }\n        swapAndLiquify(swapTokensAtAmount);\n    }\n    bool isSale;\n    if(to == pair) isSale = true;\n    _tokenTransfer(from, to, amount, !(_isExcludedFromFee[from] || _isExcludedFromFee[to]), isSale);\n}",
        "vulnerability": "Improper Fee Exclusion Check",
        "reason": "The conditional check for exclusion from fees is done using `_isExcludedFromFee[from] || _isExcludedFromFee[to]`, which can allow bypassing of fees if only one of the addresses is excluded. This can be exploited by transferring tokens between addresses that are intentionally excluded from fees, potentially allowing manipulation of the fee system.",
        "file_name": "0x0e50763fbbd9a2474c429041b338624bb2a8b7bd.sol"
    },
    {
        "function_name": "rescueBEP20Tokens",
        "code": "function rescueBEP20Tokens(address tokenAddress) external onlyOwner{\n    IERC20(tokenAddress).transfer(msg.sender, IERC20(tokenAddress).balanceOf(address(this)));\n}",
        "vulnerability": "Token Drain",
        "reason": "The `rescueBEP20Tokens` function allows the contract owner to transfer any BEP20 tokens held by the contract to themselves. This poses a risk of malicious or accidental token drainage if the owner account is compromised or if there was an error in depositing tokens.",
        "file_name": "0x0e50763fbbd9a2474c429041b338624bb2a8b7bd.sol"
    },
    {
        "function_name": "setRouterAddress",
        "code": "function setRouterAddress(address newRouter) external onlyOwner {\n    require(newRouter != address(router));\n    IRouter _newRouter = IRouter(newRouter);\n    address get_pair = IFactory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());\n    if (get_pair == address(0)) {\n        pair = IFactory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());\n    } else {\n        pair = get_pair;\n    }\n    router = _newRouter;\n}",
        "vulnerability": "Router Manipulation",
        "reason": "The `setRouterAddress` function enables the contract owner to update the router address arbitrarily. If the owner is compromised or acts maliciously, they could set a fraudulent router that redirects funds or manipulates transactions, potentially leading to loss of funds or other malicious activities.",
        "file_name": "0x0e50763fbbd9a2474c429041b338624bb2a8b7bd.sol"
    }
]