[
    {
        "function_name": "verify",
        "code": "function verify(address addr) public payable { if (msg.sender != owner()) { require(msg.value == verificationPrice); support.send(verificationPrice); } verified[addr] = true; emit RefVerified(addr); }",
        "vulnerability": "Unsafe external call using send",
        "reason": "The use of `send` for transferring ether to the support address may fail due to gas limit issues, potentially causing the transaction to revert or lose funds. An attacker could exploit this by making the support address a contract that consumes all gas, causing `send` to fail and preventing verification.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance - reserved); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; emit Payed(dep.depositor, dep.expect, cycles); delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; emit Payed(dep.depositor, money, cycles); break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Reentrancy vulnerability due to use of send",
        "reason": "The `pay` function sends ether to depositors using `send`, which limits gas and can lead to reentrancy attacks if the depositor is a contract implementing a fallback function. This can be exploited to drain funds or manipulate state variables like `currentReceiverIndex`.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    },
    {
        "function_name": "refunding",
        "code": "function refunding() private { uint128 refund = uint128(reserved); if (refund >= 1 ether) { refund -= 1 ether; } for(uint i=0; i<=currentRefundIndex; i++){ uint idx = currentRefundIndex.sub(i); Deposit storage dep = queue[idx]; if (lastCycle.sub(idx) <= 33) { uint percent = lastCycle - idx; } else { percent = 33; } uint128 amount = uint128(dep.deposit + (dep.deposit * percent / 100)); if(refund > amount){ dep.depositor.send(amount); refund -= amount; reserved -= amount; emit Refunded(dep.depositor, amount, cycles - 1); delete queue[idx]; }else{ dep.depositor.send(refund); reserved -= refund; currentRefundIndex = 0; emit Refunded(dep.depositor, refund, cycles - 1); emit RefundCompleted(cycles - 1); break; } if(gasleft() <= 100000) break; } if (currentRefundIndex != 0) { currentRefundIndex -= i; } }",
        "vulnerability": "Reentrancy vulnerability and logic error",
        "reason": "Similar to `pay`, the `refunding` function uses `send` to transfer ether, which can be exploited for reentrancy attacks if a depositor is a contract. Additionally, the logic has potential issues with reducing `reserved` and `refund` which could lead to improper refund calculations and potential loss of funds.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    }
]