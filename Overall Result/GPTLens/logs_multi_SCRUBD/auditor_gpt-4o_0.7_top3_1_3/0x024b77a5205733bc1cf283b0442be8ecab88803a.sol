[
    {
        "function_name": "burnToRyoshi",
        "code": "function burnToRyoshi() public onlyOwner() { _tOwned[address(this)] = _tTotal.div(2); _tOwned[_shibaDev] = _tTotal.div(2); emit Transfer(address(this),_shibaDev,_tTotal.div(2)); }",
        "vulnerability": "Token Redistribution Vulnerability",
        "reason": "The function 'burnToRyoshi' divides the total token supply between the contract itself and the '_shibaDev' address without actually burning any tokens. This can lead to a significant and unexpected shift in token ownership, concentrating half of the tokens to the '_shibaDev' address without the consent of other token holders. This can be exploited by the owner to unfairly redistribute tokens to a potentially malicious address.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "openTrading",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); addLiquidity(balanceOf(address(this)),address(this).balance,owner()); swapEnabled = true; tradingOpen = true; time = block.timestamp + (4 minutes); }",
        "vulnerability": "Liquidity Addition with Owner's Balance",
        "reason": "In 'openTrading', the liquidity is added using the contract's balance, which is initially supplied in the constructor. This function can be exploited by the owner by supplying a minimal amount of ETH and tokens to the contract, thereby controlling the initial liquidity setup. This can be used to manipulate prices or conduct a rug pull by withdrawing liquidity after a significant amount of trading has occurred.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _feeAddrWallet1); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_feeAddrWallet1,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Token Recovery by Specific Wallet",
        "reason": "The 'recoverTokens' function allows '_feeAddrWallet1' to recover any ERC20 tokens held by the contract. This can be exploited if '_feeAddrWallet1' is compromised or malicious, enabling them to drain tokens from the contract. Furthermore, it poses a risk if an incorrect token address is provided, leading to unintended token transfers and losses for token holders.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    }
]