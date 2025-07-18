[
    {
        "function_name": "pay",
        "code": "function pay() private { uint balance = address(this).balance; uint128 money = 0; if(balance > (jackpotAmount)) money = uint128(balance - jackpotAmount); for(uint i=currentReceiverIndex; i<currentQueueSize; i++){ Deposit storage dep = queue[i]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[i]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex = i; }",
        "vulnerability": "Reentrancy vulnerability via send()",
        "reason": "The contract uses .send() to transfer Ether to the depositor, which provides only 2300 gas and doesn't handle errors properly. Moreover, the state changes occur after the Ether transfer, making it susceptible to a reentrancy attack. An attacker could reenter the contract and manipulate the queue or other variables before the state is updated.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    },
    {
        "function_name": "addDeposit",
        "code": "function addDeposit(address depositor, uint value) private { require(stage < 5); if(value > INVESTMENT){ depositor.transfer(value - INVESTMENT); value = INVESTMENT; } lastDepositInfo.index = uint128(currentQueueSize); lastDepositInfo.time = uint128(now); push(depositor, value, value*MULTIPLIER/100); depCount[depositor]++; uint count = depCount[depositor]; if(maxDepositInfo.count < count){ maxDepositInfo.count = count; maxDepositInfo.depositor = depositor; } jackpotAmount += value*(JACKPOT_PERCENT)/100; uint lastFund = value*LAST_FUND_PERCENT/100; LAST_FUND.send(lastFund); uint support = value*TECH_PERCENT/1000; TECH.send(support); uint adv = value*PROMO_PERCENT/1000; PROMO.send(adv); }",
        "vulnerability": "Reentrancy vulnerability via transfer() and send()",
        "reason": "The function performs Ether transfers using .transfer() and .send() before updating state variables. This can lead to a reentrancy attack where an attacker can reenter the contract during the transfer and drain funds or corrupt the queue state.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    },
    {
        "function_name": "withdrawPrize",
        "code": "function withdrawPrize() private { require(getCurrentStageByTime() >= 5); require(maxDepositInfo.count > 0, \"The max depositor is not confirmed yet\"); uint balance = address(this).balance; if(jackpotAmount > balance) jackpotAmount = balance; maxDepositInfo.depositor.send(jackpotAmount); selfdestruct(TECH); }",
        "vulnerability": "Potential denial of service by self-destruction",
        "reason": "This function allows the maxDepositInfo.depositor to trigger a self-destruct, which will send all the remaining funds to the TECH address. If the depositor's address is malicious or if the conditions for getting to stage 5 are manipulated, this could lead to premature contract termination and funds being inaccessible, especially if the depositor is an attacker.",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    }
]