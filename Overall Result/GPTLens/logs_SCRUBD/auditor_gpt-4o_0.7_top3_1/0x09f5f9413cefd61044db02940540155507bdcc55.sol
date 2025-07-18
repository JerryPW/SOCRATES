[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { if (balance[feeCollector] != 0) { uint256 fee = balance[feeCollector]; balance[feeCollector] = 0; feeCollector.call.value(fee)(); } uint256 amount = balance[msg.sender]; balance[msg.sender] = 0; msg.sender.transfer(amount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function does not use the Checks-Effects-Interactions pattern, allowing for reentrancy attacks. An attacker could exploit this by calling withdraw repeatedly before the balance is set to zero, draining the contract's funds.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    },
    {
        "function_name": "getBetAmount",
        "code": "function getBetAmount() private returns (uint256) { require (msg.value >= 100 finney); uint256 betAmount = msg.value; if (discountToken.balanceOf(msg.sender) == 0) { uint256 comission = betAmount * 4 / 100; betAmount -= comission; balance[feeCollector] += comission; } return betAmount; }",
        "vulnerability": "Potential miscalculation of commission",
        "reason": "The commission calculation might lead to inaccuracies due to integer division in Solidity, potentially causing unexpected results in the amount deducted. This could be exploited to manipulate the effective bet amount, impacting game fairness and payouts.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    },
    {
        "function_name": "burstBubble",
        "code": "function burstBubble() private { uint256 winner; if (marketCapBlue == marketCapRed) { winner = block.number % 2; } else if (marketCapBlue > marketCapRed) { winner = 0; } else { winner = 1; } depositBalance(winner); moonLevel = moonLevel * 2; addEvent(winner); marketCapBlue = 0; marketCapRed = 0; startBetBlue = bettorsBlue.length; startBetRed = bettorsRed.length; }",
        "vulnerability": "Predictable randomness",
        "reason": "The function uses block.number % 2 to determine the winner in case of a tie in market caps, which is predictable. An attacker could exploit this by timing their transactions to influence the outcome in their favor.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    }
]