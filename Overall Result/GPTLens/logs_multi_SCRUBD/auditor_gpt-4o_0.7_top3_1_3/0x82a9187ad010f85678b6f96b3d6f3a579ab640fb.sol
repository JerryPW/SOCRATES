[
    {
        "function_name": "returnBalanseToTarget",
        "code": "function returnBalanseToTarget() public payable { assert (msg.sender == __owner); if (!target.send(this.balance)){ __owner.send(this.balance); } }",
        "vulnerability": "Use of send for transferring Ether",
        "reason": "The function uses the 'send' method to transfer Ether, which forwards only 2300 gas and can lead to failed transfers if the recipient consumes more than this amount of gas. If the primary 'target' send fails, it attempts to send to the '__owner'. This introduces a vulnerability where funds can be locked if both transfers fail due to insufficient gas or if the receiving accounts are contract accounts that revert transactions.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 10000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } if (!target.send(summa_rest)){ if (!msg.sender.send(summa_rest)){ __owner.send(summa_rest); SendEther(__owner, summa_rest); } else{ SendEther(msg.sender, summa_rest); } } else{ SendEther(target, summa_rest); } }",
        "vulnerability": "Reentrancy attack vulnerability",
        "reason": "The fallback function makes multiple 'send' calls within a loop and then tries to handle the remainder. If any agent is a contract with a fallback function that re-enters the contract, it could manipulate the state or drain funds. The lack of reentrancy protection mechanisms like checks-effects-interactions pattern makes it vulnerable to such attacks.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 10000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } if (!target.send(summa_rest)){ if (!msg.sender.send(summa_rest)){ __owner.send(summa_rest); SendEther(__owner, summa_rest); } else{ SendEther(msg.sender, summa_rest); } } else{ SendEther(target, summa_rest); } }",
        "vulnerability": "Gas limit and out-of-gas exceptions",
        "reason": "The fallback function uses 'send' to distribute funds, which only provides 2300 gas. If an agent's address or the target is a contract that requires more gas, the send will fail, and the remainder logic may be invoked incorrectly, leading to incorrect distribution or locking of funds.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    }
]