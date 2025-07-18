[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { if (balance[feeCollector] != 0) { uint256 fee = balance[feeCollector]; balance[feeCollector] = 0; feeCollector.call.value(fee)(); } uint256 amount = balance[msg.sender]; balance[msg.sender] = 0; msg.sender.transfer(amount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function allows for a reentrancy attack because it transfers ether to the caller via msg.sender.transfer(amount) before updating the user's balance to zero. An attacker can call withdraw recursively before the balance is updated, draining the contract.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    },
    {
        "function_name": "getBetAmount",
        "code": "function getBetAmount() private returns (uint256) { require (msg.value >= 100 finney); uint256 betAmount = msg.value; if (discountToken.balanceOf(msg.sender) == 0) { uint256 comission = betAmount * 4 / 100; betAmount -= comission; balance[feeCollector] += comission; } return betAmount; }",
        "vulnerability": "Arbitrary DiscountToken contract manipulation",
        "reason": "The contract relies on an external DiscountToken contract to determine if a commission should be applied. If the DiscountToken contract is malicious or compromised, it can return arbitrary values, potentially manipulating the betting conditions and leading to unpredictable outcomes for bettors.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    },
    {
        "function_name": "burstBubble",
        "code": "function burstBubble() private { uint256 winner; if (marketCapBlue == marketCapRed) { winner = block.number % 2; } else if (marketCapBlue > marketCapRed) { winner = 0; } else { winner = 1; } depositBalance(winner); moonLevel = moonLevel * 2; addEvent(winner); marketCapBlue = 0; marketCapRed = 0; startBetBlue = bettorsBlue.length; startBetRed = bettorsRed.length; }",
        "vulnerability": "Potential overflow vulnerability",
        "reason": "The moonLevel is doubled in the burstBubble function using moonLevel = moonLevel * 2. Without checks for overflow, moonLevel could exceed the maximum value for a uint256, causing unexpected behavior or an unintended reset of the moonLevel.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    }
]