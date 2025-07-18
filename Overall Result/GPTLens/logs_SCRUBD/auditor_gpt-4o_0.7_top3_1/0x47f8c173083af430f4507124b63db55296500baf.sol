[
    {
        "function_name": "createCampaign",
        "code": "function createCampaign(bytes32 id, uint value, address campaignCreator) onlyOwner returns (uint) { require(getAddressCreatorById(id) == address(0)); token.transferFrom(campaignCreator, this, value); campaigns[id] = Campaign(campaignCreator, value, value, Status.created); CreateCampaign(id); }",
        "vulnerability": "Missing approval check in transferFrom",
        "reason": "The function 'createCampaign' utilizes the 'transferFrom' function of the token without ensuring that the 'campaignCreator' has approved the contract to transfer the specified 'value' of tokens. If the 'campaignCreator' hasn't set such an allowance, the 'transferFrom' call will fail, potentially causing the campaign creation to revert unexpectedly. This allows for a Denial of Service (DoS) scenario where campaigns cannot be created unless external conditions (namely token approval) are met, which are not managed by the contract.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    },
    {
        "function_name": "finishCampaign",
        "code": "function finishCampaign(bytes32 id) onlyOwner returns (bool success) { campaigns[id].status = Status.finished; token.transfer(campaigns[id].creator, campaigns[id].currentBalance); campaigns[id].currentBalance = 0; }",
        "vulnerability": "Potential for reentrancy attack",
        "reason": "The function 'finishCampaign' transfers tokens back to the campaign creator before setting the campaign's current balance to zero. This ordering means that if the token's transfer function calls back into the 'Deal' contract (either directly or indirectly), it could potentially exploit the 'currentBalance' before it is reset to zero. This is a classic reentrancy vulnerability, which could allow an attacker to drain funds from the contract.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    },
    {
        "function_name": "sendCoin",
        "code": "function sendCoin(address[] _routerOwners, uint[] amount, bytes32 id) onlyOwner { require(campaigns[id].status == Status.created); require(amount.length == _routerOwners.length); require(sum(amount) <= campaigns[id].tokenAmount); for (var i = 0; i < amount.length; i++) { token.transfer(_routerOwners[i], safeDiv(safeMul(amount[i], 95), 100)); } token.transfer(fee, safeDiv(safeMul(sum(amount), 5), 100) ); campaigns[id].currentBalance = safeSub(campaigns[id].currentBalance, sum(amount)); SendCoinForCampaign(id); }",
        "vulnerability": "Repeated calls on state-changing functions",
        "reason": "In the 'sendCoin' function, the 'sum(amount)' calculation is performed multiple times, which is inefficient and could lead to inconsistencies if any element of 'amount' array is changed between calls (though in this context it appears safe given the logic within the function). However, this is generally a bad practice as it unnecessarily repeats a potentially expensive operation. More critically, the calculation of 'currentBalance' after token transfers introduces a race condition where the actual balance might not reflect these transfers if token transfer functions have side effects, allowing for potential inconsistencies in the campaign's token accounting.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    }
]