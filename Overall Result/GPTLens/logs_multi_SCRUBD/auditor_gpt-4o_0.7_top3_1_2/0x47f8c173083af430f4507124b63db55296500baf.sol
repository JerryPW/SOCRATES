[
    {
        "function_name": "createCampaign",
        "code": "function createCampaign(bytes32 id, uint value, address campaignCreator) onlyOwner returns (uint) { require(getAddressCreatorById(id) == address(0)); token.transferFrom(campaignCreator, this, value); campaigns[id] = Campaign(campaignCreator, value, value, Status.created); CreateCampaign(id); }",
        "vulnerability": "ERC20 approval front-running",
        "reason": "The `transferFrom` function used in `createCampaign` relies on the ERC20 token's approval mechanism, which is vulnerable to front-running attacks. An attacker could monitor the blockchain for allowance increase transactions and quickly execute a transferFrom to deplete the tokens before the intended transaction.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    },
    {
        "function_name": "destroyCampaign",
        "code": "function destroyCampaign(bytes32 id) onlyOwner returns (bool success) { token.transfer(campaigns[id].creator, campaigns[id].tokenAmount); campaigns[id].status = Status.destroyed; campaigns[id].currentBalance = 0; }",
        "vulnerability": "Lack of validation on campaign status",
        "reason": "The function `destroyCampaign` does not check the status of the campaign before executing. This means a campaign that's already finished or in an incorrect state could be destroyed, allowing the owner to retrieve tokens inappropriately.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    },
    {
        "function_name": "finishCampaign",
        "code": "function finishCampaign(bytes32 id) onlyOwner returns (bool success) { campaigns[id].status = Status.finished; token.transfer(campaigns[id].creator, campaigns[id].currentBalance); campaigns[id].currentBalance = 0; }",
        "vulnerability": "Unauthorized token recovery",
        "reason": "The `finishCampaign` function allows the owner to transfer the remaining balance of tokens back to the creator without validating any conditions related to the campaign's completion. This could be abused to prematurely end a campaign and return the tokens.",
        "file_name": "0x47f8c173083af430f4507124b63db55296500baf.sol"
    }
]