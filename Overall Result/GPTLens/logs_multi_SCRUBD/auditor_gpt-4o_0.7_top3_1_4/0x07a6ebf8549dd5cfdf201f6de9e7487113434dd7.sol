[
    {
        "function_name": "verify",
        "code": "function verify(address addr) public payable { if (msg.sender != owner()) { require(msg.value == verificationPrice); support.send(verificationPrice); } verified[addr] = true; emit RefVerified(addr); }",
        "vulnerability": "Unsafe use of send function",
        "reason": "The use of the send function to transfer ether can lead to potential reentrancy attacks or failures due to gas limitations. The send function only forwards 2300 gas, which may not be enough for the fallback function of the recipient and could lead to failed transfers.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    },
    {
        "function_name": "refunding",
        "code": "function refunding() private { uint128 refund = uint128(reserved); if (refund >= 1 ether) { refund -= 1 ether; } for(uint i=0; i<=currentRefundIndex; i++){ uint idx = currentRefundIndex.sub(i); Deposit storage dep = queue[idx]; if (lastCycle.sub(idx) <= 33) { uint percent = lastCycle - idx; } else { percent = 33; } uint128 amount = uint128(dep.deposit + (dep.deposit * percent / 100)); if(refund > amount){ dep.depositor.send(amount); refund -= amount; reserved -= amount; emit Refunded(dep.depositor, amount, cycles - 1); delete queue[idx]; }else{ dep.depositor.send(refund); reserved -= refund; currentRefundIndex = 0; emit Refunded(dep.depositor, refund, cycles - 1); emit RefundCompleted(cycles - 1); break; } if(gasleft() <= 100000) break; } if (currentRefundIndex != 0) { currentRefundIndex -= i; } }",
        "vulnerability": "Reentrancy risk in send function",
        "reason": "The function uses the send method for transferring ether to user addresses, which can potentially be exploited for reentrancy attacks. An attacker could exploit this by creating a fallback function that calls back into the contract, potentially disrupting the normal flow and causing unexpected behavior.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance - reserved); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; emit Payed(dep.depositor, dep.expect, cycles); delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; emit Payed(dep.depositor, money, cycles); break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Potential denial of service with gas limit",
        "reason": "The function iteratively sends ether to depositors in the queue. If the gas left is insufficient, it can break out of the loop, potentially leaving some depositors unpaid. An attacker could exploit this by ensuring the contract's available gas during execution is low, causing the loop to terminate early and thereby delaying payments.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    }
]