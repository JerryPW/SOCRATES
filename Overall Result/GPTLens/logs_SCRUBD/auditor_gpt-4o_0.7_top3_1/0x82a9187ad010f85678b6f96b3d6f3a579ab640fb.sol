[
    {
        "function_name": "returnBalanseToTarget",
        "code": "function returnBalanseToTarget() public payable { assert (msg.sender == __owner); if (!target.send(this.balance)){ __owner.send(this.balance); } }",
        "vulnerability": "Use of send() function",
        "reason": "The use of the send() function is potentially dangerous because it only forwards 2300 gas, which may not be enough to complete the transaction if the fallback function of the target consumes more gas. If the send operation fails, the balance is sent to the owner, which could lead to unintended ether loss or theft if the owner is compromised or malicious.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    },
    {
        "function_name": "function()",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 10000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } if (!target.send(summa_rest)){ if (!msg.sender.send(summa_rest)){ __owner.send(summa_rest); SendEther(__owner, summa_rest); } else{ SendEther(msg.sender, summa_rest); } } else{ SendEther(target, summa_rest); } }",
        "vulnerability": "Reentrancy attack",
        "reason": "The fallback function uses send() to transfer ether, which can trigger reentrancy if any of the recipient contracts have a fallback function that calls back into this contract. This can lead to draining of funds from the contract as the state update happens after the send operation.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    },
    {
        "function_name": "getTarget",
        "code": "function getTarget() public constant returns (address){ assert (msg.sender == __owner); return target; }",
        "vulnerability": "Potential owner lockout",
        "reason": "If the __owner address is lost or compromised, there is no way to change ownership or recover control of the contract. This can result in a permanent lockout from accessing critical functions such as getTarget, listAgents, and returnBalanseToTarget.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    }
]