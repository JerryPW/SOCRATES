[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) public returns (bool) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "race_condition_allowance_change",
        "reason": "The approve function allows changing of allowance without considering the current allowance, which could lead to a race condition where the spender can spend both the old and new allowance if transactions are not mined in the intended order. This is known as the 'approve/transferFrom race condition'. Attackers can exploit this to spend more tokens than intended, by front-running an allowance change.",
        "file_name": "0xc86dd185fc95031489b89eeaaa3fd47e11c065e9.sol"
    },
    {
        "function_name": "removeAssetsOwner",
        "code": "function removeAssetsOwner(address _owner) public onlyOwner { uint index = assetOwnersIndex[_owner]; delete assetOwnersIndex[_owner]; delete assetOwners[index]; assetOwnersIndexes--; }",
        "vulnerability": "array_index_reuse",
        "reason": "The removeAssetsOwner function decreases the assetOwnersIndexes counter without properly checking the structural integrity of the mapping, which might cause re-use of indexes and potential inconsistencies in the mapping state. This opens up for potential errors in accessing asset owners, possibly allowing manipulation of the asset ownership structure by an attacker.",
        "file_name": "0xc86dd185fc95031489b89eeaaa3fd47e11c065e9.sol"
    },
    {
        "function_name": "returnTokens",
        "code": "function returnTokens(uint nTokens) public onlyOwner returns (bool) { require(nTokens <= getBalance()); token.transfer(msg.sender, nTokens); TokensTransfered(msg.sender, nTokens); return true; }",
        "vulnerability": "arbitrary_token_withdrawal",
        "reason": "The returnTokens function allows the owner to withdraw tokens from the contract arbitrarily. This could be exploited if the contract owner is malicious or if the ownership is compromised, leading to potential loss of the contract's token balance.",
        "file_name": "0xc86dd185fc95031489b89eeaaa3fd47e11c065e9.sol"
    }
]