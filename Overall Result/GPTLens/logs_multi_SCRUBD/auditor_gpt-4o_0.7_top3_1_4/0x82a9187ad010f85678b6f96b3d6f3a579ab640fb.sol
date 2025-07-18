[
    {
        "function_name": "returnBalanseToTarget",
        "code": "function returnBalanseToTarget() public payable { assert (msg.sender == __owner); if (!target.send(this.balance)){ __owner.send(this.balance); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of `send` for transferring Ether can lead to reentrancy attacks, especially when transferring the entire balance. If `target.send(this.balance)` fails, it attempts to send the balance to `__owner`, which could be exploited by an attacker if either `target` or `__owner` is a contract that manipulates control flow.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 10000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } if (!target.send(summa_rest)){ if (!msg.sender.send(summa_rest)){ __owner.send(summa_rest); SendEther(__owner, summa_rest); } else{ SendEther(msg.sender, summa_rest); } } else{ SendEther(target, summa_rest); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function has multiple `send` calls that can fail and lead to reentrancy, especially when sending Ether to agents. An agent could be a contract that exploits this by causing a reentrant call, manipulating the contract state or preventing the correct distribution of funds.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    },
    {
        "function_name": "AgentContract",
        "code": "function AgentContract(address tar_main,address tar1,address tar2,uint256 stake1,uint256 stake2) public { __owner = msg.sender; agent_to_piece_of_10000[tar1] = stake1; agents.push(tar1); agent_to_piece_of_10000[tar2] = stake2; agents.push(tar2); target = tar_main; }",
        "vulnerability": "Constructor does not validate input addresses",
        "reason": "The constructor does not check if the input addresses are valid or non-zero. This can lead to `target`, `tar1`, or `tar2` being set to zero addresses, which can have unintended consequences in other parts of the contract, such as sending Ether to the zero address.",
        "file_name": "0x82a9187ad010f85678b6f96b3d6f3a579ab640fb.sol"
    }
]