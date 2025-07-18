[
    {
        "function_name": "endowment",
        "code": "function endowment(address destination) public nonReentrant onlyOwner { require((address(this).balance/333) > (1* (10 ** 18)), \"No\"); require(_lastEndowment + _loanTermBlocks*8 < block.number); _lastEndowment = block.number; (bool sent, bytes memory data) = payable(destination).call{value: (address(this).balance/100)}(\"\"); }",
        "vulnerability": "Reentrancy",
        "reason": "The endowment function transfers Ether to an external address without checking the result of the call or using the nonReentrant modifier. If the destination is a contract, it could re-enter the contract before the function completes, potentially allowing for a reentrancy attack.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    },
    {
        "function_name": "sellToken",
        "code": "function sellToken(uint256 tokenId, uint256 minPrice) public nonReentrant payable { if(_vaultOpen == 0) require(totalSupply() >= _maxSupply, \"Closed\"); require(msg.sender == tx.origin, \"No contract\"); uint256 price = getUserSellPrice(); require(getUserSellPrice() >= minPrice, \"Too low\"); safeTransferFrom(msg.sender ,address(this) ,tokenId); (bool sent, bytes memory data) = payable(msg.sender).call{value: price}(\"\"); vStats.totalVaultBuyVolume = vStats.totalVaultBuyVolume + price; emit SoldToVault(vStats.txId, msg.sender, tokenId, price); vStats.txId = vStats.txId + 1; }",
        "vulnerability": "Reentrancy",
        "reason": "The sellToken function sends Ether to msg.sender without proper checks or the nonReentrant modifier, which could be exploited by a reentrancy attack if the recipient is a contract that can re-enter the function.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    },
    {
        "function_name": "takeLoan",
        "code": "function takeLoan(uint256 tokenId) public nonReentrant payable { if(_vaultOpen == 0) require(totalSupply() >= _maxSupply, \"Closed\"); uint256 loanValue = getUserSellPrice()/4; uint256 interest = loanValue*3*_loanTerm/1000; safeTransferFrom(msg.sender ,address(this) ,tokenId); Loan memory currentLoan; currentLoan.debtor = msg.sender; currentLoan.total = loanValue + interest; currentLoan.interest = interest; currentLoan.startBlock = block.number; currentLoan.loanId = vStats.loanId; vStats.totalLoanPrinciple = vStats.totalLoanPrinciple + loanValue; vStats.totalLoanInterest = vStats.totalLoanInterest + interest; (bool sent, bytes memory data) = payable(msg.sender).call{value: loanValue}(\"\"); _currentLoans[tokenId] = currentLoan; emit IssueLoan(vStats.loanId, msg.sender, currentLoan.total, tokenId); vStats.loanId = vStats.loanId + 1; }",
        "vulnerability": "Reentrancy",
        "reason": "The takeLoan function sends Ether to msg.sender after transferring the token, without checks on the call result. If the recipient is a contract, it could re-enter the function before completion, potentially leading to a reentrancy attack.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    }
]