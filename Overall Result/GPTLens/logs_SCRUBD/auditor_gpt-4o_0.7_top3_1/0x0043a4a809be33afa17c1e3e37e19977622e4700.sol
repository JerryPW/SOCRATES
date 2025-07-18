[
    {
        "function_name": "_widthdraw",
        "code": "function _widthdraw(address _address, uint256 _amount) private { (bool success, ) = _address.call{value: _amount}(\"\"); require(success, \"Transfer failed.\"); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The _widthdraw function is susceptible to reentrancy attacks because it transfers Ether to an arbitrary address without using a reentrancy guard. If the recipient is a contract, it could re-enter the contract and execute code before the state updates.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    },
    {
        "function_name": "mintToMultipleERC20",
        "code": "function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable { require(_amount >= 1, \"Must mint at least 1 token\"); require(_amount <= maxBatchSize, \"Cannot mint more than max mint per transaction\"); require(getNextTokenId() <= collectionSize, \"Cannot mint over supply cap of 1000\"); require(mintingOpen == true, \"Minting is not open right now!\"); require(canMintAmount(_to, 1), \"Wallet address is over the maximum allowed mints\"); require(isApprovedForERC20Payments(_erc20TokenContract), \"ERC-20 Token is not approved for minting!\"); uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount; IERC20 payableToken = IERC20(_erc20TokenContract); require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, \"Buyer does not own enough of token to complete purchase\"); require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, \"Buyer did not approve enough of ERC-20 token to complete purchase\"); require(hasSurcharge(), \"Fee for ERC-20 payment not provided!\"); bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer); require(transferComplete, \"ERC-20 token was unable to be transferred\"); _safeMint(_to, _amount, false); addSurcharge(); }",
        "vulnerability": "ERC20 token approval front-running",
        "reason": "The mintToMultipleERC20 function can be exploited through front-running. An attacker can monitor the pending transactions and if an approval transaction for a specific ERC20 token is detected, the attacker can front-run the minting transaction by increasing the gas price, causing the approval to be used up and the minting transaction to fail.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    },
    {
        "function_name": "withdrawERC20",
        "code": "function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner { require(_amountToWithdraw > 0); IERC20 tokenContract = IERC20(_tokenContract); require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, \"WithdrawV2: Contract does not own enough tokens\"); tokenContract.transfer(erc20Payable, _amountToWithdraw); _withdrawAllSurcharges(); }",
        "vulnerability": "Lack of event emission",
        "reason": "The withdrawERC20 function transfers ERC20 tokens from the contract to a payable address without emitting any event. This could lead to lack of transparency and auditability, making it difficult to track withdrawals and potentially hiding malicious activity.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    }
]