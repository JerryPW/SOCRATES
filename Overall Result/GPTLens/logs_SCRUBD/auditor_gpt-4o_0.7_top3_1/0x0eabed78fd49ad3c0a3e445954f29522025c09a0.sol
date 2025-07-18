[
    {
        "function_name": "withdraw",
        "code": "function withdraw() external onlyOwner { uint balance = address(this).balance; msg.sender.transfer(balance); }",
        "vulnerability": "Unsafe use of transfer",
        "reason": "The `withdraw` function uses `transfer` to send Ether, which can fail if the gas cost is high or if the recipient is a smart contract with a fallback function that consumes more than 2300 gas. This can cause funds to be locked in the contract.",
        "file_name": "0x0eabed78fd49ad3c0a3e445954f29522025c09a0.sol"
    },
    {
        "function_name": "mintAndRefer",
        "code": "function mintAndRefer(uint numberOfTokens, address referrer) external payable { require(saleIsActive, \"Sale must be active to mint a WOAI\"); require(numberOfTokens <= maxWoaiPurchase, \"Can only mint 10 tokens at a time\"); require(totalSupply().add(numberOfTokens) <= MAX_WOAI, \"Purchase would exceed max supply of WOAI\"); require(woaiPrice.mul(numberOfTokens) <= msg.value, \"Transaction needs to be accompanied with Ether to mint a WOAI\"); require(referrer != address(0), \"Zero address cannot be a referrer\"); for(uint i = 0; i < numberOfTokens; i++) { uint mintIndex = totalSupply(); _referAndMint(msg.sender, mintIndex, referrer); } }",
        "vulnerability": "Referrer manipulation",
        "reason": "The `mintAndRefer` function allows a user to specify a referrer without verifying if the referrer is legitimate or related to the transaction. This could lead to users minting tokens and artificially inflating referrer counts, potentially gaming any referral reward system.",
        "file_name": "0x0eabed78fd49ad3c0a3e445954f29522025c09a0.sol"
    },
    {
        "function_name": "setGeneratorValue",
        "code": "function setGeneratorValue(uint tokenId, string memory genVal) external { require(ownerOf(tokenId) == msg.sender,\"Only token owner can set the generator value\"); require(bytes(genVal).length <= 256, \"Maximum 256 characters\"); require(!isManuallyPaused(), \"The generator is currently paused\"); updatePeriod(); require(currentPeriodAmount < limit,\"The generation limit has been reached for today. Try again tomorrow!\"); _setGeneratorValue(tokenId, genVal); currentPeriodAmount++; }",
        "vulnerability": "Potential denial of service",
        "reason": "The `setGeneratorValue` function does not restrict who can call it, as long as they own the token. This could lead to a situation where malicious token owners spam the function calls, reaching the daily limit quickly and potentially blocking legitimate users from using the generator functionality.",
        "file_name": "0x0eabed78fd49ad3c0a3e445954f29522025c09a0.sol"
    }
]