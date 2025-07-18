[
    {
        "function_name": "approveAndCall",
        "code": "function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n    allowed[msg.sender][_spender] = _value;\n    Approval(msg.sender, _spender, _value);\n    if(!_spender.call(bytes4(bytes32(sha3(\"receiveApproval(address,uint256,address,bytes)\"))), msg.sender, _value, this, _extraData)) {\n        throw;\n    }\n    return true;\n}",
        "vulnerability": "reentrancy_vulnerability",
        "reason": "The use of call with user-controlled data (_spender) without checks for reentrancy allows an attacker contract to call back into the approveAndCall function or other vulnerable parts of the contract, potentially leading to unexpected behavior and draining of the contract's funds.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint _amountInwei) onlyOwner{\n    require(this.balance > _amountInwei);\n    require(msg.sender == owner);\n    owner.send(_amountInwei);\n}",
        "vulnerability": "unsafe_external_call",
        "reason": "Using send for transferring ether is unsafe as it does not throw an exception when it fails and only forwards a limited amount of gas, which can lead to loss of funds if the transfer fails and is not handled correctly.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    },
    {
        "function_name": "sell",
        "code": "function sell(uint amount) returns (uint revenue){\n    require(balances[msg.sender] >= amount);\n    balances[this] += amount;\n    balances[msg.sender] -= amount;\n    revenue = amount * sellPrice;\n    require(msg.sender.send(revenue));\n    Transfer(msg.sender, this, amount);\n    return revenue;\n}",
        "vulnerability": "unsafe_external_call",
        "reason": "Using send for transferring ether is unsafe as it does not throw an exception when it fails and only forwards a limited amount of gas, leading to potential loss of funds or incorrect contract state if the send operation fails.",
        "file_name": "0x50f7c95b7e82ea5e0953de8c7ead20a9dd289ec2.sol"
    }
]