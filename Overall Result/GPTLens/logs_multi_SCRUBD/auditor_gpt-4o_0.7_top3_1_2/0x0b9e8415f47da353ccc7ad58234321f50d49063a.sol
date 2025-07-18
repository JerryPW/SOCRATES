[
    {
        "function_name": "withdraw",
        "code": "function withdraw() external { uint256 payout = payoutAmount[_msgSender()]; payoutAmount[_msgSender()] = 0; (bool success, bytes memory data) = msg.sender.call{value: payout}(\"\"); require(success, \"Withdraw: Could not transact funds\"); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function updates the state after the external call, which allows for a reentrancy attack. An attacker can exploit this by repeatedly calling the withdraw function before the state update, thus draining funds.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    },
    {
        "function_name": "orderEmeejis",
        "code": "function orderEmeejis(uint256 orderSize) public payable { require(msg.value >= orderSize * tokenPrice, \"orderEmeejis: Insufficient Funds\"); require(orderSize <= purchaseLimit, \"orderEmeejis: Order Size too big\"); require(orderSize < maximumTokens - _reserveTokens - numberMinted, \"orderEmeejis: Not enough NFTs remaining to fill order\"); require(!orderLock, \"currently closed for business\"); require(!reentrancyLock); reentrancyLock = true; uint256 mintSeedValue = numberMinted; numberMinted += orderSize; uint256 cashIn = msg.value; uint256 cashChange = cashIn - (orderSize * tokenPrice); approvePayouts(cashIn); for(uint256 i = 0; i < orderSize; i++) { _safeMint(msg.sender, mintSeedValue + i); } if (cashChange > 0){ (bool success, bytes memory data) = msg.sender.call{value: cashChange}(\"\"); require(success, \"orderEmeejis: unable to send change to user\"); } reentrancyLock = false; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Despite the reentrancy lock, the external call to return excess ether (cashChange) is made before reentrancyLock is reset. This could allow for reentrancy attacks if there are any other vulnerabilities in the contract that allow reentrant calls.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    },
    {
        "function_name": "approvePayouts",
        "code": "function approvePayouts(uint256 purchaseAmount) internal { for (uint256 i; i < payees.length; i++){ payoutAmount[payees[i]] += (purchaseAmount * percPayout[payees[i]]) / 100; } }",
        "vulnerability": "Lack of validation on payout percentages",
        "reason": "The approvePayouts function does not validate the sum of percPayout values, which could exceed 100%. This could lead to incorrect fund distribution and potential fund loss if the total payout exceeds the purchaseAmount.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    }
]