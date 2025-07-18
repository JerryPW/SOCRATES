[
    {
        "function_name": "purchaseTokens",
        "code": "function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) { require(_incomingEthereum <= 1 finney); require( now >= startTime || (now >= startTime - 1 hours && !ambassadorsPremined[msg.sender] && ambassadorsPremined[ambassadorsPrerequisite[msg.sender]] && _incomingEthereum <= ambassadorsMaxPremine[msg.sender]) || (now >= startTime - 10 minutes && !ambassadorsPremined[msg.sender] && _incomingEthereum <= ambassadorsMaxPremine[msg.sender]) ); if (now < startTime) { ambassadorsPremined[msg.sender] = true; } address _customerAddress = msg.sender; uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100); uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100); uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus); uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends); uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum); require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_); if ( _referredBy != 0x0000000000000000000000000000000000000000 && _referredBy != _customerAddress && tokenBalanceLedger_[_referredBy] >= stakingRequirement ) { referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus); } else { _dividends = SafeMath.add(_dividends, _referralBonus); } tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens); tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens); moonIncContract.handleProductionIncrease.value(_dividends)(_customerAddress, _amountOfTokens * cookieProductionMultiplier); onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice()); return _amountOfTokens; }",
        "vulnerability": "Unchecked External Call",
        "reason": "The function calls an external contract function `handleProductionIncrease` without checking for its success or handling potential reentrancy, which can lead to unexpected behaviors or vulnerabilities if the external contract is malicious.",
        "file_name": "0x025cd28d7ef83e1c2ffe511d5f9290d54ba5dcf0.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() onlyStronghands public { address _customerAddress = msg.sender; uint256 _dividends = myDividends(false); payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude); _dividends += referralBalance_[_customerAddress]; referralBalance_[_customerAddress] = 0; _customerAddress.transfer(_dividends); onWithdraw(_customerAddress, _dividends); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The function transfers ether to the user's address before updating the state variables `payoutsTo_` and `referralBalance_`, which can be exploited by an attacker to perform a reentrancy attack, repeatedly calling the function to drain funds.",
        "file_name": "0x025cd28d7ef83e1c2ffe511d5f9290d54ba5dcf0.sol"
    },
    {
        "function_name": "sell",
        "code": "function sell(uint256 _amountOfTokens) onlyBagholders public { require(now >= startTime); address _customerAddress = msg.sender; require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]); uint256 _tokens = _amountOfTokens; uint256 _ethereum = tokensToEthereum_(_tokens); uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100); uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends); tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens); tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens); int256 _updatedPayouts = (int256) (_taxedEthereum * magnitude); payoutsTo_[_customerAddress] -= _updatedPayouts; moonIncContract.handleProductionDecrease.value(_dividends)(_customerAddress, _tokens * cookieProductionMultiplier); onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice()); }",
        "vulnerability": "Unchecked External Call",
        "reason": "The function makes an external call to `handleProductionDecrease` in a similar manner to `purchaseTokens`, without checking for call success or handling reentrancy, introducing the same risks.",
        "file_name": "0x025cd28d7ef83e1c2ffe511d5f9290d54ba5dcf0.sol"
    }
]