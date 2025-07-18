[
    {
        "function_name": "transfer",
        "code": "function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyIfTransfersAllowed { balances[msg.sender] = balances[msg.sender].sub(_value); balances[_to] = balances[_to].add(_value); Transfer(msg.sender, _to, _value); }",
        "vulnerability": "Lack of balance check",
        "reason": "The transfer function does not check if the sender has enough balance to cover the transfer before subtracting the value from their balance. This can lead to an integer underflow when the sender's balance is less than the transfer amount, effectively allowing transfers of tokens the sender does not own.",
        "file_name": "0x284b0f2f49d072836db87dd25d0623cd2f622bb1.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) onlyIfTransfersAllowed { var _allowance = allowed[_from][msg.sender]; balances[_to] = balances[_to].add(_value); balances[_from] = balances[_from].sub(_value); allowed[_from][msg.sender] = _allowance.sub(_value); Transfer(_from, _to, _value); }",
        "vulnerability": "Lack of balance and allowance checks",
        "reason": "The transferFrom function does not verify that the '_from' address has sufficient balance to cover the transfer or that the allowance is sufficient before attempting to transfer the tokens. This can cause an integer underflow, allowing tokens to be transferred without proper authorization or available balance.",
        "file_name": "0x284b0f2f49d072836db87dd25d0623cd2f622bb1.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) { require((_value == 0) || (allowed[msg.sender][_spender] == 0)); allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); }",
        "vulnerability": "Race condition vulnerability",
        "reason": "The approve function has a known race condition vulnerability known as the 'approve/transferFrom' race condition. If a spender is given an allowance and then transfers tokens, the owner might inadvertently change the allowance thinking it is unused, leading to potential double-spending.",
        "file_name": "0x284b0f2f49d072836db87dd25d0623cd2f622bb1.sol"
    }
]