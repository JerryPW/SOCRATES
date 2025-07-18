[
    {
        "function_name": "updateAd",
        "code": "function updateAd(uint256 id) public payable { require(msg.value >= adPriceMultiple.mul(adPriceHour)); require(block.timestamp > purchaseTimestamp.add(purchaseSeconds)); require(id > 0); theInvestor.send(msg.value.div(10)); lastOwner.send(msg.value.div(2)); if (msg.value >= adPriceMultiple.mul(adPriceWeek)) { purchaseSeconds = 604800; } else if (msg.value >= adPriceMultiple.mul(adPriceDay)) { purchaseSeconds = 86400; } else if (msg.value >= adPriceMultiple.mul(adPriceHalfDay)) { purchaseSeconds = 43200; } else { purchaseSeconds = 3600; } dappId = id; purchaseTimestamp = block.timestamp; lastOwner = msg.sender; }",
        "vulnerability": "Unsafe use of send() function",
        "reason": "The use of the send() function can lead to failures as it only forwards 2300 gas, which might not be enough for the receiving contract to execute further logic. This could prevent proper fund transfers, especially if the recipient is a contract with a non-trivial fallback function. Failure in send() does not revert the transaction, potentially leading to loss of funds or inconsistent state.",
        "file_name": "0x0d7c864bf6c86bf11da2c8068b4c4edee4d76080.sol"
    },
    {
        "function_name": "updateInvestor",
        "code": "function updateInvestor() public payable { require(msg.value >= investmentMin); theInvestor.send(msg.value.div(100).mul(60)); investmentMin = investmentMin.mul(2); theInvestor = msg.sender; }",
        "vulnerability": "Unsafe use of send() function",
        "reason": "Similar to the updateAd function, the use of send() can lead to a lack of assurance that funds were successfully transferred, as send() does not throw an error if the transfer fails. This could result in theInvestor address not receiving funds, leaving the contract in an inconsistent state.",
        "file_name": "0x0d7c864bf6c86bf11da2c8068b4c4edee4d76080.sol"
    },
    {
        "function_name": "setAdPriceMultiple",
        "code": "function setAdPriceMultiple(uint256 amount) public onlyContractOwner { adPriceMultiple = amount; }",
        "vulnerability": "Lack of input validation",
        "reason": "The function allows the contract owner to set adPriceMultiple to any value, including zero. This could potentially allow the contract owner to set the ad prices to zero, enabling free updates or very cheap updates to ad prices, which could be exploited to bypass intended pricing mechanisms.",
        "file_name": "0x0d7c864bf6c86bf11da2c8068b4c4edee4d76080.sol"
    }
]