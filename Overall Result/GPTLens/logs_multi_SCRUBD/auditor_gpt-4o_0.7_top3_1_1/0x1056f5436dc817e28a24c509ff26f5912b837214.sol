[
    {
        "function_name": "claim",
        "code": "function claim() external { require(rejectedMintBalance[msg.sender] > 0); uint256 value = rejectedMintBalance[msg.sender]; rejectedMintBalance[msg.sender] = 0; msg.sender.transfer(value); emit Claimed(msg.sender, value); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The claim function is vulnerable to reentrancy because it transfers Ether to the caller before setting the balance to zero. An attacker could exploit this by recursively calling claim to drain funds.",
        "file_name": "0x1056f5436dc817e28a24c509ff26f5912b837214.sol"
    },
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(address beneficiary) public payable checkIsInvestorApproved(beneficiary) { require(validPurchase()); uint256 weiAmount = msg.value; uint256 tokens = weiAmount.mul(rate); pendingMints[currentMintNonce] = MintStruct(beneficiary, tokens, weiAmount); emit ContributionRegistered(beneficiary, tokens, weiAmount, currentMintNonce); currentMintNonce++; }",
        "vulnerability": "Lack of rate update protection",
        "reason": "The rate used to calculate token amounts in buyTokens can be updated by the owner without any restriction or notification to the investors. This could be exploited to change the rate unfairly after funds are sent but before tokens are minted.",
        "file_name": "0x1056f5436dc817e28a24c509ff26f5912b837214.sol"
    },
    {
        "function_name": "setTokenContract",
        "code": "function setTokenContract(address newToken) external onlyOwner checkIsAddressValid(newToken) { token = newToken; }",
        "vulnerability": "Token contract substitution",
        "reason": "The owner can change the token contract at any time, potentially substituting a malicious or faulty token contract. This can disrupt the intended behavior and security of the crowdsale.",
        "file_name": "0x1056f5436dc817e28a24c509ff26f5912b837214.sol"
    }
]