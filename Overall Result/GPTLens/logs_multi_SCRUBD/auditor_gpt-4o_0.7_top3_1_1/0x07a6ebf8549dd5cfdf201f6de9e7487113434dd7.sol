[
    {
        "function_name": "verify",
        "code": "function verify(address addr) public payable { if (msg.sender != owner()) { require(msg.value == verificationPrice); support.send(verificationPrice); } verified[addr] = true; emit RefVerified(addr); }",
        "vulnerability": "Unsafe use of send function",
        "reason": "The use of `send` to transfer funds to the `support` address can lead to reentrancy issues or failing transactions if the gas limit is exceeded. `send` only forwards 2300 gas, which may not be sufficient for all operations in the recipient contract. Instead, using `transfer` or `call` with a gas limit check would be safer.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance - reserved); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; emit Payed(dep.depositor, dep.expect, cycles); delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; emit Payed(dep.depositor, money, cycles); break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `pay` function uses `send` to transfer funds to depositors, which could lead to reentrancy attacks if a malicious contract is used as a depositor. The contract should update the depositor's balance before making a call to an external address to prevent reentrancy.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    },
    {
        "function_name": "refunding",
        "code": "function refunding() private { uint128 refund = uint128(reserved); if (refund >= 1 ether) { refund -= 1 ether; } for(uint i=0; i<=currentRefundIndex; i++){ uint idx = currentRefundIndex.sub(i); Deposit storage dep = queue[idx]; if (lastCycle.sub(idx) <= 33) { uint percent = lastCycle - idx; } else { percent = 33; } uint128 amount = uint128(dep.deposit + (dep.deposit * percent / 100)); if(refund > amount){ dep.depositor.send(amount); refund -= amount; reserved -= amount; emit Refunded(dep.depositor, amount, cycles - 1); delete queue[idx]; }else{ dep.depositor.send(refund); reserved -= refund; currentRefundIndex = 0; emit Refunded(dep.depositor, refund, cycles - 1); emit RefundCompleted(cycles - 1); break; } if(gasleft() <= 100000) break; } if (currentRefundIndex != 0) { currentRefundIndex -= i; } }",
        "vulnerability": "Reentrancy vulnerability and logic error",
        "reason": "The `refunding` function is vulnerable to reentrancy attacks due to the use of `send` for transferring funds. Additionally, the logic does not account for partial refunding correctly, which could lead to funds being locked if the refund amount is insufficient.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    }
]