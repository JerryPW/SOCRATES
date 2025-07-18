[
    {
        "function_name": "commitProposal",
        "code": "function commitProposal(string txid) external returns (bool) { require((admin.status &&_existCaller(msg.sender)) || msg.sender == admin.account); require(!platform.proposals[txid].status); platform.proposals[txid].status = true; platform.proposals[txid].weight = platform.proposals[txid].voters.length; return true; }",
        "vulnerability": "Unauthorized Proposal Commitment",
        "reason": "The commitProposal function can be called by any account that has been added as a caller by the admin. This could lead to unauthorized commitments of proposals if the caller list is not properly managed. An attacker added as a caller could commit proposals without reaching the necessary consensus.",
        "file_name": "0x28f1135e43e61ebf303c8f1f9beef4f6a00dcb34.sol"
    },
    {
        "function_name": "deleteCaller",
        "code": "function deleteCaller(address caller) onlyAdmin nonzeroAddress(caller) external { for (uint i = 0; i < callers.length; i++) { if (callers[i] == caller) { if (i != callers.length - 1 ) { callers[i] = callers[callers.length - 1]; } callers.length--; return; } } }",
        "vulnerability": "Caller Deletion Vulnerability",
        "reason": "The deleteCaller function allows the admin to remove any caller. However, it does not verify if the caller is being used in ongoing operations, which could lead to inconsistencies or interrupted operations if a caller is unexpectedly removed while in use.",
        "file_name": "0x28f1135e43e61ebf303c8f1f9beef4f6a00dcb34.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(address account, uint value) onlyAdmin nonzeroAddress(account) external { require(value > 0); uint balance = token.balanceOf(this); require(SafeMath.sub(balance, lockBalance) >= value); bool success = token.transfer(account, value); require(success); }",
        "vulnerability": "Potential Fund Drain by Admin",
        "reason": "The withdraw function allows the admin to withdraw funds from the contract balance that are not locked. However, there is no upper limit or additional protection against the admin withdrawing excessive funds, potentially draining the contract's available balance.",
        "file_name": "0x28f1135e43e61ebf303c8f1f9beef4f6a00dcb34.sol"
    }
]