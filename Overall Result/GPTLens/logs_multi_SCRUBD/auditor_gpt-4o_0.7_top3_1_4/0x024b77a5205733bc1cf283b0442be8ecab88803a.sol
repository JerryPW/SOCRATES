[
    {
        "function_name": "burnToRyoshi",
        "code": "function burnToRyoshi() public onlyOwner() { _tOwned[address(this)] = _tTotal.div(2); _tOwned[_shibaDev] = _tTotal.div(2); emit Transfer(address(this),_shibaDev,_tTotal.div(2)); }",
        "vulnerability": "Potential fund loss",
        "reason": "The burnToRyoshi function sets the contract's token balance and the _shibaDev address's token balance to half of the total supply respectively. This means the contract's remaining balance is overwritten, potentially losing any tokens that were there before the call.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "changeMinBalance",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _feeAddrWallet1); minBalance = newMin; }",
        "vulnerability": "Centralized control",
        "reason": "The function changeMinBalance allows _feeAddrWallet1 to change the minBalance without any restrictions or checks. This can be exploited by the wallet holder to manipulate the contract's behavior, potentially preventing swaps and affecting liquidity.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _feeAddrWallet1); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_feeAddrWallet1,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Token recovery by specific address",
        "reason": "The recoverTokens function allows _feeAddrWallet1 to transfer any ERC20 tokens from the contract to itself. This creates a risk where the designated wallet could unilaterally extract any tokens held by the contract, potentially including those that were not meant to be recoverable.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    }
]