[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { if (balance[feeCollector] != 0) { uint256 fee = balance[feeCollector]; balance[feeCollector] = 0; feeCollector.call.value(fee)(); } uint256 amount = balance[msg.sender]; balance[msg.sender] = 0; msg.sender.transfer(amount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of low-level call to transfer Ether to feeCollector without proper checks introduces a reentrancy vulnerability. An attacker could exploit this by recursively calling withdraw before the state is updated, allowing them to drain funds from the contract.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    },
    {
        "function_name": "getBetAmount",
        "code": "function getBetAmount() private returns (uint256) { require (msg.value >= 100 finney); uint256 betAmount = msg.value; if (discountToken.balanceOf(msg.sender) == 0) { uint256 comission = betAmount * 4 / 100; betAmount -= comission; balance[feeCollector] += comission; } return betAmount; }",
        "vulnerability": "External call to untrusted contract",
        "reason": "The function calls discountToken.balanceOf, which is an external contract call. If the DiscountToken contract is malicious or compromised, it could interfere with the function's logic, potentially blocking bets or manipulating the commission calculation.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    },
    {
        "function_name": "burstBubble",
        "code": "function burstBubble() private { uint256 winner; if (marketCapBlue == marketCapRed) { winner = block.number % 2; } else if (marketCapBlue > marketCapRed) { winner = 0; } else { winner = 1; } depositBalance(winner); moonLevel = moonLevel * 2; addEvent(winner); marketCapBlue = 0; marketCapRed = 0; startBetBlue = bettorsBlue.length; startBetRed = bettorsRed.length; }",
        "vulnerability": "Block timestamp manipulation",
        "reason": "The function uses block.number % 2 to determine the winner in case of a tie in market caps. Miners can influence the block number to some extent, which could be exploited to favor one outcome over another, especially in high-stake situations.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    }
]