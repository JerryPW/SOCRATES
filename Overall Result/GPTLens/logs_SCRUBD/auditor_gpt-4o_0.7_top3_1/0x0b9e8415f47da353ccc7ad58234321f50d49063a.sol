[
    {
        "function_name": "withdraw",
        "code": "function withdraw() external { uint256 payout = payoutAmount[_msgSender()]; payoutAmount[_msgSender()] = 0; (bool success, bytes memory data) = msg.sender.call{value: payout}(\"\"); require(success, \"Withdraw: Could not transact funds\"); }",
        "vulnerability": "Reentrancy",
        "reason": "The `withdraw` function is vulnerable to reentrancy attacks because it updates the state of `payoutAmount` after transferring Ether. An attacker could re-enter the function before the state update and drain funds.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    },
    {
        "function_name": "setTotalTokens",
        "code": "function setTotalTokens(uint256 numTokens) public onlyOwner { maximumTokens = numTokens; }",
        "vulnerability": "Potentially Unlimited Token Minting",
        "reason": "The `setTotalTokens` function allows the owner to arbitrarily change the `maximumTokens` value, potentially allowing for unlimited minting of tokens beyond the initial cap, which could be exploited by the contract owner.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    },
    {
        "function_name": "approvePayouts",
        "code": "function approvePayouts(uint256 purchaseAmount) internal { for (uint256 i; i < payees.length; i++){ payoutAmount[payees[i]] += (purchaseAmount * percPayout[payees[i]]) / 100; } }",
        "vulnerability": "Arithmetic Overflow",
        "reason": "The `approvePayouts` function does not use SafeMath for arithmetic operations, which may lead to overflow issues when calculating payouts, especially if the `purchaseAmount` is large or manipulated.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    }
]