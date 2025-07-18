[
    {
        "function_name": "approveAndCall",
        "code": "function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); if(!_spender.call(bytes4(bytes32(sha3(\"receiveApproval(address,uint256,address,bytes)\"))), msg.sender, _value, this, _extraData)) { throw; } return true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The approveAndCall function allows for a call to an external contract via _spender.call. If the external contract is malicious, it can re-enter the approveAndCall function or other functions that modify the state of the contract, potentially leading to unexpected behavior or exploitation.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint _amountInwei) onlyOwner{ require(this.balance > _amountInwei); require(msg.sender == owner); owner.send(_amountInwei); }",
        "vulnerability": "Unsafe use of send",
        "reason": "The withdraw function uses the low-level send method which forwards only 2300 gas and does not handle failures properly. If the send fails, the function does not revert, which may lead to loss of funds or state inconsistencies.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    },
    {
        "function_name": "sell",
        "code": "function sell(uint amount) returns (uint revenue){ require(balances[msg.sender] >= amount); balances[this] += amount; balances[msg.sender] -= amount; revenue = amount * sellPrice; require(msg.sender.send(revenue)); Transfer(msg.sender, this, amount); return revenue; }",
        "vulnerability": "Unsafe use of send",
        "reason": "The sell function uses the low-level send method to transfer Ether, which forwards only 2300 gas and does not handle failures properly. This can lead to loss of funds if the send fails and the function does not revert, leaving the contract in an inconsistent state.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    }
]