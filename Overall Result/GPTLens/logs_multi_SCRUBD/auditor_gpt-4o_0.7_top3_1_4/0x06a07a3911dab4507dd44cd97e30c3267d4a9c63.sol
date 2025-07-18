[
    {
        "function_name": "endowment",
        "code": "function endowment(address destination) public nonReentrant onlyOwner { require((address(this).balance/333) > (1* (10 ** 18)), \"No\"); require(_lastEndowment + _loanTermBlocks*8 < block.number); _lastEndowment = block.number; (bool sent, bytes memory data) = payable(destination).call{value: (address(this).balance/100)}(\"\"); }",
        "vulnerability": "Lack of Error Handling in Call",
        "reason": "The function uses low-level call to transfer Ether without checking if the call was successful. This can lead to Ether being stuck in the contract if the call fails.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    },
    {
        "function_name": "sellToken",
        "code": "function sellToken(uint256 tokenId, uint256 minPrice) public nonReentrant payable { if(_vaultOpen == 0) require(totalSupply() >= _maxSupply, \"Closed\"); require(msg.sender == tx.origin, \"No contract\"); uint256 price = getUserSellPrice(); require(getUserSellPrice() >= minPrice, \"Too low\"); safeTransferFrom(msg.sender ,address(this) ,tokenId); (bool sent, bytes memory data) = payable(msg.sender).call{value: price}(\"\"); vStats.totalVaultBuyVolume = vStats.totalVaultBuyVolume + price; emit SoldToVault(vStats.txId, msg.sender, tokenId, price); vStats.txId = vStats.txId + 1; }",
        "vulnerability": "Lack of Error Handling in Call",
        "reason": "The function uses low-level call to transfer Ether to the seller without checking if the call was successful. This can lead to unexpected behavior if the call fails.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    },
    {
        "function_name": "mint",
        "code": "function mint(uint256 mints) public nonReentrant payable { require(msg.value == _mintPrice*mints, \"0.025 per\"); require(msg.sender == tx.origin, \"No contracts\"); require(mints <= 5, \"Max 5\"); uint8 i = 0; for(i=0; i< mints; i++){ _tokenIds.increment(); require(_tokenIds.current() <= _maxSupply, \"Mint Over\"); super._safeMint(msg.sender, _tokenIds.current()); if(_tokenIds.current()%10 == 7){ _tokenIds.increment(); super._mint(address(this), _tokenIds.current()); } if(_tokenIds.current()%50 == 42){ _tokenIds.increment(); super._mint(_pixelPawnAddress, _tokenIds.current()); } } if(_tokenIds.current() == _maxSupply){ (bool sent, bytes memory data) = payable(_a1).call{value: (address(this).balance/5)}(\"\"); } }",
        "vulnerability": "Lack of Error Handling in Call",
        "reason": "The function uses low-level call to transfer Ether to address _a1 without checking if the call was successful. This could lead to funds being stuck if the call fails.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    }
]