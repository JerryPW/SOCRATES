[
    {
        "function_name": "pay",
        "code": "function pay() private { uint balance = address(this).balance; uint128 money = 0; if(balance > (jackpotAmount)) money = uint128(balance - jackpotAmount); for(uint i=currentReceiverIndex; i<currentQueueSize; i++){ Deposit storage dep = queue[i]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[i]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex = i; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses 'send' which forwards only 2300 gas, but the loop continues to execute logic that can be manipulated if the 'send' fails or is re-entered. This could lead to unexpected behavior during the execution of the loop, especially if an attacker manages to change contract state during the execution.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    },
    {
        "function_name": "addDeposit",
        "code": "function addDeposit(address depositor, uint value) private { require(stage < 5); if(value > INVESTMENT){ depositor.transfer(value - INVESTMENT); value = INVESTMENT; } lastDepositInfo.index = uint128(currentQueueSize); lastDepositInfo.time = uint128(now); push(depositor, value, value*MULTIPLIER/100); depCount[depositor]++; uint count = depCount[depositor]; if(maxDepositInfo.count < count){ maxDepositInfo.count = count; maxDepositInfo.depositor = depositor; } jackpotAmount += value*(JACKPOT_PERCENT)/100; uint lastFund = value*LAST_FUND_PERCENT/100; LAST_FUND.send(lastFund); uint support = value*TECH_PERCENT/1000; TECH.send(support); uint adv = value*PROMO_PERCENT/1000; PROMO.send(adv); }",
        "vulnerability": "Unsafe external call with 'send'",
        "reason": "This function makes multiple external calls using 'send' without proper checks for success. If any of these calls fail, it could lead to unexpected behavior or loss of funds. Furthermore, because 'send' forwards only 2300 gas, it might not be sufficient for execution, and the function does not handle failures gracefully.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    },
    {
        "function_name": "withdrawPrize",
        "code": "function withdrawPrize() private { require(getCurrentStageByTime() >= 5); require(maxDepositInfo.count > 0, \"The max depositor is not confirmed yet\"); uint balance = address(this).balance; if(jackpotAmount > balance) jackpotAmount = balance; maxDepositInfo.depositor.send(jackpotAmount); selfdestruct(TECH); }",
        "vulnerability": "Loss of funds through selfdestruct",
        "reason": "The function calls 'selfdestruct', sending all remaining funds to the TECH address after sending the jackpot to the max depositor. If the TECH address is compromised or if the function is called unexpectedly, the funds can be permanently lost or sent to an unintended recipient.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    }
]