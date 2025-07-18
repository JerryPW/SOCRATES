[
    {
        "function_name": "returnBalanseToTarget",
        "code": "function returnBalanseToTarget() public payable { assert (msg.sender == __owner); if (!target.send(this.balance)){ __owner.send(this.balance); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function attempts to send the contract's balance to the target address using the send method. If the target contract is malicious, it can call back into returnBalanseToTarget before the balance is updated, causing repeated sending attempts. This could potentially drain the contract's balance.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 100000000000000000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } assert(summa_rest >= 100000000000000000); GESTokenCrowdSale(target).buyTokens.value(summa_rest)(tx.origin); SendEther(target, summa_rest); }",
        "vulnerability": "Potential underflow and incorrect state update",
        "reason": "The fallback function calculates and sends ether to multiple agents and the target contract. If any agent's send fails, the logic attempts to revert the amount to summa_rest. However, if multiple sends fail, summa_rest may not reflect the correct remainder due to potential underflows, which could lead to incorrect amounts being sent to the target contract or loss of funds.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    },
    {
        "function_name": "AgentContracteGalaxy",
        "code": "function AgentContracteGalaxy(address tar_main,address tar1,address tar2,uint256 stake1,uint256 stake2) public { __owner = msg.sender; agent_to_piece_of_10000[tar1] = stake1; agents.push(tar1); agent_to_piece_of_10000[tar2] = stake2; agents.push(tar2); target = tar_main; }",
        "vulnerability": "Initialization with arbitrary stakeholders",
        "reason": "The constructor allows initialization with arbitrary agent addresses and stake values which are not validated. An attacker could deploy the contract with malicious agent addresses that can exploit further vulnerabilities, especially in the fallback function where funds are distributed according to these stake values.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    }
]