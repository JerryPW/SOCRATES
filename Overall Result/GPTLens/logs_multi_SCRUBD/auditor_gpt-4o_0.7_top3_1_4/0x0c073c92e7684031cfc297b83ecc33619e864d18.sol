[
    {
        "function_name": "acceptNextOwner",
        "code": "function acceptNextOwner() external { require (msg.sender == nextOwner, \"Can only accept preapproved new owner.\"); owner = nextOwner; }",
        "vulnerability": "Unrestricted access to ownership transfer",
        "reason": "The function allows the 'nextOwner' to become the 'owner' without any additional checks such as confirmation from the current owner. This can lead to unauthorized transfers of contract ownership if 'nextOwner' is set to a malicious address or if the 'approveNextOwner' function is exploited.",
        "file_name": "0x0c073c92e7684031cfc297b83ecc33619e864d18.sol"
    },
    {
        "function_name": "setNewPercents",
        "code": "function setNewPercents( uint8 newHouseEdgePercent, uint8 newDividendsPercent, uint8 newAdvertPercent ) external onlyOwner { require(newDividendsPercent >= 5); require(newHouseEdgePercent + newDividendsPercent + newAdvertPercent <= 30); HOUSE_EDGE_PERCENT = newHouseEdgePercent; ADVERTISE_PERCENT = newAdvertPercent; DIVIDENDS_PERCENT = newDividendsPercent; }",
        "vulnerability": "Potential for setting low house edge",
        "reason": "The function allows the owner to set the house edge to zero or very low values, which could lead to the contract being financially unsustainable. The only constraint is that the sum of percentages must not exceed 30, but there is no minimum house edge enforcement.",
        "file_name": "0x0c073c92e7684031cfc297b83ecc33619e864d18.sol"
    },
    {
        "function_name": "sendFunds",
        "code": "function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint commit, string memory paymentType) private { if (beneficiary.send(amount)) { emit Payment(beneficiary, commit, successLogAmount, paymentType); } else { emit FailedPayment(beneficiary, commit, amount, paymentType); } }",
        "vulnerability": "Usage of send() method without error handling",
        "reason": "The 'sendFunds' function uses the 'send()' method to transfer funds, which only forwards 2300 gas and fails silently if the transfer fails. This can lead to loss of funds or failure to execute critical logic if the transfer fails, as there is no retry mechanism or alternative logic implemented.",
        "file_name": "0x0c073c92e7684031cfc297b83ecc33619e864d18.sol"
    }
]