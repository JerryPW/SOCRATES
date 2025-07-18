[
    {
        "function_name": "endowment",
        "code": "function endowment(address destination) public nonReentrant onlyOwner { require((address(this).balance/333) > (1* (10 ** 18)), \"No\"); require(_lastEndowment + _loanTermBlocks*8 < block.number); _lastEndowment = block.number; (bool sent, bytes memory data) = payable(destination).call{value: (address(this).balance/100)}(\"\"); }",
        "vulnerability": "Missing return value check for call",
        "reason": "The function does not check the return value of the 'call' function when transferring Ether to the destination address. If the 'call' fails, it could lead to unexpected behavior or loss of funds, as there is no mechanism to handle the failure.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    },
    {
        "function_name": "mint",
        "code": "function mint(uint256 mints) public nonReentrant payable { require(msg.value == _mintPrice*mints, \"0.025 per\"); require(msg.sender == tx.origin, \"No contracts\"); require(mints <= 5, \"Max 5\"); uint8 i = 0; for(i=0; i< mints; i++){ _tokenIds.increment(); require(_tokenIds.current() <= _maxSupply, \"Mint Over\"); super._safeMint(msg.sender, _tokenIds.current()); if(_tokenIds.current()%10 == 7){ _tokenIds.increment(); super._mint(address(this), _tokenIds.current()); } if(_tokenIds.current()%50 == 42){ _tokenIds.increment(); super._mint(_pixelPawnAddress, _tokenIds.current()); } } if(_tokenIds.current() == _maxSupply){ (bool sent, bytes memory data) = payable(_a1).call{value: (address(this).balance/5)}(\"\"); } }",
        "vulnerability": "Unrestricted minting",
        "reason": "The mint function allows any user to mint tokens as long as they pay the required price. However, it does not impose any restrictions on who can mint the tokens, potentially allowing malicious users to mint a large number of tokens uncontrollably, affecting the tokenomics and integrity of the system.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    },
    {
        "function_name": "takeLoan",
        "code": "function takeLoan(uint256 tokenId) public nonReentrant payable { if(_vaultOpen == 0) require(totalSupply() >= _maxSupply, \"Closed\"); uint256 loanValue = getUserSellPrice()/4; uint256 interest = loanValue*3*_loanTerm/1000; safeTransferFrom(msg.sender ,address(this) ,tokenId); Loan memory currentLoan; currentLoan.debtor = msg.sender; currentLoan.total = loanValue + interest; currentLoan.interest = interest; currentLoan.startBlock = block.number; currentLoan.loanId = vStats.loanId; vStats.totalLoanPrinciple = vStats.totalLoanPrinciple + loanValue; vStats.totalLoanInterest = vStats.totalLoanInterest + interest; (bool sent, bytes memory data) = payable(msg.sender).call{value: loanValue}(\"\"); _currentLoans[tokenId] = currentLoan; emit IssueLoan(vStats.loanId, msg.sender, currentLoan.total, tokenId); vStats.loanId = vStats.loanId + 1; }",
        "vulnerability": "Loan issuance without collateral verification",
        "reason": "The function allows loans to be taken without verifying if the tokenId is already collateral for another loan. This could lead to multiple loans being issued against the same token, creating a risk of fraudulent borrowing and potential financial loss for the system.",
        "file_name": "0x06a07a3911dab4507dd44cd97e30c3267d4a9c63.sol"
    }
]