[
    {
        "function_name": "endowment",
        "code": "function endowment(address destination) public nonReentrant onlyOwner { require((address(this).balance/333) > (1* (10 ** 18)), \"No\"); require(_lastEndowment + _loanTermBlocks*8 < block.number); _lastEndowment = block.number; (bool sent, bytes memory data) = payable(destination).call{value: (address(this).balance/100)}(\"\"); }",
        "vulnerability": "Transaction not reverted on failed call",
        "reason": "In the `endowment` function, the result of the call to transfer ether is stored in a boolean `sent`, but the function does not revert if `sent` is false. This means that if the transfer fails, the function will not revert, potentially leading to unexpected behavior or loss of funds.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    },
    {
        "function_name": "sellToken",
        "code": "function sellToken(uint256 tokenId, uint256 minPrice) public nonReentrant payable { if(_vaultOpen == 0) require(totalSupply() >= _maxSupply, \"Closed\"); require(msg.sender == tx.origin, \"No contract\"); uint256 price = getUserSellPrice(); require(getUserSellPrice() >= minPrice, \"Too low\"); safeTransferFrom(msg.sender ,address(this) ,tokenId); (bool sent, bytes memory data) = payable(msg.sender).call{value: price}(\"\"); vStats.totalVaultBuyVolume = vStats.totalVaultBuyVolume + price; emit SoldToVault(vStats.txId, msg.sender, tokenId, price); vStats.txId = vStats.txId + 1; }",
        "vulnerability": "Transaction not reverted on failed call",
        "reason": "In the `sellToken` function, the code does not check whether the call to transfer ether to `msg.sender` was successful. If the transfer fails, the function will not revert, which could lead to a loss of funds for the user selling the token.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    },
    {
        "function_name": "mint",
        "code": "function mint(uint256 mints) public nonReentrant payable { require(msg.value == _mintPrice*mints, \"0.025 per\"); require(msg.sender == tx.origin, \"No contracts\"); require(mints <= 5, \"Max 5\"); uint8 i = 0; for(i=0; i< mints; i++){ _tokenIds.increment(); require(_tokenIds.current() <= _maxSupply, \"Mint Over\"); super._safeMint(msg.sender, _tokenIds.current()); if(_tokenIds.current()%10 == 7){ _tokenIds.increment(); super._mint(address(this), _tokenIds.current()); } if(_tokenIds.current()%50 == 42){ _tokenIds.increment(); super._mint(_pixelPawnAddress, _tokenIds.current()); } } if(_tokenIds.current() == _maxSupply){ (bool sent, bytes memory data) = payable(_a1).call{value: (address(this).balance/5)}(\"\"); } }",
        "vulnerability": "Transaction not reverted on failed call",
        "reason": "In the `mint` function, when the maximum supply is reached, a portion of the contract's balance is sent to `_a1`. However, there is no check to ensure that the transfer was successful. If the transfer fails, the function does not revert, potentially leading to a situation where the intended funds are not received by `_a1`.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    }
]