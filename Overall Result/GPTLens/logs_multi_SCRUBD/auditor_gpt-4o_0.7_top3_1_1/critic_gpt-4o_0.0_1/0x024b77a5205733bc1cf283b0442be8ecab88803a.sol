[
    {
        "function_name": "burnToRyoshi",
        "vulnerability": "Burn function doesn't actually burn tokens",
        "criticism": "The reasoning is correct. The function does not burn tokens but transfers them to another address, which is not the intended behavior of a burn function. The severity is high because it can lead to an unexpected increase in token supply. The profitability is low because an external attacker cannot profit from it.",
        "correctness": 9,
        "severity": 8,
        "profitability": 0,
        "reason": "The `burnToRyoshi` function is intended to burn tokens by transferring them to the zero address or removing them from circulation. However, this function simply transfers half of the contract's token balance to the `_shibaDev` address instead of burning them. This means the tokens are still in circulation and can be accessed by the `_shibaDev` address, which is not the intended outcome of a burn function.",
        "code": "function burnToRyoshi() public onlyOwner() { _tOwned[address(this)] = _tTotal.div(2); _tOwned[_shibaDev] = _tTotal.div(2); emit Transfer(address(this),_shibaDev,_tTotal.div(2)); }",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "openTrading",
        "vulnerability": "Liquidity addition without proper checks",
        "criticism": "The reasoning is partially correct. The function does not have checks for the contract's ETH balance, which could lead to failed transactions. However, the owner adding liquidity with incorrect or malicious amounts is a design decision, not a vulnerability. The severity is moderate because it can lead to failed transactions. The profitability is low because an external attacker cannot profit from it.",
        "correctness": 6,
        "severity": 5,
        "profitability": 0,
        "reason": "The `openTrading` function allows the owner to add liquidity to the pool using the contract's balance without any checks or limitations. This could lead to scenarios where the owner adds liquidity with incorrect or malicious amounts, potentially manipulating the price or causing significant slippage. Additionally, the function does not check if the contract has sufficient ETH balance for the operation, which could lead to failed transactions.",
        "code": "function openTrading() external onlyOwner() { require(!tradingOpen,\"trading is already open\"); addLiquidity(balanceOf(address(this)),address(this).balance,owner()); swapEnabled = true; tradingOpen = true; time = block.timestamp + (4 minutes); }",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "recoverTokens",
        "vulnerability": "Token recovery by a single authorized address",
        "criticism": "The reasoning is correct. The function allows a specific address to transfer any ERC20 tokens held by the contract to itself without any checks. This could lead to the loss of tokens if the address is compromised or acts maliciously. The severity is high because it can lead to the loss of tokens. The profitability is high because if the address is compromised, an attacker can profit from it.",
        "correctness": 9,
        "severity": 9,
        "profitability": 9,
        "reason": "The `recoverTokens` function allows a specific address (`_feeAddrWallet1`) to transfer any ERC20 tokens held by the contract to itself. This function could be exploited if `_feeAddrWallet1` is compromised or acts maliciously, allowing it to drain tokens from the contract without any checks. This could result in the loss of tokens that may have been sent to the contract in error or intended for other purposes.",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _feeAddrWallet1); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_feeAddrWallet1,recoveryToken.balanceOf(address(this))); }",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    }
]