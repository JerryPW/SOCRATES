[
    {
        "function_name": "burnToRyoshi",
        "code": "function burnToRyoshi() public onlyOwner() { _tOwned[address(this)] = _tTotal.div(2); _tOwned[_shibaDev] = _tTotal.div(2); emit Transfer(address(this),_shibaDev,_tTotal.div(2)); }",
        "vulnerability": "Arbitrary Token Transfer",
        "reason": "The burnToRyoshi function sets the contract's token balance to half of the total supply and transfers the other half to the _shibaDev address. This can lead to an unintended large transfer of tokens to a specific address, if misused or called without proper context, effectively draining half of the total supply.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "changeMinBalance",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _feeAddrWallet1); minBalance = newMin; }",
        "vulnerability": "Privilege Escalation",
        "reason": "The changeMinBalance function can only be executed by the _feeAddrWallet1 address, which might not necessarily be the contract owner or a trusted entity. If this address is compromised, an attacker can alter the minBalance to manipulate contract behavior, such as triggering swaps more or less frequently.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _feeAddrWallet1); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_feeAddrWallet1,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Token Draining",
        "reason": "The recoverTokens function allows the _feeAddrWallet1 address to transfer any ERC20 tokens held by the contract to itself. If this address is compromised, an attacker can drain all ERC20 tokens from the contract, including those that do not belong to it, causing significant loss to the token holders.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    }
]