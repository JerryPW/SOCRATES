[
    {
        "function_name": "withdrawPrize",
        "code": "function withdrawPrize() private { require(getCurrentStageByTime() >= 5); require(maxDepositInfo.count > 0, \"The max depositor is not confirmed yet\"); uint balance = address(this).balance; if(jackpotAmount > balance) jackpotAmount = balance; maxDepositInfo.depositor.send(jackpotAmount); selfdestruct(TECH); }",
        "vulnerability": "Use of send for Ether transfer",
        "reason": "The function uses `send` to transfer the jackpot to the depositor, which only forwards 2300 gas and fails silently on error. If the receiver is a contract with expensive fallback logic, the transfer can fail, potentially locking funds.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint balance = address(this).balance; uint128 money = 0; if(balance > (jackpotAmount)) money = uint128(balance - jackpotAmount); for(uint i=currentReceiverIndex; i<currentQueueSize; i++){ Deposit storage dep = queue[i]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[i]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex = i; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `pay` function sends Ether to depositors using `send`, which can fail and cause reentrancy issues if the depositor's fallback function is malicious. This could allow for manipulation of the contract's state, especially since the state is updated after the transfer.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    },
    {
        "function_name": "addDeposit",
        "code": "function addDeposit(address depositor, uint value) private { require(stage < 5); if(value > INVESTMENT){ depositor.transfer(value - INVESTMENT); value = INVESTMENT; } lastDepositInfo.index = uint128(currentQueueSize); lastDepositInfo.time = uint128(now); push(depositor, value, value*MULTIPLIER/100); depCount[depositor]++; uint count = depCount[depositor]; if(maxDepositInfo.count < count){ maxDepositInfo.count = count; maxDepositInfo.depositor = depositor; } jackpotAmount += value*(JACKPOT_PERCENT)/100; uint lastFund = value*LAST_FUND_PERCENT/100; LAST_FUND.send(lastFund); uint support = value*TECH_PERCENT/1000; TECH.send(support); uint adv = value*PROMO_PERCENT/1000; PROMO.send(adv); }",
        "vulnerability": "Arbitrary Ether loss and denial of service",
        "reason": "Using `send` to transfer funds to `LAST_FUND`, `TECH`, and `PROMO` can result in failed transactions if these addresses are contracts that reject the transfer, leading to a loss of Ether or a denial of service as the function does not handle failed sends.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    }
]