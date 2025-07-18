[
    {
        "function_name": "commitProposal",
        "code": "function commitProposal(string txid) external returns (bool) { require((admin.status &&_existCaller(msg.sender)) || msg.sender == admin.account); require(!platform.proposals[txid].status); platform.proposals[txid].status = true; platform.proposals[txid].weight = platform.proposals[txid].voters.length; return true; }",
        "vulnerability": "Unauthorized proposal commitment",
        "reason": "The function allows a proposal to be committed if the caller is an admin or an existing caller. However, it does not check if the proposal has met the required voting weight, allowing unauthorized commitment of proposals prematurely.",
        "file_name": "0x28f1135e43e61ebf303c8f1f9beef4f6a00dcb34.sol"
    },
    {
        "function_name": "deletePublicKey",
        "code": "function deletePublicKey(address publicKey) onlyAdmin nonzeroAddress(publicKey) external { address[] storage publicKeys = platform.publicKeys; for (uint i = 0; i < publicKeys.length; i++) { if (publicKeys[i] == publicKey) { if (i != publicKeys.length - 1 ) { publicKeys[i] = publicKeys[publicKeys.length - 1]; } publicKeys.length--; return; } } }",
        "vulnerability": "Improper public key deletion logic",
        "reason": "The function attempts to delete a public key by swapping it with the last element and then reducing the array length. However, it does not properly handle the case where the public key does not exist, potentially causing unintended deletions or leaving the array in an inconsistent state.",
        "file_name": "0x28f1135e43e61ebf303c8f1f9beef4f6a00dcb34.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(address account, uint value) onlyAdmin nonzeroAddress(account) external { require(value > 0); uint balance = token.balanceOf(this); require(SafeMath.sub(balance, lockBalance) >= value); bool success = token.transfer(account, value); require(success); }",
        "vulnerability": "Unsafe withdrawal mechanism",
        "reason": "The function allows the admin to withdraw tokens that are not locked. However, without further restrictions, the admin can potentially withdraw all unlocked tokens, leading to a complete drain of the contract's balance that is not locked, which can be exploited by a malicious admin.",
        "file_name": "0x28f1135e43e61ebf303c8f1f9beef4f6a00dcb34.sol"
    }
]