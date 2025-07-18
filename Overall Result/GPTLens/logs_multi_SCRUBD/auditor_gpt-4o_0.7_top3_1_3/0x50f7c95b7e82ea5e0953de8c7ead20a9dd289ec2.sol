[
    {
        "function_name": "approveAndCall",
        "code": "function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); if(!_spender.call(bytes4(bytes32(sha3(\"receiveApproval(address,uint256,address,bytes)\"))), msg.sender, _value, this, _extraData)) { throw; } return true; }",
        "vulnerability": "Reentrancy via external call",
        "reason": "The function uses a low-level call to invoke a function on the _spender contract without any reentrancy protection. This could allow an attacker to manipulate state changes in the calling contract by re-entering it through the called contract, potentially causing unexpected behaviors.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint _amountInwei) onlyOwner{ require(this.balance > _amountInwei); require(msg.sender == owner); owner.send(_amountInwei); }",
        "vulnerability": "Unsafe external call using send",
        "reason": "The function uses the send method to transfer Ether, which only forwards 2300 gas. If the recipient is a contract, this might not be enough gas for the fallback function to execute, potentially causing the send to fail. Moreover, it does not check the return value of send, which might lead to loss of funds if the send fails.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    },
    {
        "function_name": "sell",
        "code": "function sell(uint amount) returns (uint revenue){ require(balances[msg.sender] >= amount); balances[this] += amount; balances[msg.sender] -= amount; revenue = amount * sellPrice; require(msg.sender.send(revenue)); Transfer(msg.sender, this, amount); return revenue; }",
        "vulnerability": "Unsafe use of send without checking return value",
        "reason": "The function uses the send method to transfer Ether without checking if the transfer was successful. This could lead to a situation where the sender's balance is decreased, but the Ether is not actually transferred, resulting in a loss of tokens for the user.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    }
]