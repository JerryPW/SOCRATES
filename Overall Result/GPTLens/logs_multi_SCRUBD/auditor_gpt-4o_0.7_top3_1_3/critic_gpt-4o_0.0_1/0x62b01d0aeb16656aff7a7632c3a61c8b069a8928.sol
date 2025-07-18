[
    {
        "function_name": "function()",
        "vulnerability": "DOS by sending to PROMO address",
        "criticism": "The reasoning is correct in identifying that using PROMO.send(promo) can lead to a denial of service if the PROMO address is a contract that consumes more than 2300 gas units or reverts. This is a valid concern because it can block further interactions with the contract, including deposits and withdrawals. The severity is moderate because it can halt contract operations, but it is not catastrophic as it depends on the behavior of the PROMO address. The profitability is low because an external attacker cannot directly profit from this vulnerability unless they control the PROMO address.",
        "correctness": 8,
        "severity": 5,
        "profitability": 1,
        "reason": "The use of PROMO.send(promo) can cause a denial of service (DoS) for the entire contract if the PROMO address is a contract that consumes more than 2300 gas units or if it reverts. This can potentially block any further interactions with the contract, including deposits and withdrawals, as the fallback function will revert if PROMO.send fails.",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 10 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100))); uint promo = msg.value*PROMO_PERCENT/100; PROMO.send(promo); pay(); } }",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "pay",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning correctly identifies the potential for a reentrancy attack due to the use of dep.depositor.send. However, the risk is mitigated by the fact that .send only forwards 2300 gas, which limits the operations that can be performed in a fallback function. While it is theoretically possible for an attacker to exploit this, the practical risk is low. The severity is low because the impact is limited by the gas constraint, and the profitability is also low due to the limited operations possible within the gas limit.",
        "correctness": 7,
        "severity": 3,
        "profitability": 2,
        "reason": "The use of dep.depositor.send allows an attacker to execute a reentrancy attack by calling back into the contract during the send operation. Although .send only forwards 2300 gas, it does not protect against reentrancy in cases where the attacker's fallback function can perform effective operations within the gas limit, potentially disrupting the contract's logic or causing unintended side effects.",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "pay",
        "vulnerability": "Gas limit DoS vulnerability",
        "criticism": "The reasoning is correct in identifying that the gasleft() check can lead to a denial of service for users further down the queue if the gas cost is too high to process the entire queue. This is a valid concern as it can delay payouts for some users. The severity is moderate because it affects the contract's ability to fulfill its obligations, but it does not lead to a complete halt of operations. The profitability is low because an external attacker cannot directly profit from this vulnerability.",
        "correctness": 8,
        "severity": 5,
        "profitability": 1,
        "reason": "The function iterates over the queue and tries to send expected amounts to depositors. However, if the gas cost of processing the entire queue is high, the loop can be broken prematurely with the gasleft() check, leading to a potential denial of service for those who are further down the queue, as they will not receive their payouts until enough gas is available to process the entire queue.",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    }
]