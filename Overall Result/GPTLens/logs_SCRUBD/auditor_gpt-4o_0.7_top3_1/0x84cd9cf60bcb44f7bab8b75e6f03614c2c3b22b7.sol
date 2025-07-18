[
    {
        "function_name": "pay",
        "code": "function pay() private { uint balance = address(this).balance; uint128 money = 0; if(balance > (jackpotAmount)) money = uint128(balance - jackpotAmount); for(uint i=currentReceiverIndex; i<currentQueueSize; i++){ Deposit storage dep = queue[i]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[i]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex = i; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of `.send()` to transfer ether does not protect against reentrancy attacks. If the `depositor` is a contract, they could potentially execute code that calls back into the function before the `currentReceiverIndex` is updated. This could lead to multiple withdrawals by the same depositor.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    },
    {
        "function_name": "addDeposit",
        "code": "function addDeposit(address depositor, uint value) private { require(stage < 5); if(value > INVESTMENT){ depositor.transfer(value - INVESTMENT); value = INVESTMENT; } lastDepositInfo.index = uint128(currentQueueSize); lastDepositInfo.time = uint128(now); push(depositor, value, value*MULTIPLIER/100); depCount[depositor]++; uint count = depCount[depositor]; if(maxDepositInfo.count < count){ maxDepositInfo.count = count; maxDepositInfo.depositor = depositor; } jackpotAmount += value*(JACKPOT_PERCENT)/100; uint lastFund = value*LAST_FUND_PERCENT/100; LAST_FUND.send(lastFund); uint support = value*TECH_PERCENT/1000; TECH.send(support); uint adv = value*PROMO_PERCENT/1000; PROMO.send(adv); }",
        "vulnerability": "Improper handling of excess ether",
        "reason": "The contract attempts to refund excess ether by calling `depositor.transfer(value - INVESTMENT);`. If the transfer fails (e.g., due to the address being a contract that requires more gas), the transaction will revert, leading to potential denial of service.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    },
    {
        "function_name": "withdrawPrize",
        "code": "function withdrawPrize() private { require(getCurrentStageByTime() >= 5); require(maxDepositInfo.count > 0, \"The max depositor is not confirmed yet\"); uint balance = address(this).balance; if(jackpotAmount > balance) jackpotAmount = balance; maxDepositInfo.depositor.send(jackpotAmount); selfdestruct(TECH); }",
        "vulnerability": "Self-destruct vulnerability",
        "reason": "The function `withdrawPrize` executes a `selfdestruct` on the contract, sending all remaining funds to the address `TECH`. If an attacker can manipulate `getCurrentStageByTime()` such that it returns a value greater than or equal to 5, they can potentially trigger this function and destroy the contract, benefiting from all remaining balance.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    }
]