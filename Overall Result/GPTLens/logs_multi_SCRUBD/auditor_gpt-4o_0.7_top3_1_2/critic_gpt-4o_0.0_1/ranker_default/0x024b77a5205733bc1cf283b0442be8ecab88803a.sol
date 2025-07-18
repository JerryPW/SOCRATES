[
    {
        "function_name": "recoverTokens",
        "vulnerability": "Token Recovery Function Exploit",
        "criticism": "The reasoning is correct in identifying that the recoverTokens function allows the _feeAddrWallet1 to transfer any ERC20 tokens held by the contract to itself. If this address is compromised, an attacker could indeed drain tokens, leading to financial loss. The severity is high because it can result in a complete loss of tokens held by the contract. The profitability is high for an attacker if the address is compromised, as they can transfer all tokens to themselves.",
        "correctness": 9,
        "severity": 8,
        "profitability": 7,
        "reason": "The recoverTokens function allows the _feeAddrWallet1 to transfer any ERC20 tokens held by the contract to itself. If the _feeAddrWallet1 address is compromised, an attacker could drain any ERC20 tokens that are sent to this contract by mistake or otherwise, leading to potential financial loss for the token holders.",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _feeAddrWallet1); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_feeAddrWallet1,recoveryToken.balanceOf(address(this))); }",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol",
        "final_score": 8.25
    },
    {
        "function_name": "burnToRyoshi",
        "vulnerability": "Token Redistribution Vulnerability",
        "criticism": "The reasoning is correct in identifying that the burnToRyoshi function allows the owner to redistribute half of the total token supply to a specified address (_shibaDev). This can indeed manipulate token distribution and affect market value. The severity is high because it can significantly impact token scarcity and market dynamics. The profitability is moderate, as it depends on the owner's intentions and the market's reaction to such redistribution.",
        "correctness": 8,
        "severity": 7,
        "profitability": 5,
        "reason": "The burnToRyoshi function splits the total token supply between the contract itself and a specified address (_shibaDev). This is problematic because it allows the owner to arbitrarily redistribute half of the total supply to another address, which could be used maliciously to manipulate token distribution, affecting token scarcity and market value.",
        "code": "function burnToRyoshi() public onlyOwner() { _tOwned[address(this)] = _tTotal.div(2); _tOwned[_shibaDev] = _tTotal.div(2); emit Transfer(address(this),_shibaDev,_tTotal.div(2)); }",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol",
        "final_score": 7.0
    },
    {
        "function_name": "changeMinBalance",
        "vulnerability": "Improper Access Control",
        "criticism": "The reasoning correctly identifies that the changeMinBalance function allows a specific address (_feeAddrWallet1) to change the minBalance value, which could affect other functions relying on this variable. The severity is moderate because it can lead to unexpected behavior in liquidity operations. The profitability is low, as it requires the _feeAddrWallet1 address to be compromised for an attacker to exploit this vulnerability.",
        "correctness": 8,
        "severity": 5,
        "profitability": 2,
        "reason": "The changeMinBalance function allows the _feeAddrWallet1 address to change the minBalance value, which could impact the logic in swapAndLiquify and other functions that depend on this variable. This could lead to unexpected behavior or manipulation of liquidity operations, especially if the _feeAddrWallet1 address is compromised.",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _feeAddrWallet1); minBalance = newMin; }",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol",
        "final_score": 5.75
    }
]