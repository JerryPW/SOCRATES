[
    {
        "function_name": "addHolder",
        "code": "function addHolder(address holder, uint tokens, uint8 timed, uint timest) onlyAssetsOwners external { if (holderList[holder].isActive == false) { holderList[holder].isActive = true; holderList[holder].tokens = tokens; holderList[holder].holdPeriod = timed; holderList[holder].holdPeriodTimestamp = timest; holderIndexes[holderIndex] = holder; holderIndex++; } else { holderList[holder].tokens += tokens; holderList[holder].holdPeriod = timed; holderList[holder].holdPeriodTimestamp = timest; } Hold(msg.sender, holder, tokens, timed); }",
        "vulnerability": "Lack of overflow checks",
        "reason": "The function does not use SafeMath for adding tokens to holderList[holder].tokens, which could result in an overflow if very large values are added repeatedly. This makes it possible to manipulate holder balances if the overflow condition is met.",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol"
    },
    {
        "function_name": "removeAssetsOwner",
        "code": "function removeAssetsOwner(address _owner) public onlyOwner { uint index = assetOwnersIndex[_owner]; delete assetOwnersIndex[_owner]; delete assetOwners[index]; assetOwnersIndexes--; }",
        "vulnerability": "Incorrect management of assetOwnersIndexes",
        "reason": "Decrementing assetOwnersIndexes without ensuring that the index being removed is the last one creates a potential for errors in tracking the number of asset owners. This can lead to improper access control where non-owners could potentially gain asset owner privileges.",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol"
    },
    {
        "function_name": "withdrawEth",
        "code": "function withdrawEth() public { require(this.balance != 0); require(state == SaleState.ENDED); require(msg.sender == wallet); require(tokensTransferredToHold == true); uint bal = this.balance; wallet.transfer(bal); WithdrawedEthToWallet(bal); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers Ether before updating the contract's state (e.g., setting balance to zero). This exposes the function to a reentrancy attack, where an attacker could call withdrawEth recursively and drain Ether from the contract.",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol"
    }
]