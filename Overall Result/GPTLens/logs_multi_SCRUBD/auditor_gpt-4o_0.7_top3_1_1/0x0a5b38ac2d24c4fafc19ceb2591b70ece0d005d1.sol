[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) onlyOwner external { require(daoStatus() == 1, \"Daoclub: Can only be withdrawn after the fundraising is completed\"); require(amount <= getBalance(), \"Daoclub: The withdrawal amount cannot be greater than the dao balance\"); fundraisingCompleted(); if(isETH()) { payable(_summonerAddress).transfer(amount); }else { _targetToken.safeTransfer(_summonerAddress, amount); } }",
        "vulnerability": "Owner can withdraw all funds",
        "reason": "The withdraw function allows the owner to withdraw any amount of money from the contract once the fundraising is completed. This could potentially allow the owner to drain all funds from the contract, leaving no funds for distribution to the DAO members.",
        "file_name": "0x0a5b38ac2d24c4fafc19ceb2591b70ece0d005d1.sol"
    },
    {
        "function_name": "submitVote",
        "code": "function submitVote(uint8 vote) onlyMember external { require(daoStatus()== 2, \"no Proposal\"); if(_voteResult[msg.sender] == 0) { _voteResult[msg.sender] = vote; if(vote == 1) { _voteYes(); }else { _voteNo(); } }else { require(_voteResult[msg.sender] != vote, \"Can't vote again\"); if(_voteResult[msg.sender] == 1) { _yesShares -= _balances[msg.sender]; _voteNo(); }else { _noShares -= _balances[msg.sender]; _voteYes(); } } emit SubmitVote(address(this), msg.sender, vote, _balances[msg.sender].mul(100).div(_totalSupply)); }",
        "vulnerability": "Vote flipping without limit",
        "reason": "The submitVote function allows members to change their votes multiple times. While the function ensures a member cannot vote the same way twice, it does not limit the number of times a member can flip their vote, which can be exploited to manipulate the voting outcome.",
        "file_name": "0x0a5b38ac2d24c4fafc19ceb2591b70ece0d005d1.sol"
    },
    {
        "function_name": "liquidate",
        "code": "function liquidate() onlyGpAndLp external { require(daoStatus() == 3, \"Daoclub: yes shares less than 70%\"); uint256 amountOfThisLiquidation_ = getBalance(); if(!_receivedManagementFee) { require(amountOfThisLiquidation_ > _receivableManagementFee, \"Daoclub: Insufficient amount\"); if(isETH()) { payable(_summonerAddress).transfer(_receivableManagementFee); }else { _targetToken.safeTransfer( _summonerAddress, _receivableManagementFee); } _receivedManagementFee = true; amountOfThisLiquidation_ = amountOfThisLiquidation_.sub(_receivableManagementFee); } uint256 gpProfit_ = 0; if((amountOfThisLiquidation_ + _amountOfGrandTotalLiquidation) > _actualFund) { uint256 profit_; if(_amountOfGrandTotalLiquidation < _actualFund) { profit_ = amountOfThisLiquidation_ + _amountOfGrandTotalLiquidation - _actualFund; }else { profit_ = amountOfThisLiquidation_; } gpProfit_ = profit_.mul(_profitDistribution).div(100); if(isETH()) { payable(_summonerAddress).transfer(gpProfit_); }else { _targetToken.safeTransfer( _summonerAddress, gpProfit_); } amountOfThisLiquidation_ -= gpProfit_; } for(uint i = 0; i < _members.length; i++ ) { if(_balances[_members[i]] > 0) { uint256 distributeProfit_ = amountOfThisLiquidation_.mul(_balances[_members[i]]).div(_totalSupply); if(isETH()) { payable(_members[i]).transfer(distributeProfit_); }else { _targetToken.safeTransfer(_members[i], distributeProfit_); } emit LiquidationCompleted(address(this), _members[i], distributeProfit_, _fundShare(_members[i])); } } _amountOfGrandTotalLiquidation = _amountOfGrandTotalLiquidation + amountOfThisLiquidation_ + gpProfit_; }",
        "vulnerability": "Insufficient balance check for management fee",
        "reason": "In the liquidate function, the contract checks if getBalance() is greater than _receivableManagementFee to pay the management fee. However, this check is done without considering the full amount needed for proper liquidation, potentially leading to a state where the management fee is paid but insufficient funds remain for member distributions.",
        "file_name": "0x0a5b38ac2d24c4fafc19ceb2591b70ece0d005d1.sol"
    }
]