[
    {
        "function_name": "burnToRyoshi",
        "vulnerability": "Arbitrary Token Transfer",
        "criticism": "The reasoning is correct in identifying that the function can lead to a large transfer of tokens to a specific address. However, the function is restricted to the owner, which limits the risk to external attackers. The severity is moderate because it can significantly affect the token distribution if misused. The profitability is low for external attackers but could be high for the owner if they choose to exploit it.",
        "correctness": 8,
        "severity": 5,
        "profitability": 2,
        "reason": "The burnToRyoshi function sets the contract's token balance to half of the total supply and transfers the other half to the _shibaDev address. This can lead to an unintended large transfer of tokens to a specific address, if misused or called without proper context, effectively draining half of the total supply.",
        "code": "function burnToRyoshi() public onlyOwner() { _tOwned[address(this)] = _tTotal.div(2); _tOwned[_shibaDev] = _tTotal.div(2); emit Transfer(address(this),_shibaDev,_tTotal.div(2)); }",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "changeMinBalance",
        "vulnerability": "Privilege Escalation",
        "criticism": "The reasoning correctly identifies that the function allows a specific address to change the minBalance, which could be problematic if that address is compromised. However, this is more of a design decision rather than a vulnerability. The severity is low because it does not directly lead to a loss of funds, but it could affect contract behavior. The profitability is low as it does not provide direct financial gain.",
        "correctness": 7,
        "severity": 3,
        "profitability": 1,
        "reason": "The changeMinBalance function can only be executed by the _feeAddrWallet1 address, which might not necessarily be the contract owner or a trusted entity. If this address is compromised, an attacker can alter the minBalance to manipulate contract behavior, such as triggering swaps more or less frequently.",
        "code": "function changeMinBalance(uint256 newMin) external { require(_msgSender() == _feeAddrWallet1); minBalance = newMin; }",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    },
    {
        "function_name": "recoverTokens",
        "vulnerability": "Token Draining",
        "criticism": "The reasoning is correct in identifying that the function allows the specified address to transfer any ERC20 tokens from the contract. If this address is compromised, it could lead to a significant loss of tokens. The severity is high because it can result in a complete loss of tokens held by the contract. The profitability is high for an attacker who gains control of the specified address.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The recoverTokens function allows the _feeAddrWallet1 address to transfer any ERC20 tokens held by the contract to itself. If this address is compromised, an attacker can drain all ERC20 tokens from the contract, including those that do not belong to it, causing significant loss to the token holders.",
        "code": "function recoverTokens(address tokenAddress) external { require(_msgSender() == _feeAddrWallet1); IERC20 recoveryToken = IERC20(tokenAddress); recoveryToken.transfer(_feeAddrWallet1,recoveryToken.balanceOf(address(this))); }",
        "file_name": "0x024b77a5205733bc1cf283b0442be8ecab88803a.sol"
    }
]