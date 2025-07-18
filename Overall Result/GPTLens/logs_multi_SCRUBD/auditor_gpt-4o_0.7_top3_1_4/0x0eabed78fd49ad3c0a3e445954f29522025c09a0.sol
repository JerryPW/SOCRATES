[
    {
        "function_name": "withdraw",
        "code": "function withdraw() external onlyOwner { uint balance = address(this).balance; msg.sender.transfer(balance); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdraw function transfers the entire balance of the contract to the caller (which is assumed to be the contract owner) without any reentrancy protection. An attacker could exploit this by causing the contract to repeatedly call withdraw and drain its funds if they manage to gain control over the contract's ownership. To mitigate this vulnerability, consider using a reentrancy guard or the checks-effects-interactions pattern.",
        "file_name": "0x0eabed78fd49ad3c0a3e445954f29522025c09a0.sol"
    },
    {
        "function_name": "mintWoai",
        "code": "function mintWoai(uint numberOfTokens) external payable { require(saleIsActive, \"Sale must be active to mint a WOAI\"); require(numberOfTokens <= maxWoaiPurchase, \"Can only mint 10 tokens at a time\"); require(totalSupply().add(numberOfTokens) <= MAX_WOAI, \"Purchase would exceed max supply of WOAI\"); require(woaiPrice.mul(numberOfTokens) <= msg.value, \"Transaction needs to be accompanied with Ether to mint a WOAI\"); for(uint i = 0; i < numberOfTokens; i++) { uint mintIndex = totalSupply(); if (totalSupply() < MAX_WOAI) { _safeMint(msg.sender, mintIndex); } } }",
        "vulnerability": "Lack of proper checks on payment",
        "reason": "The function checks if the total number of tokens exceeds the maximum supply and if the sent Ether is sufficient. However, it does not enforce the minimum Ether requirement per transaction if the number of tokens is less than maxWoaiPurchase, allowing an attacker to send insufficient Ether and still mint tokens. Ensure that the transaction reverts if the exact amount per token is not met.",
        "file_name": "0x0eabed78fd49ad3c0a3e445954f29522025c09a0.sol"
    },
    {
        "function_name": "mintAndRefer",
        "code": "function mintAndRefer(uint numberOfTokens, address referrer) external payable { require(saleIsActive, \"Sale must be active to mint a WOAI\"); require(numberOfTokens <= maxWoaiPurchase, \"Can only mint 10 tokens at a time\"); require(totalSupply().add(numberOfTokens) <= MAX_WOAI, \"Purchase would exceed max supply of WOAI\"); require(woaiPrice.mul(numberOfTokens) <= msg.value, \"Transaction needs to be accompanied with Ether to mint a WOAI\"); require(referrer != address(0), \"Zero address cannot be a referrer\"); for(uint i = 0; i < numberOfTokens; i++) { uint mintIndex = totalSupply(); _referAndMint(msg.sender, mintIndex, referrer); } }",
        "vulnerability": "Referrer manipulation",
        "reason": "The function allows specifying a referrer address, which is only checked to ensure it's a non-zero address. An attacker could specify themselves or an address they control as the referrer to manipulate referral counts and incentives. Implement additional logic to verify the authenticity of referrers and prevent abuse of the referral system.",
        "file_name": "0x0eabed78fd49ad3c0a3e445954f29522025c09a0.sol"
    }
]