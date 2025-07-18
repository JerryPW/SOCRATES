[
    {
        "function_name": "function () public payable",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 10 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100))); uint promo = msg.value*PROMO_PERCENT/100; PROMO.send(promo); pay(); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function processes payments to the depositor via PROMO.send(promo) and dep.depositor.send(dep.expect) in the pay() function. If the receiver is a contract with a fallback function that calls back into the TopInvest125 contract, it can exploit the contract by reentering and manipulating the queue processing, potentially draining contract funds.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Integer overflow/underflow risk",
        "reason": "The queue index management and deposit calculations involve arithmetic operations which are not protected against overflows and underflows in Solidity version 0.4.25. Although unlikely due to uint128, if exploited, it could lead to incorrect calculations or unexpected behavior.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "function () public payable",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 10 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100))); uint promo = msg.value*PROMO_PERCENT/100; PROMO.send(promo); pay(); } }",
        "vulnerability": "DoS with Block Gas Limit",
        "reason": "The contract processes the entire queue in one transaction within the pay() function. If the queue grows too large, running out of gas becomes a risk, leading to a Denial of Service (DoS) situation where no further deposits or payouts can be processed.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    }
]