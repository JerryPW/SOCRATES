[
    {
        "function_name": "function () payable",
        "code": "function () payable stopOnPause{ require(now < deadline); require(msg.value >= minInvestment); uint amount = msg.value; ethBalances[msg.sender] += amount; weiRaised += amount; if(!fundingGoalReached && weiRaised >= fundingGoal){goalReached();} uint ABIOAmount = amount / weiPerABIO ; abioToken.transfer(msg.sender, ABIOAmount); abioSold += ABIOAmount; emit FundsReceived(msg.sender, amount); }",
        "vulnerability": "Reentrancy vulnerability in fallback function",
        "reason": "The fallback function does not follow the checks-effects-interactions pattern. After the state changes, it calls the external function 'abioToken.transfer'. An attacker could exploit this by reentering the function and manipulating the state variables 'ethBalances', 'weiRaised', and 'abioSold' by using a reentrancy attack.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    },
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline stopOnPause{ if (!fundingGoalReached) { uint amount = ethBalances[msg.sender]; ethBalances[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { emit FundsWithdrawn(msg.sender, amount); } else { ethBalances[msg.sender] = amount; } } } else if (fundingGoalReached) { require(treasury == msg.sender); if (treasury.send(weiRaised)) { emit FundsWithdrawn(treasury, weiRaised); } else if (treasury.send(address(this).balance)){ emit FundsWithdrawn(treasury, address(this).balance); } } }",
        "vulnerability": "Use of deprecated 'send' function",
        "reason": "The 'send' function is used to transfer funds, which only forwards 2300 gas and does not throw an error if the transaction fails. This can lead to failed transfers if the gas limit is exceeded or the recipient's fallback function requires more than 2300 gas, potentially causing funds to be locked in the contract.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    },
    {
        "function_name": "adjustPrice",
        "code": "function adjustPrice(uint _multiplier) external onlyOwner{ require(_multiplier < 400 && _multiplier > 25); minInvestment = minInvestment * _multiplier / 100; weiPerABIO = weiPerABIO * _multiplier / 100; emit PriceAdjust(msg.sender, _multiplier, minInvestment, weiPerABIO); }",
        "vulnerability": "Lack of validation for price adjustment",
        "reason": "The 'adjustPrice' function allows the owner to drastically change the 'minInvestment' and 'weiPerABIO' values without any restrictions on the new values. This could lead to unreasonably low prices and minimum investments, enabling manipulation of the ICO terms for personal gain or to the detriment of investors.",
        "file_name": "0x530a9cceee0c45f58229ae5c256e414e6df957ad.sol"
    }
]