[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint _value) returns (bool success) { if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw; allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race Condition - Approval Double-Spend",
        "reason": "The approve function contains a check that throws if the current allowance is not zero. This design pattern is prone to race conditions, as it assumes that the spender has used up its allowance before the value is changed. If the spender's allowance is non-zero, the function will fail. This can lead to situations where allowances cannot be changed if tokens are partially spent, which can be exploited by an attacker to double-spend tokens if the function is called again before the spender spends their allowance.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) { balances[msg.sender] = safeSub(balances[msg.sender], _value); balances[_to] = safeAdd(balances[_to], _value); Transfer(msg.sender, _to, _value); return true; }",
        "vulnerability": "Integer Underflow",
        "reason": "The transfer function uses the safeSub method to subtract the amount from the sender's balance. However, if the sender's balance is less than the value to be transferred, this will cause an integer underflow, potentially allowing the attacker to transfer more tokens than they own, resulting in the creation of tokens from nothing.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    },
    {
        "function_name": "setMultisig",
        "code": "function setMultisig(address addr) public onlyOwner { if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) { throw; } multisigWallet = addr; }",
        "vulnerability": "Denial of Service (DoS) through Max Investments",
        "reason": "The setMultisig function allows the owner to change the multisig wallet address only if the number of investors is less than or equal to MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE. If the number of investors exceeds this threshold, the function will throw, preventing the owner from changing the multisig wallet. This condition can be exploited by an attacker who deliberately increases the number of investors to block the ability to change the wallet, causing a denial of service.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    }
]