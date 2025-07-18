[
    {
        "function_name": "function () payable stopOnPause",
        "code": "function () payable stopOnPause{ require(now < deadline); require(msg.value >= minInvestment); uint amount = msg.value; ethBalances[msg.sender] += amount; weiRaised += amount; if(!fundingGoalReached && weiRaised >= fundingGoal){goalReached();} uint ABIOAmount = amount / weiPerABIO ; abioToken.transfer(msg.sender, ABIOAmount); abioSold += ABIOAmount; emit FundsReceived(msg.sender, amount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function transfers ABIO tokens to the sender using the `transfer` function from the `ABIO_Token` interface. If the `transfer` function calls external code, it can result in a reentrancy attack, where the attacker can repeatedly call the fallback function and drain funds or alter the contract's state unexpectedly. This is especially problematic since the `ethBalances` and `weiRaised` are updated before the token transfer, which can be exploited in a reentrancy scenario.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline stopOnPause{ if (!fundingGoalReached) { uint amount = ethBalances[msg.sender]; ethBalances[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { emit FundsWithdrawn(msg.sender, amount); } else { ethBalances[msg.sender] = amount; } } } else if (fundingGoalReached) { require(treasury == msg.sender); if (treasury.send(weiRaised)) { emit FundsWithdrawn(treasury, weiRaised); } else if (treasury.send(address(this).balance)){ emit FundsWithdrawn(treasury, address(this).balance); } } }",
        "vulnerability": "Use of deprecated `send` function",
        "reason": "The `send` function is used to transfer Ether, which returns a boolean indicating success or failure but does not throw an exception on failure. If the transfer fails, the contract attempts to restore the balance, but this can still cause issues such as reentrancy, especially if an attacker can manipulate gas costs or if the fallback function of the recipient conducts complex operations.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    },
    {
        "function_name": "adjustPrice",
        "code": "function adjustPrice(uint _multiplier) external onlyOwner{ require(_multiplier < 400 && _multiplier > 25); minInvestment = minInvestment * _multiplier / 100; weiPerABIO = weiPerABIO * _multiplier / 100; emit PriceAdjust(msg.sender, _multiplier, minInvestment, weiPerABIO); }",
        "vulnerability": "Arbitrary price manipulation",
        "reason": "The `adjustPrice` function allows the owner to arbitrarily adjust the price of tokens by setting the `_multiplier`. Due to the lack of constraints on how `minInvestment` and `weiPerABIO` relate to market conditions or previous investments, the owner can manipulate these values in a way that could disadvantage investors or result in significant market distortion, potentially allowing manipulation of the ICO outcome.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    }
]