[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { require(msg.sender == safe); uint balance = address(this).balance; msg.sender.transfer(balance); }",
        "vulnerability": "Potential for unauthorized withdrawal",
        "reason": "The function `withdraw` allows the address stored in the `safe` variable to transfer the entire contract balance to itself. If the `safe` address is compromised or incorrectly set, an attacker could withdraw all funds from the contract, causing substantial financial loss.",
        "file_name": "0x08715190074e24cf2145e8a61b784a1b5ac9a505.sol"
    },
    {
        "function_name": "createCollectible",
        "code": "function createCollectible() public payable returns (uint256) { require(block.timestamp >= SALE_START_TIMESTAMP, \"Sale has not started\"); require(tokenCounter < FIRST_BATCH_SUPPLY, \"First batch has been sold out\"); require(getVoidPrice() == msg.value, \"Ether value sent is not correct\"); uint256 lastTokenId = tokenCounter; address voidOwner = msg.sender; if (lastTokenId == FIRST_BATCH_SUPPLY - 1) { tokenIdToRand[lastTokenId] = 0; tokenIdToVoid[lastTokenId] = indexToVoid(0); } else { uint256 r = uint(keccak256(abi.encodePacked(voidOwner, msg.value))) % 7776; tokenIdToRand[lastTokenId] = r; tokenIdToVoid[lastTokenId] = indexToVoid(r); } _safeMint(voidOwner, lastTokenId); lastPrice = lastPrice * 1010 / 1000; tokenIdToOwner[lastTokenId] = voidOwner; emit createdCollectible(lastTokenId); tokenCounter = tokenCounter + 1; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `createCollectible` function involves minting a token and transferring funds without using the checks-effects-interactions pattern, which can be exploited by reentrant calls. Although `_safeMint` is supposed to be safe, if any external contract is called during minting, it could lead to reentrancy attacks where an attacker could manipulate the state before the function completes.",
        "file_name": "0x08715190074e24cf2145e8a61b784a1b5ac9a505.sol"
    },
    {
        "function_name": "burn",
        "code": "function burn(uint256 tokenId) public { require( _isApprovedOrOwner(_msgSender(), tokenId), \"ERC721: burn caller is not owner nor approved\" ); _burn(tokenId); tokenIdToRand[tokenId] = 0; tokenIdToVoid[tokenId] = indexToVoid(0); tokenIdToOwner[tokenId] = address(0); }",
        "vulnerability": "Inconsistent state after burning",
        "reason": "The `burn` function attempts to reset mappings related to a token after it is burned. However, it does not properly handle all parts of the state, which could lead to inconsistencies and erroneous assumptions about the state of a token after it is burned. This can be exploited to cause unexpected behaviors in other parts of the contract.",
        "file_name": "0x08715190074e24cf2145e8a61b784a1b5ac9a505.sol"
    }
]