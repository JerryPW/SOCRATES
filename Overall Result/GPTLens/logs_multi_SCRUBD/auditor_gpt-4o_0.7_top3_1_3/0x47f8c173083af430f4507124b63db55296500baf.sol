[
    {
        "function_name": "createCampaign",
        "code": "function createCampaign(bytes32 id, uint value, address campaignCreator) onlyOwner returns (uint) { require(getAddressCreatorById(id) == address(0)); token.transferFrom(campaignCreator, this, value); campaigns[id] = Campaign(campaignCreator, value, value, Status.created); CreateCampaign(id); }",
        "vulnerability": "Missing return value check for transferFrom",
        "reason": "The function does not check the return value of token.transferFrom, which could lead to an incorrect state if the token transfer fails. This could be exploited if the token contract returns false, leading to a scenario where campaigns are created without transferring tokens correctly.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    },
    {
        "function_name": "sendCoin",
        "code": "function sendCoin(address[] _routerOwners, uint[] amount, bytes32 id) onlyOwner { require(campaigns[id].status == Status.created); require(amount.length == _routerOwners.length); require(sum(amount) <= campaigns[id].tokenAmount); for (var i = 0; i < amount.length; i++) { token.transfer(_routerOwners[i], safeDiv(safeMul(amount[i], 95), 100)); } token.transfer(fee, safeDiv(safeMul(sum(amount), 5), 100) ); campaigns[id].currentBalance = safeSub(campaigns[id].currentBalance, sum(amount)); SendCoinForCampaign(id); }",
        "vulnerability": "Integer overflow in sum calculation",
        "reason": "The function uses a custom sum function that could lead to an integer overflow when summing large amounts, especially since Solidity version 0.4.21 does not have built-in overflow checks. This can be exploited to create a scenario where the sum exceeds the expected token amount, allowing excess tokens to be transferred from the campaign.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    },
    {
        "function_name": "finishCampaign",
        "code": "function finishCampaign(bytes32 id) onlyOwner returns (bool success) { campaigns[id].status = Status.finished; token.transfer(campaigns[id].creator, campaigns[id].currentBalance); campaigns[id].currentBalance = 0; }",
        "vulnerability": "Missing return value check for transfer",
        "reason": "Similar to createCampaign, this function does not check the return value of token.transfer. If the transfer fails, the campaign would still be marked as finished and the balance set to zero, leading to a potential loss of tokens without actually transferring them to the campaign creator.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    }
]