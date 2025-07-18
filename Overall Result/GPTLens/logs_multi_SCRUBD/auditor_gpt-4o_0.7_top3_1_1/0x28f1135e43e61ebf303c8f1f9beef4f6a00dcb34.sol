[
    {
        "function_name": "commitProposal",
        "code": "function commitProposal(string txid) external returns (bool) { require((admin.status &&_existCaller(msg.sender)) || msg.sender == admin.account); require(!platform.proposals[txid].status); platform.proposals[txid].status = true; platform.proposals[txid].weight = platform.proposals[txid].voters.length; return true; }",
        "vulnerability": "Improper Access Control",
        "reason": "The function allows any caller in the 'callers' list to commit proposals if the admin status is true, without verifying if the proposal has met the required conditions such as minimum number of votes. An attacker who becomes an authorized caller can commit proposals prematurely.",
        "file_name": "0x28f1135e43e61ebf303c8f1f9beef4f6a00dcb34.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock(string txid, address fromAccount, address toAccount, uint value) nonzeroAddress(toAccount) external { require(admin.status == 1 || admin.status == 3); require(xcPlugin.getStatus()); require(value > 0); bool complete; bool verify; (complete, verify) = xcPlugin.verifyProposal(fromAccount, toAccount, value, txid); require(verify && !complete); uint balance = token.balanceOf(this); require(balance >= value); require(token.transfer(toAccount, value)); require(xcPlugin.commitProposal(txid)); lockBalance = SafeMath.sub(lockBalance, value); emit Unlock(txid, xcPlugin.getTrustPlatform(), fromAccount, bytes32(value), xcPlugin.getTokenSymbol()); }",
        "vulnerability": "Incomplete Proposal Verification",
        "reason": "The function relies on 'verifyProposal' to check if a proposal can be unlocked. However, the 'commitProposal' function does not enforce strong conditions on proposals being marked as complete, meaning an attacker could exploit this function to unlock tokens without proper consensus.",
        "file_name": "0x28f1135e43e61ebf303c8f1f9beef4f6a00dcb34.sol"
    },
    {
        "function_name": "deleteProposal",
        "code": "function deleteProposal(string txid) onlyAdmin external { delete platform.proposals[txid]; }",
        "vulnerability": "Proposal Deletion Without Restriction",
        "reason": "The function allows the admin to delete any proposal, potentially removing records of legitimate proposals or votes. This can be exploited by a malicious admin to erase traces of proposals that have not been favorable to them or to disrupt the normal workflow of proposal handling.",
        "file_name": "0x28f1135e43e61ebf303c8f1f9beef4f6a00dcb34.sol"
    }
]