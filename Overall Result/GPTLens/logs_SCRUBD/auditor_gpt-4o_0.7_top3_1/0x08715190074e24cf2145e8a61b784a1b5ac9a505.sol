[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { require(msg.sender == safe); uint balance = address(this).balance; msg.sender.transfer(balance); }",
        "vulnerability": "Missing access control",
        "reason": "The withdraw function is protected by a simple require statement that checks if the caller is the 'safe' address. If this address is compromised or if someone with access to this address behaves maliciously, they can withdraw all the ETH from the contract.",
        "file_name": "0x08715190074e24cf2145e8a61b784a1b5ac9a505.sol"
    },
    {
        "function_name": "createCollectible",
        "code": "function createCollectible() public payable returns (uint256) { require(block.timestamp >= SALE_START_TIMESTAMP, \"Sale has not started\"); require(tokenCounter < FIRST_BATCH_SUPPLY, \"First batch has been sold out\"); require(getVoidPrice() == msg.value, \"Ether value sent is not correct\"); uint256 lastTokenId = tokenCounter; address voidOwner = msg.sender; if (lastTokenId == FIRST_BATCH_SUPPLY - 1) { tokenIdToRand[lastTokenId] = 0; tokenIdToVoid[lastTokenId] = indexToVoid(0); } else { uint256 r = uint(keccak256(abi.encodePacked(voidOwner, msg.value))) % 7776; tokenIdToRand[lastTokenId] = r; tokenIdToVoid[lastTokenId] = indexToVoid(r); } _safeMint(voidOwner, lastTokenId); lastPrice = lastPrice * 1010 / 1000; tokenIdToOwner[lastTokenId] = voidOwner; emit createdCollectible(lastTokenId); tokenCounter = tokenCounter + 1; }",
        "vulnerability": "Predictable random number generation",
        "reason": "The randomness for the token's attributes is generated using block variables and the sender's address, which are predictable. An attacker could exploit this by simulating the contract's behavior off-chain to predict the random outcome, allowing them to mint a token with desired attributes.",
        "file_name": "0x08715190074e24cf2145e8a61b784a1b5ac9a505.sol"
    },
    {
        "function_name": "burn",
        "code": "function burn(uint256 tokenId) public { require( _isApprovedOrOwner(_msgSender(), tokenId), \"ERC721: burn caller is not owner nor approved\" ); _burn(tokenId); tokenIdToRand[tokenId] = 0; tokenIdToVoid[tokenId] = indexToVoid(0); tokenIdToOwner[tokenId] = address(0); }",
        "vulnerability": "Inconsistent state update after burn",
        "reason": "After burning a token, the state variables tokenIdToRand, tokenIdToVoid, and tokenIdToOwner are reset but not properly cleaned up. This can lead to unintended behavior or vulnerabilities if these mappings are accessed elsewhere in the contract assuming their state is consistent.",
        "file_name": "0x08715190074e24cf2145e8a61b784a1b5ac9a505.sol"
    }
]