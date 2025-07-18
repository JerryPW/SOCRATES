[
    {
        "function_name": "withdraw",
        "code": "function withdraw() external onlyOwner { uint balance = address(this).balance; msg.sender.transfer(balance); }",
        "vulnerability": "Unsafe Ether transfer",
        "reason": "The transfer function is used to send Ether, which can fail if the call stack grows too deep or the recipient contract runs out of gas. This can potentially lock funds in the contract. A better alternative is using a call with error handling.",
        "file_name": "0x0eabed78fd49ad3c0a3e445954f29522025c09a0.sol"
    },
    {
        "function_name": "mintAndRefer",
        "code": "function mintAndRefer(uint numberOfTokens, address referrer) external payable { require(saleIsActive, \"Sale must be active to mint a WOAI\"); require(numberOfTokens <= maxWoaiPurchase, \"Can only mint 10 tokens at a time\"); require(totalSupply().add(numberOfTokens) <= MAX_WOAI, \"Purchase would exceed max supply of WOAI\"); require(woaiPrice.mul(numberOfTokens) <= msg.value, \"Transaction needs to be accompanied with Ether to mint a WOAI\"); require(referrer != address(0), \"Zero address cannot be a referrer\"); for(uint i = 0; i < numberOfTokens; i++) { uint mintIndex = totalSupply(); _referAndMint(msg.sender, mintIndex, referrer); } }",
        "vulnerability": "Referrer abuse",
        "reason": "The function allows users to mint tokens with a referrer, but there is no mechanism to ensure the referrer is legitimate or to prevent self-referral strategies, which could lead to abuse and manipulation of referrer counts.",
        "file_name": "0x0eabed78fd49ad3c0a3e445954f29522025c09a0.sol"
    },
    {
        "function_name": "setGeneratorValue",
        "code": "function setGeneratorValue(uint tokenId, string memory genVal) external { require(ownerOf(tokenId) == msg.sender,\"Only token owner can set the generator value\"); require(bytes(genVal).length <= 256, \"Maximum 256 characters\"); require(!isManuallyPaused(), \"The generator is currently paused\"); updatePeriod(); require(currentPeriodAmount < limit,\"The generation limit has been reached for today. Try again tomorrow!\"); _setGeneratorValue(tokenId, genVal); currentPeriodAmount++; }",
        "vulnerability": "Lack of access control",
        "reason": "The function allows the token owner to set generator values without any further access control or validation on the input data. This could lead to arbitrary and potentially harmful data being set, impacting the contract's state or related systems.",
        "file_name": "0x0eabed78fd49ad3c0a3e445954f29522025c09a0.sol"
    }
]