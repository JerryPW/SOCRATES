[
    {
        "function_name": "verify",
        "code": "function verify(address addr) public payable { if (msg.sender != owner()) { require(msg.value == verificationPrice); support.send(verificationPrice); } verified[addr] = true; emit RefVerified(addr); }",
        "vulnerability": "Use of 'send' without checking result",
        "reason": "The function uses 'support.send(verificationPrice)' to transfer Ether, which only forwards 2300 gas and does not check the result of the send operation. This can lead to loss of funds if the 'send' fails, as the contract does not handle the failure case, and the verification proceeds even if the payment to 'support' fails.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance - reserved); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; emit Payed(dep.depositor, dep.expect, cycles); delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; emit Payed(dep.depositor, money, cycles); break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of 'dep.depositor.send' can be exploited by an attacker to create a reentrancy attack. The attacker can re-enter the contract before the state variable 'currentReceiverIndex' is updated, potentially leading to multiple withdrawals and loss of funds.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    },
    {
        "function_name": "refunding",
        "code": "function refunding() private { uint128 refund = uint128(reserved); if (refund >= 1 ether) { refund -= 1 ether; } for(uint i=0; i<=currentRefundIndex; i++){ uint idx = currentRefundIndex.sub(i); Deposit storage dep = queue[idx]; if (lastCycle.sub(idx) <= 33) { uint percent = lastCycle - idx; } else { percent = 33; } uint128 amount = uint128(dep.deposit + (dep.deposit * percent / 100)); if(refund > amount){ dep.depositor.send(amount); refund -= amount; reserved -= amount; emit Refunded(dep.depositor, amount, cycles - 1); delete queue[idx]; }else{ dep.depositor.send(refund); reserved -= refund; currentRefundIndex = 0; emit Refunded(dep.depositor, refund, cycles - 1); emit RefundCompleted(cycles - 1); break; } if(gasleft() <= 100000) break; } if (currentRefundIndex != 0) { currentRefundIndex -= i; } }",
        "vulnerability": "Incorrect handling of refund logic",
        "reason": "The refunding logic can be manipulated by an attacker to drain more funds than intended. It calculates the refund amount based on 'reserved', but does not adequately handle scenarios where 'reserved' is insufficient to cover the refund, leading to potential inconsistencies and fund loss.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    }
]