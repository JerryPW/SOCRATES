[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) { var _allowance = allowed[_from][msg.sender]; balances[_to] = balances[_to].add(_value); balances[_from] = balances[_from].sub(_value); allowed[_from][msg.sender] = _allowance.sub(_value); Transfer(_from, _to, _value); }",
        "vulnerability": "Lack of allowance check",
        "reason": "The function does not check if `_allowance` is greater than or equal to `_value`, allowing potential over-withdrawal from the '_from' account. An attacker could exploit this to transfer more tokens than permitted, leading to unauthorized token transfers.",
        "file_name": "0xd1265bfe57597840f89971b7e67538bac780f9ad.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) { require((_value == 0) || (allowed[msg.sender][_spender] == 0)); allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); }",
        "vulnerability": "Race condition on allowance",
        "reason": "The approve function allows for a race condition that can be exploited. If a spender is approved for a certain allowance, they could exploit the lack of atomicity by front-running a transaction to set a new allowance, leading to a potential double-spend scenario.",
        "file_name": "0xd1265bfe57597840f89971b7e67538bac780f9ad.sol"
    },
    {
        "function_name": "finishPhase",
        "code": "function finishPhase() onlyOwner { require(tokensSelling != 0); token.transfer(beneficiary, tokensSelling); tokensSelling = 0; }",
        "vulnerability": "Token transfer without balance check",
        "reason": "The function assumes that the contract has enough tokens to transfer to the beneficiary without checking the balance of the contract. If the contract balance is less than `tokensSelling`, it would lead to a failed transfer and potentially lock the tokens in the contract, stopping further operations.",
        "file_name": "0xd1265bfe57597840f89971b7e67538bac780f9ad.sol"
    }
]