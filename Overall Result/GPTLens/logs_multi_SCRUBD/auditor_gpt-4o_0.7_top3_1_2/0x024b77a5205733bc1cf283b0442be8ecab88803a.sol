[
    {
        "function_name": "burnToRyoshi",
        "code": "function burnToRyoshi() public onlyOwner() { _tOwned[address(this)] = _tTotal.div(2); _tOwned[_shibaDev] = _tTotal.div(2); emit Transfer(address(this),_shibaDev,_tTotal.div(2)); }",
        "vulnerability": "Token Redistribution Vulnerability",
        "reason": "The burnToRyoshi function splits the total token supply between the contract itself and a specified address (_shibaDev). This is problematic because it allows the owner to arbitrarily redistribute half of the total supply to another address, which could be used maliciously to manipulate token distribution, affecting token scarcity and market value.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "changeMinBalance",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _feeAddrWallet1); minBalance = newMin; }",
        "vulnerability": "Improper Access Control",
        "reason": "The changeMinBalance function allows the _feeAddrWallet1 address to change the minBalance value, which could impact the logic in swapAndLiquify and other functions that depend on this variable. This could lead to unexpected behavior or manipulation of liquidity operations, especially if the _feeAddrWallet1 address is compromised.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "recoverTokens",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _feeAddrWallet1); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_feeAddrWallet1,recoveryToken.balanceOf(address(this))); }",
        "vulnerability": "Token Recovery Function Exploit",
        "reason": "The recoverTokens function allows the _feeAddrWallet1 to transfer any ERC20 tokens held by the contract to itself. If the _feeAddrWallet1 address is compromised, an attacker could drain any ERC20 tokens that are sent to this contract by mistake or otherwise, leading to potential financial loss for the token holders.",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    }
]