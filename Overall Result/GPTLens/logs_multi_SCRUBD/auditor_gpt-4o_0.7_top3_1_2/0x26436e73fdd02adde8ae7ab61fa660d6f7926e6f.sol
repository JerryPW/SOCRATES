[
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(address beneficiary) public payable { require(beneficiary != address(0)); require(validPurchase()); uint256 weiAmount = msg.value; uint256 tokens = getTokenAmount(weiAmount); weiRaised = weiRaised.add(weiAmount); tierTotal = tierTotal.add(weiAmount); token.transfer(beneficiary, tokens); TokenPurchase(msg.sender, beneficiary, weiAmount, tokens); forwardFunds(); rateUpgrade(tierTotal); }",
        "vulnerability": "No check on transfer success",
        "reason": "The function assumes that the transfer of tokens to the beneficiary will always succeed. If the transfer fails, the contract does not handle the failure, and the funds are still forwarded to the wallet, leading to a potential loss of funds for the purchaser without receiving tokens.",
        "file_name": "0x26436e73fdd02adde8ae7ab61fa660d6f7926e6f.sol"
    },
    {
        "function_name": "rateUpgrade",
        "code": "function rateUpgrade(uint256 tierAmount) internal { uint256 tierEthLimit = fundingLimit[tierNum].div(fundingRate[tierNum]); uint256 tierWeiLimit = tierEthLimit.mul(1 ether); if(tierAmount >= tierWeiLimit) { tierNum = tierNum.add(1); rate = fundingRate[tierNum]; tierTotal = 0; } }",
        "vulnerability": "Array out-of-bounds error",
        "reason": "This function increments the tierNum variable without checking whether it exceeds the bounds of the fundingRate and fundingLimit arrays. If tierNum exceeds the length of these arrays, the contract will revert, potentially locking the crowdsale.",
        "file_name": "0x26436e73fdd02adde8ae7ab61fa660d6f7926e6f.sol"
    },
    {
        "function_name": "destroy",
        "code": "function destroy() public onlyOwner payable { uint256 balance = tokensAvailable(); if(balance > 0) { token.transfer(owner, balance); } selfdestruct(owner); }",
        "vulnerability": "Improper token transfer",
        "reason": "The destroy function transfers remaining tokens to the owner without checking the success of the transfer. If the token transfer fails, the tokens remain in the contract, and the owner may not receive them before the contract is destructed.",
        "file_name": "0x26436e73fdd02adde8ae7ab61fa660d6f7926e6f.sol"
    }
]