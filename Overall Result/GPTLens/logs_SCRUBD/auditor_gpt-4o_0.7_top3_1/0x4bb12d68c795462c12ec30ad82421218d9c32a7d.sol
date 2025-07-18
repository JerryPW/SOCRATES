[
    {
        "function_name": "safeWithdrawal",
        "code": "function safeWithdrawal() afterDeadline { require(crowdsaleClosed); if (!fundingGoalReached) { uint amount = balanceOf[msg.sender]; balanceOf[msg.sender] = 0; if (amount > 0) { if (msg.sender.send(amount)) { FundTransfer(msg.sender, amount, false); } else { balanceOf[msg.sender] = amount; } } } if (fundingGoalReached && beneficiary == msg.sender) { if (beneficiary.send(amountRaised)) { FundTransfer(beneficiary, amountRaised, false); } else { fundingGoalReached = false; } } }",
        "vulnerability": "Reentrancy attack",
        "reason": "The use of msg.sender.send(amount) is vulnerable to reentrancy attacks as it sends ether before updating the state. An attacker could exploit this by recursively calling the safeWithdrawal function to drain funds.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    },
    {
        "function_name": "releaseTenPercent",
        "code": "function releaseTenPercent() afterDeadline { require(crowdsaleClosed); require(percent <= 90); if (fundingGoalReached && beneficiary == msg.sender) { percent += 10; } }",
        "vulnerability": "Incorrect access control",
        "reason": "The function allows the beneficiary to increase the percent arbitrarily by 10% after the crowdsale is closed. There's no cap or limit check beyond 90%, which could lead to logical errors or exploitation if used improperly.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    },
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale( address ifSuccessfulSendTo, uint fundingGoalInEthers, uint durationInMinutes, uint weiCostOfEachToken, address addressOfTokenUsedAsReward, uint initPercent ) { beneficiary = ifSuccessfulSendTo; fundingGoal = fundingGoalInEthers * 1 ether; deadline = now + durationInMinutes * 1 minutes; price = weiCostOfEachToken * 1 wei; tokenReward = token(addressOfTokenUsedAsReward); percent = initPercent; }",
        "vulnerability": "Lack of input validation",
        "reason": "The constructor does not validate inputs, such as checking if 'ifSuccessfulSendTo' is a valid address, 'fundingGoalInEthers' is non-zero, and 'initPercent' is within a valid range. This could lead to misconfiguration or deployment errors.",
        "file_name": "0x4bb12d68c795462c12ec30ad82421218d9c32a7d.sol"
    }
]