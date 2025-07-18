[
    {
        "function_name": "returnBalanseToTarget",
        "code": "function returnBalanseToTarget() public payable { assert (msg.sender == __owner); if (!target.send(this.balance)){ __owner.send(this.balance); } }",
        "vulnerability": "Use of send with no error handling",
        "reason": "The use of the `send` function is risky because it only forwards 2300 gas, which might be insufficient for the target address to execute the associated fallback function. If the send fails, the contract attempts to send the balance to the owner without any error handling mechanism to ensure funds are properly managed. This can lead to loss of ether if both sends fail.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 100000000000000000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } assert(summa_rest >= 100000000000000000); GESTokenCrowdSale(target).buyTokens.value(summa_rest)(tx.origin); SendEther(target, summa_rest); }",
        "vulnerability": "Reentrancy attack",
        "reason": "The fallback function uses the `send` method to transfer Ether to agents. If any of the agents are malicious contracts, they could re-enter the fallback function when they receive Ether, leading to potential unexpected behavior or draining of funds. Additionally, the contract does not use any mutex or state changes prior to external calls, making it susceptible to reentrancy attacks.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    },
    {
        "function_name": "constructor",
        "code": "function AgentContracteGalaxy(address tar_main,address tar1,address tar2,uint256 stake1,uint256 stake2) public { __owner = msg.sender; agent_to_piece_of_10000[tar1] = stake1; agents.push(tar1); agent_to_piece_of_10000[tar2] = stake2; agents.push(tar2); target = tar_main; }",
        "vulnerability": "Improper input validation",
        "reason": "The constructor does not validate the input values for `stake1` and `stake2`. If the total of these stakes exceeds 10000, it could lead to incorrect Ether distribution in the fallback function. Additionally, if either `tar1` or `tar2` is set to unexpected addresses, the contract may behave improperly, leading to potential loss of funds.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    }
]