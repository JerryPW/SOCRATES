[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { if (balance[feeCollector] != 0) { uint256 fee = balance[feeCollector]; balance[feeCollector] = 0; feeCollector.call.value(fee)(); } uint256 amount = balance[msg.sender]; balance[msg.sender] = 0; msg.sender.transfer(amount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function is vulnerable to reentrancy because it transfers Ether to msg.sender before updating the balance. An attacker could exploit this by recursively calling withdraw before the balance is updated, effectively draining the contract.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    },
    {
        "function_name": "getBetAmount",
        "code": "function getBetAmount() private returns (uint256) { require (msg.value >= 100 finney); uint256 betAmount = msg.value; if (discountToken.balanceOf(msg.sender) == 0) { uint256 comission = betAmount * 4 / 100; betAmount -= comission; balance[feeCollector] += comission; } return betAmount; }",
        "vulnerability": "ERC20 token balance query without checks",
        "reason": "The contract directly queries balanceOf on the DiscountToken without checking for its success or whether the DiscountToken is a valid ERC20 contract. This could lead to incorrect behavior if the DiscountToken contract is not compliant or if it has been replaced.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    },
    {
        "function_name": "burstBubble",
        "code": "function burstBubble() private { uint256 winner; if (marketCapBlue == marketCapRed) { winner = block.number % 2; } else if (marketCapBlue > marketCapRed) { winner = 0; } else { winner = 1; } depositBalance(winner); moonLevel = moonLevel * 2; addEvent(winner); marketCapBlue = 0; marketCapRed = 0; startBetBlue = bettorsBlue.length; startBetRed = bettorsRed.length; }",
        "vulnerability": "Integer overflow in moonLevel update",
        "reason": "The line moonLevel = moonLevel * 2; is susceptible to integer overflow. If moonLevel becomes large, multiplying by 2 could exceed the maximum value for a uint256, causing it to wrap around and potentially leading to incorrect game logic.",
        "file_name": "0x09f5f9413cefd61044db02940540155507bdcc55.sol"
    }
]