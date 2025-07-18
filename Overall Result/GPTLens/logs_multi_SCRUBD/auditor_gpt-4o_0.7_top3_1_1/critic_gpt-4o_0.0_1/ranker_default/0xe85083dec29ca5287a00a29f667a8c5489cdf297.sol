[
    {
        "function_name": "withdrawEth",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is correct. The function transfers Ether before updating the contract's state (e.g., setting balance to zero). This exposes the function to a reentrancy attack, where an attacker could call withdrawEth recursively and drain Ether from the contract. The severity is high because it could lead to a significant loss of Ether. The profitability is also high because an attacker could potentially profit from this vulnerability.",
        "correctness": 9,
        "severity": 9,
        "profitability": 9,
        "reason": "The function transfers Ether before updating the contract's state (e.g., setting balance to zero). This exposes the function to a reentrancy attack, where an attacker could call withdrawEth recursively and drain Ether from the contract.",
        "code": "function withdrawEth() public { require(this.balance != 0); require(state == SaleState.ENDED); require(msg.sender == wallet); require(tokensTransferredToHold == true); uint bal = this.balance; wallet.transfer(bal); WithdrawedEthToWallet(bal); }",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol",
        "final_score": 9.0
    },
    {
        "function_name": "addHolder",
        "vulnerability": "Lack of overflow checks",
        "criticism": "The reasoning is correct. The function does not use SafeMath for adding tokens to holderList[holder].tokens, which could result in an overflow if very large values are added repeatedly. This could potentially allow an attacker to manipulate holder balances if the overflow condition is met. The severity is high because it could lead to a significant loss of tokens. The profitability is also high because an attacker could potentially profit from this vulnerability.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The function does not use SafeMath for adding tokens to holderList[holder].tokens, which could result in an overflow if very large values are added repeatedly. This makes it possible to manipulate holder balances if the overflow condition is met.",
        "code": "function addHolder(address holder, uint tokens, uint8 timed, uint timest) onlyAssetsOwners external { if (holderList[holder].isActive == false) { holderList[holder].isActive = true; holderList[holder].tokens = tokens; holderList[holder].holdPeriod = timed; holderList[holder].holdPeriodTimestamp = timest; holderIndexes[holderIndex] = holder; holderIndex++; } else { holderList[holder].tokens += tokens; holderList[holder].holdPeriod = timed; holderList[holder].holdPeriodTimestamp = timest; } Hold(msg.sender, holder, tokens, timed); }",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol",
        "final_score": 8.5
    },
    {
        "function_name": "removeAssetsOwner",
        "vulnerability": "Incorrect management of assetOwnersIndexes",
        "criticism": "The reasoning is correct. Decrementing assetOwnersIndexes without ensuring that the index being removed is the last one creates a potential for errors in tracking the number of asset owners. This can lead to improper access control where non-owners could potentially gain asset owner privileges. The severity is moderate because it could lead to unauthorized access, but the profitability is low because it does not directly lead to financial gain.",
        "correctness": 7,
        "severity": 5,
        "profitability": 2,
        "reason": "Decrementing assetOwnersIndexes without ensuring that the index being removed is the last one creates a potential for errors in tracking the number of asset owners. This can lead to improper access control where non-owners could potentially gain asset owner privileges.",
        "code": "function removeAssetsOwner(address _owner) public onlyOwner { uint index = assetOwnersIndex[_owner]; delete assetOwnersIndex[_owner]; delete assetOwners[index]; assetOwnersIndexes--; }",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol",
        "final_score": 5.25
    }
]