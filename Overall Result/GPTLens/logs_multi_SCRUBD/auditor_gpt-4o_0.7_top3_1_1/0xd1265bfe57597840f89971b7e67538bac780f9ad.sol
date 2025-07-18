[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {\n    var _allowance = allowed[_from][msg.sender];\n    balances[_to] = balances[_to].add(_value);\n    balances[_from] = balances[_from].sub(_value);\n    allowed[_from][msg.sender] = _allowance.sub(_value);\n    Transfer(_from, _to, _value);\n}",
        "vulnerability": "Missing allowance check",
        "reason": "The function does not check if _value is less than or equal to _allowance before executing the transfer, allowing potential overdrafts.",
        "file_name": "0xd1265bfe57597840f89971b7e67538bac780f9ad.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) {\n    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n    allowed[msg.sender][_spender] = _value;\n    Approval(msg.sender, _spender, _value);\n}",
        "vulnerability": "Race condition on allowance",
        "reason": "Allows setting allowance to a non-zero value directly after another non-zero value, introducing a risk of double-spending in some cases unless the spender reduces the allowance to zero first.",
        "file_name": "0xd1265bfe57597840f89971b7e67538bac780f9ad.sol"
    },
    {
        "function_name": "finishPhase",
        "code": "function finishPhase() onlyOwner {\n    require(tokensSelling != 0);\n    token.transfer(beneficiary, tokensSelling);\n    tokensSelling = 0;\n}",
        "vulnerability": "Potential token loss during transfer",
        "reason": "The function assumes that token.transfer will always succeed, but if the transfer fails due to insufficient tokens or other issues, the tokensSelling variable will be reset to 0, leading to potential loss of tokens.",
        "file_name": "0xd1265bfe57597840f89971b7e67538bac780f9ad.sol"
    }
]