[
    {
        "function_name": "returnBalanseToTarget",
        "code": "function returnBalanseToTarget() public payable { assert (msg.sender == __owner); if (!target.send(this.balance)){ __owner.send(this.balance); } }",
        "vulnerability": "Unsafe use of 'send' leading to potential loss of funds.",
        "reason": "The function uses 'send' to transfer Ether, which only forwards 2300 gas, making it possible for the Ether transfer to fail if the target address requires more than 2300 gas to execute its fallback function. If 'send' fails, it attempts to send the balance to the owner, but this can also fail for the same reason, potentially resulting in a loss of funds.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 100000000000000000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } assert(summa_rest >= 100000000000000000); GESTokenCrowdSale(target).buyTokens.value(summa_rest)(tx.origin); SendEther(target, summa_rest); }",
        "vulnerability": "Reentrancy vulnerability during Ether transfers.",
        "reason": "The fallback function transfers Ether to multiple agents using 'send', which can fail and affect the state variables. If an agent's address is a contract with a fallback function, it could exploit reentrancy to manipulate the contract state between 'send' calls, potentially disrupting the intended distribution of funds.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 100000000000000000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } assert(summa_rest >= 100000000000000000); GESTokenCrowdSale(target).buyTokens.value(summa_rest)(tx.origin); SendEther(target, summa_rest); }",
        "vulnerability": "Potential DoS with failed send operations.",
        "reason": "If any agent's 'send' operation consistently fails, the total 'summa_rest' may not reflect the intended amount to be sent to 'buyTokens', potentially causing the transaction to revert or fail. Additionally, the assertion at the end of the function checking 'summa_rest' can cause the function to revert if it doesn't meet the condition, making the entire contract vulnerable to denial of service.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    }
]