[
    {
        "function_name": "function ()",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 10 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100))); uint promo = msg.value*PROMO_PERCENT/100; PROMO.send(promo); pay(); } }",
        "vulnerability": "Use of send() for transferring Ether",
        "reason": "The fallback function uses the send() function to transfer Ether to the PROMO address and to depositors. The send() function only forwards 2300 gas, which might not be sufficient if the recipient is a contract with a non-trivial fallback function. This can lead to a failure in transferring Ether, potentially locking funds in the contract.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The pay() function uses send() to transfer Ether to depositors while iterating through the queue, but does not update the currentReceiverIndex until after all sends are completed. An attacker could potentially exploit this by re-entering the contract during the send(), causing the state to be manipulated unexpectedly, leading to incorrect payouts or depletion of contract funds.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "getDeposits",
        "code": "function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) { uint c = getDepositsCount(depositor); idxs = new uint[](c); deposits = new uint128[](c); expects = new uint128[](c); if(c > 0) { uint j = 0; for(uint i=currentReceiverIndex; i<queue.length; ++i){ Deposit storage dep = queue[i]; if(dep.depositor == depositor){ idxs[j] = i; deposits[j] = dep.deposit; expects[j] = dep.expect; j++; } } } }",
        "vulnerability": "Potential out-of-gas exception",
        "reason": "The getDeposits function iterates over the queue to find all deposits of a particular depositor. If the queue is large, this can lead to an out-of-gas exception. This can be exploited by attackers to cause a denial of service, preventing legitimate users from retrieving their deposit information.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    }
]