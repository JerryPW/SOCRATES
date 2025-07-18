[
    {
        "function_name": "approveAndCall",
        "code": "function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); if(!_spender.call(bytes4(bytes32(sha3(\"receiveApproval(address,uint256,address,bytes)\"))), msg.sender, _value, this, _extraData)) { throw; } return true; }",
        "vulnerability": "Potential reentrancy vulnerability",
        "reason": "The function makes an external call to _spender before updating its state variables (throwing an exception in case of failure). This could lead to a reentrancy attack if _spender is a contract that calls back into this contract.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    },
    {
        "function_name": "sell",
        "code": "function sell(uint amount) returns (uint revenue){ require(balances[msg.sender] >= amount); balances[this] += amount; balances[msg.sender] -= amount; revenue = amount * sellPrice; require(msg.sender.send(revenue)); Transfer(msg.sender, this, amount); return revenue; }",
        "vulnerability": "Unrestricted send function",
        "reason": "The require statement that sends Ether to msg.sender can fail and revert the transaction, or worse, succeed with an unintended contract call. Sending Ether using send can lead to unexpected behavior if msg.sender is a contract, potentially causing reentrancy issues.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint _amountInwei) onlyOwner{ require(this.balance > _amountInwei); require(msg.sender == owner); owner.send(_amountInwei); }",
        "vulnerability": "Use of send for Ether transfer",
        "reason": "Using send for transferring Ether can lead to unexpected failures due to the 2300 gas stipend. If the transfer fails, the funds remain locked in the contract. Use of call.value()() is recommended to handle Ether transfers properly.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    }
]