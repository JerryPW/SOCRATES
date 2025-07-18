[
    {
        "function_name": "orderEmeejis",
        "code": "function orderEmeejis(uint256 orderSize) public payable { require(msg.value >= orderSize * tokenPrice, \"orderEmeejis: Insufficient Funds\"); require(orderSize <= purchaseLimit, \"orderEmeejis: Order Size too big\"); require(orderSize < maximumTokens - _reserveTokens - numberMinted, \"orderEmeejis: Not enough NFTs remaining to fill order\"); require(!orderLock, \"currently closed for business\"); require(!reentrancyLock); reentrancyLock = true; uint256 mintSeedValue = numberMinted; numberMinted += orderSize; uint256 cashIn = msg.value; uint256 cashChange = cashIn - (orderSize * tokenPrice); approvePayouts(cashIn); for(uint256 i = 0; i < orderSize; i++) { _safeMint(msg.sender, mintSeedValue + i); } if (cashChange > 0){ (bool success, bytes memory data) = msg.sender.call{value: cashChange}(\"\"); require(success, \"orderEmeejis: unable to send change to user\"); } reentrancyLock = false; }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The `orderEmeejis` function is vulnerable to reentrancy attacks due to the external call `msg.sender.call{value: cashChange}(\"\")` before setting `reentrancyLock` back to false. An attacker could exploit this by re-entering the function during this external call, potentially allowing them to mint more NFTs than intended or drain funds.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() external { uint256 payout = payoutAmount[_msgSender()]; payoutAmount[_msgSender()] = 0; (bool success, bytes memory data) = msg.sender.call{value: payout}(\"\"); require(success, \"Withdraw: Could not transact funds\"); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The `withdraw` function zeroes out the `payoutAmount` balance after making an external call to `msg.sender.call{value: payout}(\"\")`. This opens up the contract to a reentrancy attack, allowing an attacker to re-enter the function and withdraw more funds than they are entitled to before their balance is set to zero.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    },
    {
        "function_name": "approvePayouts",
        "code": "function approvePayouts(uint256 purchaseAmount) internal { for (uint256 i; i < payees.length; i++){ payoutAmount[payees[i]] += (purchaseAmount * percPayout[payees[i]]) / 100; } }",
        "vulnerability": "Arithmetic Overflow/Underflow",
        "reason": "The `approvePayouts` function does not perform checks for arithmetic overflows or underflows when calculating `payoutAmount[payees[i]] += (purchaseAmount * percPayout[payees[i]]) / 100;`. This could lead to incorrect payouts if the `purchaseAmount` or `percPayout` values are manipulated. Although Solidity 0.8+ has built-in overflow checks, it is good practice to explicitly ensure proper handling.",
        "file_name": "0x0b9e8415f47da353ccc7ad58234321f50d49063a.sol"
    }
]