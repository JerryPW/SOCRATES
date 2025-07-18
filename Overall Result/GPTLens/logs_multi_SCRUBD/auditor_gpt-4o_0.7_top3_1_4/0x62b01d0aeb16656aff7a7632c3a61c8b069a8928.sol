[
    {
        "function_name": "function ()",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 10 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100))); uint promo = msg.value*PROMO_PERCENT/100; PROMO.send(promo); pay(); } }",
        "vulnerability": "Reentrancy",
        "reason": "The fallback function allows deposits and calls the pay() function after sending a portion of the funds to the PROMO address. The pay() function, which is called after PROMO.send(promo), makes external calls to dep.depositor.send(dep.expect) without updating the state variables before the call. This can be exploited by a reentrant contract to drain funds by re-entering the fallback function and forcing pay() to be called multiple times before the state updates, allowing more funds to be extracted than intended.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Potential Out-of-Gas Exception",
        "reason": "The pay() function iterates over the entire queue and attempts to send ether to each depositor. If the queue is large, this can consume a significant amount of gas, leading to an out-of-gas exception before the loop finishes. This can prevent payments from being processed correctly, leaving funds stuck in the contract.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Partial Payment Vulnerability",
        "reason": "If there is not enough balance to fulfill a user's full expected payment, the contract sends whatever is left in the balance, reducing the user's expected payment without any guarantee of getting the remaining owed amount later. This partial payment mechanism can lead to a situation where users receive less than they are owed, particularly if the contract's balance is exhausted quickly or if it cannot gather enough new deposits to fulfill promises, effectively turning the contract into a Ponzi scheme.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    }
]