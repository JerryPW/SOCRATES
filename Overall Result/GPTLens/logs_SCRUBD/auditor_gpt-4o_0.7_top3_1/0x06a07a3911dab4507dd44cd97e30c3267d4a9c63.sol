[
    {
        "function_name": "endowment",
        "code": "function endowment(address destination) public nonReentrant onlyOwner {\n    require((address(this).balance/333) > (1* (10 ** 18)), \"No\");\n    require(_lastEndowment + _loanTermBlocks*8 < block.number);\n    _lastEndowment = block.number;\n    (bool sent, bytes memory data) = payable(destination).call{value: (address(this).balance/100)}(\"\");\n}",
        "vulnerability": "Missing send check",
        "reason": "The function attempts to send Ether to an arbitrary address without checking if the transfer was successful using the 'sent' boolean. This can result in Ether being lost in case the transfer fails.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    },
    {
        "function_name": "takeLoan",
        "code": "function takeLoan(uint256 tokenId) public nonReentrant payable {\n    if(_vaultOpen == 0) require(totalSupply() >= _maxSupply, \"Closed\");\n    uint256 loanValue = getUserSellPrice()/4;\n    uint256 interest = loanValue*3*_loanTerm/1000;\n    safeTransferFrom(msg.sender ,address(this) ,tokenId);\n    Loan memory currentLoan;\n    currentLoan.debtor = msg.sender;\n    currentLoan.total = loanValue + interest;\n    currentLoan.interest = interest;\n    currentLoan.startBlock = block.number;\n    currentLoan.loanId = vStats.loanId;\n    vStats.totalLoanPrinciple = vStats.totalLoanPrinciple + loanValue;\n    vStats.totalLoanInterest = vStats.totalLoanInterest + interest;\n    (bool sent, bytes memory data) = payable(msg.sender).call{value: loanValue}(\"\");\n    _currentLoans[tokenId] = currentLoan;\n    emit IssueLoan(vStats.loanId, msg.sender, currentLoan.total, tokenId);\n    vStats.loanId = vStats.loanId + 1;\n}",
        "vulnerability": "Missing send check",
        "reason": "Similar to the 'endowment' function, this function sends Ether to the user without verifying if the transaction was successful. This could lead to loss of funds if the transfer fails.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    },
    {
        "function_name": "payLoan",
        "code": "function payLoan(uint256 tokenId) public nonReentrant payable {\n    if(block.number < (_loanTerm*_loanTermBlocks + _currentLoans[tokenId].startBlock)) require(_currentLoans[tokenId].debtor == msg.sender, \"Nacho loan\");\n    require(msg.value >= _currentLoans[tokenId].total, \"Pay in full\");\n    IERC721 derpContract = IERC721(address(this));\n    derpContract.safeTransferFrom(address(this) ,msg.sender ,tokenId);\n    vStats.paidLoanPrinciple = vStats.paidLoanPrinciple + _currentLoans[tokenId].total - _currentLoans[tokenId].interest;\n    vStats.paidLoanInterest = vStats.paidLoanInterest + _currentLoans[tokenId].interest;\n    _currentLoans[tokenId].total = 0;\n    _currentLoans[tokenId].debtor = address(0);\n    _currentLoans[tokenId].startBlock = 0;\n    _currentLoans[tokenId].interest = 0;\n    emit LoanPaidInFull(_currentLoans[tokenId].loanId, msg.sender, msg.value, tokenId);\n    _currentLoans[tokenId].loanId = 0;\n}",
        "vulnerability": "Lack of access control",
        "reason": "The function allows anyone to pay off a loan as long as they have the correct tokenId and pay the required amount. This could result in an attacker paying off loans with the intent to take control of NFTs that are used as collateral.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    }
]