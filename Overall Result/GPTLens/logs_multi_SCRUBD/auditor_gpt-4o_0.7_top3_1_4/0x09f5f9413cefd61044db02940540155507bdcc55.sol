[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { if (balance[feeCollector] != 0) { uint256 fee = balance[feeCollector]; balance[feeCollector] = 0; feeCollector.call.value(fee)(); } uint256 amount = balance[msg.sender]; balance[msg.sender] = 0; msg.sender.transfer(amount); }",
        "vulnerability": "Reentrancy vulnerability in withdraw function",
        "reason": "The withdraw function uses the low-level call without checking for its success, which makes the contract vulnerable to reentrancy attacks. An attacker can exploit this by recursively calling withdraw before the balance is set to zero, draining the contract's funds.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    },
    {
        "function_name": "getBetAmount",
        "code": "function getBetAmount() private returns (uint256) { require (msg.value >= 100 finney); uint256 betAmount = msg.value; if (discountToken.balanceOf(msg.sender) == 0) { uint256 comission = betAmount * 4 / 100; betAmount -= comission; balance[feeCollector] += comission; } return betAmount; }",
        "vulnerability": "Use of an outdated compiler version",
        "reason": "The contract uses Solidity version 0.4.24, which is outdated and lacks several safety features present in later versions, such as built-in overflow checks and improved syntax for handling external calls. This could lead to unexpected behavior or vulnerabilities due to compiler bugs or lack of modern security features.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    },
    {
        "function_name": "burstBubble",
        "code": "function burstBubble() private { uint256 winner; if (marketCapBlue == marketCapRed) { winner = block.number % 2; } else if (marketCapBlue > marketCapRed) { winner = 0; } else { winner = 1; } depositBalance(winner); moonLevel = moonLevel * 2; addEvent(winner); marketCapBlue = 0; marketCapRed = 0; startBetBlue = bettorsBlue.length; startBetRed = bettorsRed.length; }",
        "vulnerability": "Potential integer overflow in moonLevel",
        "reason": "The line 'moonLevel = moonLevel * 2;' is susceptible to integer overflow, which can cause the value to wrap around to zero or another unexpected value. This can lead to incorrect contract logic or denial of service when the moonLevel becomes unreasonably large or zero.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    }
]