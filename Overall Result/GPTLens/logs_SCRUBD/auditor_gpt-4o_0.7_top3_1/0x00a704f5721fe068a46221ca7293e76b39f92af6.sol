[
    {
        "function_name": "_transfer",
        "code": "function _transfer(address from, address to, uint256 amount) private { require(amount > 0, \"Transfer amount must be greater than zero\"); require(!bots[from]); if (from != address(this)) { _feeAddr1 = 4; _feeAddr2 = 8; if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) { require(amount <= _maxTxAmount); } uint256 contractTokenBalance = balanceOf(address(this)); if (!inSwap && from != uniswapV2Pair && swapEnabled) { swapTokensForEth(contractTokenBalance); uint256 contractETHBalance = address(this).balance; if(contractETHBalance > 300000000000000000) { sendETHToFee(address(this).balance); } } } _tokenTransfer(from,to,amount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function involves external calls (swapTokensForEth and sendETHToFee) which transfer tokens/ETH after checking balances, but before the actual transfer logic (_tokenTransfer) is executed. This can potentially lead to a reentrancy attack where an attacker could manipulate the balances or state by calling another function recursively before the state is updated.",
        "file_name": "0x00a704f5721fe068a46221ca7293e76b39f92af6.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Authorization issue",
        "reason": "The function authorization relies solely on the caller being _feeAddrWallet1. If the private key of _feeAddrWallet1 is compromised, an attacker can trigger this function and swap all tokens held by the contract for ETH, potentially draining the contract of its assets.",
        "file_name": "0x00a704f5721fe068a46221ca7293e76b39f92af6.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Authorization issue",
        "reason": "Similar to the manualswap function, this function can be called by anyone who has control over the _feeAddrWallet1 address. If the private key is compromised, the attacker can drain all ETH from the contract to the designated fee addresses, leading to potential loss of funds.",
        "file_name": "0x00a704f5721fe068a46221ca7293e76b39f92af6.sol"
    }
]