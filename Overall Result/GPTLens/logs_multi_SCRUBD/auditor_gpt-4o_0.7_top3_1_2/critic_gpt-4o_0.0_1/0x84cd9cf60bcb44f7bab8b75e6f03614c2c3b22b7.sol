[
    {
        "function_name": "pay",
        "vulnerability": "Use of send() without handling failure",
        "criticism": "The reasoning is correct in identifying that the use of send() without checking its return value can lead to issues. If send() fails, the queue is not updated, which can block funds. This is a significant issue as it can lead to a denial of service for users waiting for their funds. The severity is high because it can block the entire queue, and the profitability is moderate because an attacker could potentially exploit this to disrupt the contract's operations.",
        "correctness": 8,
        "severity": 7,
        "profitability": 5,
        "reason": "The pay function uses the send() method to transfer ether, which only forwards 2300 gas and returns a boolean indicating success. However, the contract does not check the return value of send(), meaning if the transfer fails, the queue is not updated, potentially blocking funds in the contract.",
        "code": "function pay() private { uint balance = address(this).balance; uint128 money = 0; if(balance > (jackpotAmount)) money = uint128(balance - jackpotAmount); for(uint i=currentReceiverIndex; i<currentQueueSize; i++){ Deposit storage dep = queue[i]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[i]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex = i; }",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    },
    {
        "function_name": "addDeposit",
        "vulnerability": "Misuse of transfer() and send() without return checks",
        "criticism": "The reasoning correctly identifies the misuse of transfer() and send() without handling failures. This can lead to an inconsistent state if any of these calls fail, as the function does not revert. The severity is moderate because it can lead to partial fund loss or incorrect state, but it does not block the entire contract. The profitability is low because an attacker cannot directly profit from this, but it can cause operational issues.",
        "correctness": 8,
        "severity": 5,
        "profitability": 2,
        "reason": "The addDeposit function uses transfer() and send() to forward ether without handling failures. If any of these calls fail (e.g., if the recipient address is a contract with a fallback function that uses more than 2300 gas), the function will not revert, leading to an inconsistent state and potential loss of funds.",
        "code": "function addDeposit(address depositor, uint value) private { require(stage < 5); if(value > INVESTMENT){ depositor.transfer(value - INVESTMENT); value = INVESTMENT; } lastDepositInfo.index = uint128(currentQueueSize); lastDepositInfo.time = uint128(now); push(depositor, value, value*MULTIPLIER/100); depCount[depositor]++; uint count = depCount[depositor]; if(maxDepositInfo.count < count){ maxDepositInfo.count = count; maxDepositInfo.depositor = depositor; } jackpotAmount += value*(JACKPOT_PERCENT)/100; uint lastFund = value*LAST_FUND_PERCENT/100; LAST_FUND.send(lastFund); uint support = value*TECH_PERCENT/1000; TECH.send(support); uint adv = value*PROMO_PERCENT/1000; PROMO.send(adv); }",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    },
    {
        "function_name": "withdrawPrize",
        "vulnerability": "Immediate selfdestruct after send() without handling failure",
        "criticism": "The reasoning is correct in identifying the risk of calling selfdestruct immediately after a send() without checking its success. If the send() fails, the contract will still selfdestruct, potentially resulting in the loss of the jackpot amount. The severity is high because it can lead to a complete loss of funds intended for the max depositor. The profitability is moderate because an attacker could potentially exploit this to cause financial loss to the intended recipient.",
        "correctness": 9,
        "severity": 8,
        "profitability": 4,
        "reason": "The withdrawPrize function sends the jackpotAmount to the max depositor and then immediately calls selfdestruct. If the send() fails (e.g., due to the recipient's fallback function requiring more than 2300 gas), the send will not revert and the contract will still selfdestruct, potentially resulting in the loss of the jackpot amount.",
        "code": "function withdrawPrize() private { require(getCurrentStageByTime() >= 5); require(maxDepositInfo.count > 0, \"The max depositor is not confirmed yet\"); uint balance = address(this).balance; if(jackpotAmount > balance) jackpotAmount = balance; maxDepositInfo.depositor.send(jackpotAmount); selfdestruct(TECH); }",
        "file_name": "0x84cd9cf60bcb44f7bab8b75e6f03614c2c3b22b7.sol"
    }
]