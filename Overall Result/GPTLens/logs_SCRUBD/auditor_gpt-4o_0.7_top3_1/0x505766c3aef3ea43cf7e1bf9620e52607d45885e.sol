[
    {
        "function_name": "function()",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 100000000000000000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } assert(summa_rest >= 100000000000000000); GESTokenCrowdSale(target).buyTokens.value(summa_rest)(tx.origin); SendEther(target, summa_rest); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends Ether to multiple agents using the low-level 'send' function, which is vulnerable to reentrancy attacks. An attacker could create a contract with a fallback function that reenters into the function, potentially manipulating the contract's state or draining funds before the function completes its execution.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    },
    {
        "function_name": "returnBalanseToTarget",
        "code": "function returnBalanseToTarget() public payable { assert (msg.sender == __owner); if (!target.send(this.balance)){ __owner.send(this.balance); } }",
        "vulnerability": "Incorrect handling of send failure",
        "reason": "The function attempts to send the entire contract balance to the target address using the 'send' function, which returns false on failure. If the 'send' fails, it attempts to send the balance to the owner. This can lead to loss of Ether if both sends fail, and it provides no mechanism to handle or retry failed transactions, potentially leaving the contract in an undesirable state.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    },
    {
        "function_name": "function()",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 100000000000000000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } assert(summa_rest >= 100000000000000000); GESTokenCrowdSale(target).buyTokens.value(summa_rest)(tx.origin); SendEther(target, summa_rest); }",
        "vulnerability": "Underflow vulnerability",
        "reason": "The calculation `summa_rest = summa_rest - value_to_send` can lead to an underflow if `value_to_send` is greater than `summa_rest`. This could occur if the sum of `value_to_send` for all agents exceeds `msg.value`. An underflow would result in a large unintended value for `summa_rest`, which could then be sent to the target, causing significant loss of funds.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    }
]