[
    {
        "function_name": "orderEmeejis",
        "code": "function orderEmeejis(uint256 orderSize) public payable { require(msg.value >= orderSize * tokenPrice, \"orderEmeejis: Insufficient Funds\"); require(orderSize <= purchaseLimit, \"orderEmeejis: Order Size too big\"); require(orderSize < maximumTokens - _reserveTokens - numberMinted, \"orderEmeejis: Not enough NFTs remaining to fill order\"); require(!orderLock, \"currently closed for business\"); require(!reentrancyLock); reentrancyLock = true; uint256 mintSeedValue = numberMinted; numberMinted += orderSize; uint256 cashIn = msg.value; uint256 cashChange = cashIn - (orderSize * tokenPrice); approvePayouts(cashIn); for(uint256 i = 0; i < orderSize; i++) { _safeMint(msg.sender, mintSeedValue + i); } if (cashChange > 0){ (bool success, bytes memory data) = msg.sender.call{value: cashChange}(\"\"); require(success, \"orderEmeejis: unable to send change to user\"); } reentrancyLock = false; }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function orderEmeejis uses a non-reentrant lock (reentrancyLock) but does not properly guard against reentrancy before the external call to send change back to the user. An attacker could reenter before reentrancyLock is reset, potentially allowing them to mint more tokens than intended or manipulate the minting process.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() external { uint256 payout = payoutAmount[_msgSender()]; payoutAmount[_msgSender()] = 0; (bool success, bytes memory data) = msg.sender.call{value: payout}(\"\"); require(success, \"Withdraw: Could not transact funds\"); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The withdraw function sets the payoutAmount to zero after the transfer call, allowing for reentrancy. An attacker can reenter the function after the call to msg.sender.call{value: payout}(\"\") and before the payoutAmount is set to zero, allowing them to withdraw more funds than their allocated payout.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    },
    {
        "function_name": "approvePayouts",
        "code": "function approvePayouts(uint256 purchaseAmount) internal { for (uint256 i; i < payees.length; i++){ payoutAmount[payees[i]] += (purchaseAmount * percPayout[payees[i]]) / 100; } }",
        "vulnerability": "Integer Overflow/Underflow",
        "reason": "The approvePayouts function directly modifies the payoutAmount mappings based on percPayout percentages without proper checks. If percPayout is manipulated to be a very large value or purchaseAmount is large, this could lead to integer overflow, potentially allowing attackers to allocate more funds than intended.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    }
]