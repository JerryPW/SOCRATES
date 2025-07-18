[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { require(msg.sender == safe); uint balance = address(this).balance; msg.sender.transfer(balance); }",
        "vulnerability": "Authorization bypass",
        "reason": "The `withdraw` function is intended to be callable only by the address stored in the `safe` variable. However, if the `safe` address is compromised or if the contract is deployed with an incorrect `safe` address, an unauthorized user could withdraw all the ether from the contract.",
        "file_name": "0x08715190074e24cf2145e8a61b784a1b5ac9a505.sol"
    },
    {
        "function_name": "createCollectible",
        "code": "function createCollectible() public payable returns (uint256) { require(block.timestamp >= SALE_START_TIMESTAMP, \"Sale has not started\"); require(tokenCounter < FIRST_BATCH_SUPPLY, \"First batch has been sold out\"); require(getVoidPrice() == msg.value, \"Ether value sent is not correct\"); uint256 lastTokenId = tokenCounter; address voidOwner = msg.sender; if (lastTokenId == FIRST_BATCH_SUPPLY - 1) { tokenIdToRand[lastTokenId] = 0; tokenIdToVoid[lastTokenId] = indexToVoid(0); } else { uint256 r = uint(keccak256(abi.encodePacked(voidOwner, msg.value))) % 7776; tokenIdToRand[lastTokenId] = r; tokenIdToVoid[lastTokenId] = indexToVoid(r); } _safeMint(voidOwner, lastTokenId); lastPrice = lastPrice * 1010 / 1000; tokenIdToOwner[lastTokenId] = voidOwner; emit createdCollectible(lastTokenId); tokenCounter = tokenCounter + 1; }",
        "vulnerability": "Predictable randomness",
        "reason": "The randomness used in `createCollectible` is generated using `keccak256(abi.encodePacked(voidOwner, msg.value))`. This approach is vulnerable because both `voidOwner` and `msg.value` are known to the user, allowing them to predict the outcome and potentially manipulate the randomness to their advantage.",
        "file_name": "0x08715190074e24cf2145e8a61b784a1b5ac9a505.sol"
    },
    {
        "function_name": "burn",
        "code": "function burn(uint256 tokenId) public { require( _isApprovedOrOwner(_msgSender(), tokenId), \"ERC721: burn caller is not owner nor approved\" ); _burn(tokenId); tokenIdToRand[tokenId] = 0; tokenIdToVoid[tokenId] = indexToVoid(0); tokenIdToOwner[tokenId] = address(0); }",
        "vulnerability": "State inconsistency",
        "reason": "The `burn` function resets the state variables `tokenIdToRand`, `tokenIdToVoid`, and `tokenIdToOwner` after burning the token. If there are any checks or logic relying on these mappings before the token is burned, it could lead to inconsistent states or erroneous behavior.",
        "file_name": "0x08715190074e24cf2145e8a61b784a1b5ac9a505.sol"
    }
]