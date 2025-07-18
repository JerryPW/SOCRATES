[
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale( address ifSuccessfulSendTo, uint fundingGoalInEthers, uint durationInMinutes, uint etherCostOfEachToken, address addressOfTokenUsedAsReward ) { beneficiary = ifSuccessfulSendTo; fundingGoal = fundingGoalInEthers * 1 ether; deadline = now + durationInMinutes * 1 minutes; price = etherCostOfEachToken * 1 ether; tokenReward = token(addressOfTokenUsedAsReward); }",
        "vulnerability": "Constructor does not use function modifier",
        "reason": "The constructor function is defined without the `function` keyword, which is not supported in Solidity version 0.4.18, potentially leading to unintended behavior or deployment issues.",
        "file_name": "0xb48e28b7de69e921e37c9786f11a6f73274777ef.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount / price); beneficiary.send(amountRaised); amountRaised = 0; FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `beneficiary.send(amountRaised);` statement is vulnerable to reentrancy attacks since it transfers Ether before resetting the `amountRaised` variable. An attacker could exploit this by repeatedly calling the fallback function and draining funds, as the state update occurs after the transfer.",
        "file_name": "0xb48e28b7de69e921e37c9786f11a6f73274777ef.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; tokenReward.transfer(msg.sender, amount / price); beneficiary.send(amountRaised); amountRaised = 0; FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "No validation on token transfer",
        "reason": "The `tokenReward.transfer(msg.sender, amount / price);` call does not check the return value of the transfer function. If the transfer fails, the transaction will still proceed without reverting, potentially leading to discrepancies in token distribution.",
        "file_name": "0xb48e28b7de69e921e37c9786f11a6f73274777ef.sol"
    }
]