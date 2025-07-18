[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) public returns (bool) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race Condition - ERC20 approve function",
        "reason": "The approve function allows changing the allowance without requiring the spender to first reduce the allowance to zero. This can lead to a race condition where the spender may spend the current allowance and the new allowance simultaneously if they act quickly.",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol"
    },
    {
        "function_name": "function",
        "code": "function() whenNotPaused public payable { require(state == SaleState.SALE); require(msg.value >= minimalContribution); require(whiteList[msg.sender].isActive); if (now > endDate) { state = SaleState.ENDED; msg.sender.transfer(msg.value); return; } WhitelistContributor memory contrib = whiteList[msg.sender]; require(contrib.invAmount <= msg.value || contrib.payed); if (whiteList[msg.sender].payed == false) { whiteList[msg.sender].payed = true; } ethRaised += msg.value; uint tokenAmount = msg.value.div(price); tokenAmount += tokenAmount.mul(contrib.bonus).div(100); tokenAmount *= 10 ** 18; tokenRaised += tokenAmount; holdContract.addHolder(msg.sender, tokenAmount, contrib.holdPeriod, contrib.holdTimestamp); AddedToHolder(msg.sender, tokenAmount, contrib.holdPeriod, contrib.holdTimestamp); FundTransfered(msg.sender, msg.value); forwardFunds(); }",
        "vulnerability": "Reentrancy in fallback function",
        "reason": "The fallback function includes a call to msg.sender.transfer which can be exploited for reentrancy attacks. This is particularly dangerous as the function also involves state changes, which should be completed before any external calls are made.",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol"
    },
    {
        "function_name": "removeAssetsOwner",
        "code": "function removeAssetsOwner(address _owner) public onlyOwner { uint index = assetOwnersIndex[_owner]; delete assetOwnersIndex[_owner]; delete assetOwners[index]; assetOwnersIndexes--; }",
        "vulnerability": "Incorrect management of assetOwnersIndexes",
        "reason": "When removing an asset owner, the assetOwnersIndexes is decremented without ensuring that the last entry in assetOwners is moved to fill the gap. This can lead to inconsistencies in the list of asset owners and potentially leave the assetOwners mapping with stale entries.",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol"
    }
]