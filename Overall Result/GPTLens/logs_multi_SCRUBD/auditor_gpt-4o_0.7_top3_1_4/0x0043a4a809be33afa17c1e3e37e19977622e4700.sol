[
    {
        "function_name": "withdrawERC20",
        "code": "function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner { require(_amountToWithdraw > 0); IERC20 tokenContract = IERC20(_tokenContract); require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, \"WithdrawV2: Contract does not own enough tokens\"); tokenContract.transfer(erc20Payable, _amountToWithdraw); _withdrawAllSurcharges(); }",
        "vulnerability": "ERC20 token theft by team or owner",
        "reason": "The function withdrawERC20 allows any member of the team or the owner to withdraw any amount of ERC20 tokens the contract holds. This can lead to unauthorized access and theft of tokens by malicious team members or if the owner's private key is compromised.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 tokenId ) private { TokenOwnership memory prevOwnership = ownershipOf(tokenId); bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr || getApproved(tokenId) == _msgSender() || isApprovedForAll(prevOwnership.addr, _msgSender())); require( isApprovedOrOwner, \"ERC721A: transfer caller is not owner nor approved\" ); require( prevOwnership.addr == from, \"ERC721A: transfer from incorrect owner\" ); require(to != address(0), \"ERC721A: transfer to the zero address\"); _beforeTokenTransfers(from, to, tokenId, 1); _approve(address(0), tokenId, prevOwnership.addr); _addressData[from].balance -= 1; _addressData[to].balance += 1; _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp)); uint256 nextTokenId = tokenId + 1; if (_ownerships[nextTokenId].addr == address(0)) { if (_exists(nextTokenId)) { _ownerships[nextTokenId] = TokenOwnership( prevOwnership.addr, prevOwnership.startTimestamp ); } } emit Transfer(from, to, tokenId); _afterTokenTransfers(from, to, tokenId, 1); }",
        "vulnerability": "Potentially incorrect ownership update",
        "reason": "The _transfer function attempts to update the ownership of the next token if the address is zero. If there are gaps in the token ownership mapping (e.g., tokens were burned or not sequentially minted), this can incorrectly assign ownership of a token to the wrong address.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    },
    {
        "function_name": "mintToMultipleERC20",
        "code": "function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable { require(_amount >= 1, \"Must mint at least 1 token\"); require(_amount <= maxBatchSize, \"Cannot mint more than max mint per transaction\"); require(getNextTokenId() <= collectionSize, \"Cannot mint over supply cap of 1000\"); require(mintingOpen == true, \"Minting is not open right now!\"); require(canMintAmount(_to, 1), \"Wallet address is over the maximum allowed mints\"); require(isApprovedForERC20Payments(_erc20TokenContract), \"ERC-20 Token is not approved for minting!\"); uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount; IERC20 payableToken = IERC20(_erc20TokenContract); require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, \"Buyer does not own enough of token to complete purchase\"); require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, \"Buyer did not approve enough of ERC-20 token to complete purchase\"); require(hasSurcharge(), \"Fee for ERC-20 payment not provided!\"); bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer); require(transferComplete, \"ERC-20 token was unable to be transferred\"); _safeMint(_to, _amount, false); addSurcharge(); }",
        "vulnerability": "ERC20 transfer failure handling",
        "reason": "The mintToMultipleERC20 function does not handle the case where the transferFrom function might return false due to reasons other than insufficient balance or allowance, such as a paused token contract. This could lead to situations where the minting process is not properly reversed, resulting in the contract state being inconsistent with the expected outcomes.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    }
]