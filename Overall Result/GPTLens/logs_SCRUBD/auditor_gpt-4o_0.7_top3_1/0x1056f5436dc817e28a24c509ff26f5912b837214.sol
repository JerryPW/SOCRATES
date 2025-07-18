[
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(address beneficiary) public payable checkIsInvestorApproved(beneficiary) { require(validPurchase()); uint256 weiAmount = msg.value; uint256 tokens = weiAmount.mul(rate); pendingMints[currentMintNonce] = MintStruct(beneficiary, tokens, weiAmount); emit ContributionRegistered(beneficiary, tokens, weiAmount, currentMintNonce); currentMintNonce++; }",
        "vulnerability": "Denial of service via pendingMints",
        "reason": "There is no limit on the number of pending mints that can be added to the 'pendingMints' mapping. An attacker could potentially fill this mapping with a large number of entries, resulting in high gas costs for maintaining the state or causing out of gas errors for functions that iterate over pending mints.",
        "file_name": "0x1056f5436dc817e28a24c509ff26f5912b837214.sol"
    },
    {
        "function_name": "claim",
        "code": "function claim() external { require(rejectedMintBalance[msg.sender] > 0); uint256 value = rejectedMintBalance[msg.sender]; rejectedMintBalance[msg.sender] = 0; msg.sender.transfer(value); emit Claimed(msg.sender, value); }",
        "vulnerability": "Reentrancy attack",
        "reason": "The 'claim' function sends Ether before updating the state variable 'rejectedMintBalance'. This opens up a potential reentrancy attack, where an attacker can call 'claim' recursively to drain the contract's balance before the state is updated.",
        "file_name": "0x1056f5436dc817e28a24c509ff26f5912b837214.sol"
    },
    {
        "function_name": "rejectMint",
        "code": "function _rejectMint(uint256 nonce, uint256 reason) private checkIsAddressValid(pendingMints[nonce].to) { rejectedMintBalance[pendingMints[nonce].to] = rejectedMintBalance[pendingMints[nonce].to].add(pendingMints[nonce].weiAmount); emit MintRejected( pendingMints[nonce].to, pendingMints[nonce].tokens, pendingMints[nonce].weiAmount, nonce, reason ); delete pendingMints[nonce]; }",
        "vulnerability": "Lack of protection against duplicate rejection",
        "reason": "The '_rejectMint' function does not check if a mint with the given 'nonce' has already been rejected or approved. This could lead to double counting of 'rejectedMintBalance' if '_rejectMint' is called multiple times with the same nonce.",
        "file_name": "0x1056f5436dc817e28a24c509ff26f5912b837214.sol"
    }
]