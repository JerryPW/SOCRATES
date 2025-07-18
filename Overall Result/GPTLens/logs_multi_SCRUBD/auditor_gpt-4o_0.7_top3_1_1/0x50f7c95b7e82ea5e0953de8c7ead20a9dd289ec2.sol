[
    {
        "function_name": "approveAndCall",
        "code": "function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); if(!_spender.call(bytes4(bytes32(sha3(\"receiveApproval(address,uint256,address,bytes)\"))), msg.sender, _value, this, _extraData)) { throw; } return true; }",
        "vulnerability": "Potential reentrancy attack",
        "reason": "The function allows an external call to a contract through the call method, which is prone to reentrancy attacks. If the called contract is malicious, it can reenter the original contract in an unexpected state, potentially exploiting it.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint _amountInwei) onlyOwner{ require(this.balance > _amountInwei); require(msg.sender == owner); owner.send(_amountInwei); }",
        "vulnerability": "Unsafe use of send",
        "reason": "Using send is discouraged because it only forwards 2300 gas, which may be insufficient for certain operations in the recipient contract. This could lead to locked funds if the transaction fails due to low gas. Consider using transfer or a low-level call with proper error handling.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    },
    {
        "function_name": "sell",
        "code": "function sell(uint amount) returns (uint revenue){ require(balances[msg.sender] >= amount); balances[this] += amount; balances[msg.sender] -= amount; revenue = amount * sellPrice; require(msg.sender.send(revenue)); Transfer(msg.sender, this, amount); return revenue; }",
        "vulnerability": "Unsafe use of send",
        "reason": "Similar to the withdraw function, using send to transfer Ether can result in locked funds if the recipient's fallback function requires more than 2300 gas. This poses a risk of funds being stuck if the send fails.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    }
]