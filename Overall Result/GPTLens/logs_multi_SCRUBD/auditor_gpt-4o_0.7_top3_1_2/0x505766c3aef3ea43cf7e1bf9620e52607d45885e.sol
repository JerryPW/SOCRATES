[
    {
        "function_name": "returnBalanseToTarget",
        "code": "function returnBalanseToTarget() public payable { assert (msg.sender == __owner); if (!target.send(this.balance)){ __owner.send(this.balance); } }",
        "vulnerability": "Denial of Service via send failure",
        "reason": "The use of `send` is risky because it only forwards 2300 gas, which might not be enough for the target's fallback function, causing it to fail. If the `send` to `target` fails, it attempts to send the balance to `__owner`, which might also fail if the `__owner`'s fallback function consumes more than 2300 gas. This can lead to a situation where funds are stuck in the contract indefinitely.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    },
    {
        "function_name": "function() payable",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 100000000000000000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } assert(summa_rest >= 100000000000000000); GESTokenCrowdSale(target).buyTokens.value(summa_rest)(tx.origin); SendEther(target, summa_rest); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends ether to multiple addresses in the `agents` array using `send`, which can be intercepted by a malicious agent with a fallback function that reenters the contract. If a reentrant call occurs after sending ether to an agent but before updating `summa_rest`, it can manipulate the logic of the contract. Although `send` limits gas, it's still possible for an attacker to exploit the logic to affect the distribution of funds or cause unexpected behavior.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    },
    {
        "function_name": "function() payable",
        "code": "function() payable public { uint256 summa = msg.value; assert(summa >= 100000000000000000); uint256 summa_rest = msg.value; for (uint i=0; i<agents.length; i++){ uint256 piece_to_send = agent_to_piece_of_10000[agents[i]]; uint256 value_to_send = (summa * piece_to_send) / 10000; summa_rest = summa_rest - value_to_send; if (!agents[i].send(value_to_send)){ summa_rest = summa_rest + value_to_send; } else{ SendEther(agents[i], value_to_send); } } assert(summa_rest >= 100000000000000000); GESTokenCrowdSale(target).buyTokens.value(summa_rest)(tx.origin); SendEther(target, summa_rest); }",
        "vulnerability": "Arithmetic underflow and incorrect assertion",
        "reason": "The loop reduces `summa_rest` by `value_to_send` for each agent, but if `value_to_send` is greater than `summa_rest` at any point (due to incorrect setup or precision error), it causes an underflow, making `summa_rest` a very large number. This can lead to incorrect amount being sent to `buyTokens`, violating the intended logic of fund distribution. Also, the final assertion `assert(summa_rest >= 100000000000000000)` assumes that the remaining amount is always greater than or equal to a specific value, which can be bypassed due to such underflows.",
        "file_name": "0x505766c3aef3ea43cf7e1bf9620e52607d45885e.sol"
    }
]