[
    {
        "function_name": "function()",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 10 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100))); uint promo = msg.value*PROMO_PERCENT/100; PROMO.send(promo); pay(); } }",
        "vulnerability": "DOS by sending to PROMO address",
        "reason": "The use of PROMO.send(promo) can cause a denial of service (DoS) for the entire contract if the PROMO address is a contract that consumes more than 2300 gas units or if it reverts. This can potentially block any further interactions with the contract, including deposits and withdrawals, as the fallback function will revert if PROMO.send fails.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of dep.depositor.send allows an attacker to execute a reentrancy attack by calling back into the contract during the send operation. Although .send only forwards 2300 gas, it does not protect against reentrancy in cases where the attacker's fallback function can perform effective operations within the gas limit, potentially disrupting the contract's logic or causing unintended side effects.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Gas limit DoS vulnerability",
        "reason": "The function iterates over the queue and tries to send expected amounts to depositors. However, if the gas cost of processing the entire queue is high, the loop can be broken prematurely with the gasleft() check, leading to a potential denial of service for those who are further down the queue, as they will not receive their payouts until enough gas is available to process the entire queue.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    }
]