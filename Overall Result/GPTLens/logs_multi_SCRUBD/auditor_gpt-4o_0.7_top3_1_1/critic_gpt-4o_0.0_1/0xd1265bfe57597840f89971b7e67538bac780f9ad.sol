[
    {
        "function_name": "transferFrom",
        "vulnerability": "Missing allowance check",
        "criticism": "The reasoning is incorrect. The function does check the allowance through the 'sub' function which will throw an exception if _value is greater than _allowance. Therefore, there is no risk of overdrafts. The severity and profitability are both low as there is no vulnerability.",
        "correctness": 0,
        "severity": 0,
        "profitability": 0,
        "reason": "The function does not check if _value is less than or equal to _allowance before executing the transfer, allowing potential overdrafts.",
        "code": "function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {\n    var _allowance = allowed[_from][msg.sender];\n    balances[_to] = balances[_to].add(_value);\n    balances[_from] = balances[_from].sub(_value);\n    allowed[_from][msg.sender] = _allowance.sub(_value);\n    Transfer(_from, _to, _value);\n}",
        "file_name": "0xd1265bfe57597840f89971b7e67538bac780f9ad.sol"
    },
    {
        "function_name": "approve",
        "vulnerability": "Race condition on allowance",
        "criticism": "The reasoning is incorrect. The function does require that the current allowance is zero before a new non-zero value can be set. Therefore, there is no risk of double-spending unless the spender reduces the allowance to zero first. The severity and profitability are both low as there is no vulnerability.",
        "correctness": 0,
        "severity": 0,
        "profitability": 0,
        "reason": "Allows setting allowance to a non-zero value directly after another non-zero value, introducing a risk of double-spending in some cases unless the spender reduces the allowance to zero first.",
        "code": "function approve(address _spender, uint256 _value) {\n    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n    allowed[msg.sender][_spender] = _value;\n    Approval(msg.sender, _spender, _value);\n}",
        "file_name": "0xd1265bfe57597840f89971b7e67538bac780f9ad.sol"
    },
    {
        "function_name": "finishPhase",
        "vulnerability": "Potential token loss during transfer",
        "criticism": "The reasoning is correct. The function does not check if the transfer is successful before setting tokensSelling to 0. If the transfer fails, the tokens would be lost. The severity is high as it could result in loss of tokens. The profitability is low as an external attacker cannot profit from this vulnerability.",
        "correctness": 9,
        "severity": 9,
        "profitability": 0,
        "reason": "The function assumes that token.transfer will always succeed, but if the transfer fails due to insufficient tokens or other issues, the tokensSelling variable will be reset to 0, leading to potential loss of tokens.",
        "code": "function finishPhase() onlyOwner {\n    require(tokensSelling != 0);\n    token.transfer(beneficiary, tokensSelling);\n    tokensSelling = 0;\n}",
        "file_name": "0xd1265bfe57597840f89971b7e67538bac780f9ad.sol"
    }
]