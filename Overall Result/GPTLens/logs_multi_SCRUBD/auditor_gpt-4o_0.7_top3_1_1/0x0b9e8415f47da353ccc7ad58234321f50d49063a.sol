[
    {
        "function_name": "orderEmeejis",
        "code": "function orderEmeejis(uint256 orderSize) public payable { require(msg.value >= orderSize * tokenPrice, \"orderEmeejis: Insufficient Funds\"); require(orderSize <= purchaseLimit, \"orderEmeejis: Order Size too big\"); require(orderSize < maximumTokens - _reserveTokens - numberMinted, \"orderEmeejis: Not enough NFTs remaining to fill order\"); require(!orderLock, \"currently closed for business\"); require(!reentrancyLock); reentrancyLock = true; uint256 mintSeedValue = numberMinted; numberMinted += orderSize; uint256 cashIn = msg.value; uint256 cashChange = cashIn - (orderSize * tokenPrice); approvePayouts(cashIn); for(uint256 i = 0; i < orderSize; i++) { _safeMint(msg.sender, mintSeedValue + i); } if (cashChange > 0){ (bool success, bytes memory data) = msg.sender.call{value: cashChange}(\"\"); require(success, \"orderEmeejis: unable to send change to user\"); } reentrancyLock = false; }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function `orderEmeejis` sets `reentrancyLock` to true at the beginning of the function to prevent reentrancy. However, the function makes an external call to `msg.sender.call` to refund excess ETH, which could allow reentrancy. The `reentrancyLock` should be set back to false before making external calls to ensure the lock is properly enforced.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() external { uint256 payout = payoutAmount[_msgSender()]; payoutAmount[_msgSender()] = 0; (bool success, bytes memory data) = msg.sender.call{value: payout}(\"\"); require(success, \"Withdraw: Could not transact funds\"); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The `withdraw` function is vulnerable to reentrancy attacks. After transferring the payout to the caller using `msg.sender.call`, there is no check to ensure reentrancy is not possible, allowing a malicious contract to potentially re-enter and drain funds before the payout amount is set to zero.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    },
    {
        "function_name": "approvePayouts",
        "code": "function approvePayouts(uint256 purchaseAmount) internal { for (uint256 i; i < payees.length; i++){ payoutAmount[payees[i]] += (purchaseAmount * percPayout[payees[i]]) / 100; } }",
        "vulnerability": "Arithmetic Overflow/Underflow",
        "reason": "The `approvePayouts` function does not have checks for arithmetic overflow/underflow when calculating `payoutAmount[payees[i]] += (purchaseAmount * percPayout[payees[i]]) / 100;`. Although Solidity 0.8.0 introduces built-in overflow/underflow checks, ensuring proper handling and checks when updating financial balances is a best practice to prevent unexpected behavior in older versions or other contexts.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    }
]