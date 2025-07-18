[
    {
        "function_name": "returnBalanseToTarget",
        "code": "function returnBalanseToTarget() public payable { assert (msg.sender == __owner); if (!target.send(this.balance)){ __owner.send(this.balance); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function attempts to send the entire balance to the target address using a low-level call ('send'), which sends 2300 gas, potentially allowing reentrancy if the target is a contract. If the target contract has a fallback or receive function, it can call back into this contract before the state is updated, potentially leading to unexpected behavior or draining of funds.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 10000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } if (!target.send(summa_rest)){ if (!msg.sender.send(summa_rest)){ __owner.send(summa_rest); SendEther(__owner, summa_rest); } else{ SendEther(msg.sender, summa_rest); } } else{ SendEther(target, summa_rest); } }",
        "vulnerability": "Denial of service through gas limits",
        "reason": "The fallback function iterates over the 'agents' array and attempts to send ether with a low-level call ('send'). If the array is large, the function may run out of gas, preventing it from executing completely, and potentially locking funds in the contract. This can be exploited by adding a large number of agents, causing the loop to consume excessive gas.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    },
    {
        "function_name": "getTarget",
        "code": "function getTarget() public constant returns (address){ assert (msg.sender == __owner); return target; }",
        "vulnerability": "Usage of assert instead of require",
        "reason": "The function uses 'assert' to check that 'msg.sender' is '__owner'. If 'msg.sender' is not '__owner', 'assert' will cause the transaction to consume all remaining gas and revert, which is more severe than using 'require'. This is critical because it can lead to unexpected high gas costs for the caller and disrupt contract execution.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    }
]