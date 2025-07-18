[
    {
        "function_name": "withdraw",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is correct. The withdraw function updates the state after the external call, which indeed allows for a reentrancy attack. An attacker could exploit this by repeatedly calling the withdraw function before the state update, thus draining funds. The severity is high because it can lead to a complete loss of funds from the contract. The profitability is also high for an attacker who can exploit this vulnerability.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The withdraw function updates the state after the external call, which allows for a reentrancy attack. An attacker can exploit this by repeatedly calling the withdraw function before the state update, thus draining funds.",
        "code": "function withdraw() external { uint256 payout = payoutAmount[_msgSender()]; payoutAmount[_msgSender()] = 0; (bool success, bytes memory data) = msg.sender.call{value: payout}(\"\"); require(success, \"Withdraw: Could not transact funds\"); }",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol",
        "final_score": 8.5
    },
    {
        "function_name": "approvePayouts",
        "vulnerability": "Lack of validation on payout percentages",
        "criticism": "The reasoning is correct. The approvePayouts function does not validate the sum of percPayout values, which could indeed exceed 100%. This could lead to incorrect fund distribution and potential fund loss if the total payout exceeds the purchaseAmount. The severity is moderate because it can lead to financial discrepancies, and the profitability is low as it is more likely to cause operational issues rather than direct profit for an attacker.",
        "correctness": 8,
        "severity": 5,
        "profitability": 2,
        "reason": "The approvePayouts function does not validate the sum of percPayout values, which could exceed 100%. This could lead to incorrect fund distribution and potential fund loss if the total payout exceeds the purchaseAmount.",
        "code": "function approvePayouts(uint256 purchaseAmount) internal { for (uint256 i; i < payees.length; i++){ payoutAmount[payees[i]] += (purchaseAmount * percPayout[payees[i]]) / 100; } }",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol",
        "final_score": 5.75
    },
    {
        "function_name": "orderEmeejis",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is partially correct. While the function does have a reentrancy lock, the external call to return excess ether (cashChange) is made before the reentrancyLock is reset. However, the presence of the reentrancy lock significantly reduces the risk of reentrancy attacks unless there are other vulnerabilities in the contract. The severity is moderate because the reentrancy lock is in place, and the profitability is low unless other vulnerabilities are present.",
        "correctness": 6,
        "severity": 4,
        "profitability": 3,
        "reason": "Despite the reentrancy lock, the external call to return excess ether (cashChange) is made before reentrancyLock is reset. This could allow for reentrancy attacks if there are any other vulnerabilities in the contract that allow reentrant calls.",
        "code": "function orderEmeejis(uint256 orderSize) public payable { require(msg.value >= orderSize * tokenPrice, \"orderEmeejis: Insufficient Funds\"); require(orderSize <= purchaseLimit, \"orderEmeejis: Order Size too big\"); require(orderSize < maximumTokens - _reserveTokens - numberMinted, \"orderEmeejis: Not enough NFTs remaining to fill order\"); require(!orderLock, \"currently closed for business\"); require(!reentrancyLock); reentrancyLock = true; uint256 mintSeedValue = numberMinted; numberMinted += orderSize; uint256 cashIn = msg.value; uint256 cashChange = cashIn - (orderSize * tokenPrice); approvePayouts(cashIn); for(uint256 i = 0; i < orderSize; i++) { _safeMint(msg.sender, mintSeedValue + i); } if (cashChange > 0){ (bool success, bytes memory data) = msg.sender.call{value: cashChange}(\"\"); require(success, \"orderEmeejis: unable to send change to user\"); } reentrancyLock = false; }",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol",
        "final_score": 4.75
    }
]