[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) returns (bool) { require(_to != address(0)); var _allowance = allowed[_from][msg.sender]; balances[_from] = balances[_from].sub(_value); balances[_to] = balances[_to].add(_value); allowed[_from][msg.sender] = _allowance.sub(_value); Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Missing allowance check",
        "reason": "The function does not check if the `_value` is within the `_allowance` before performing the operations. This allows an attacker to exploit the function by transferring more tokens than initially intended, potentially leading to unauthorized transfers.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) returns (bool) { require((_value == 0) || (allowed[msg.sender][_spender] == 0)); allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race condition on allowance change",
        "reason": "The `approve` function does not protect against double-spend attacks due to a race condition. If a spender is able to execute a transaction with the current allowance before the allowance is reset to zero, it can lead to spending of both the old and the new allowance.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    },
    {
        "function_name": "removeAssetsOwner",
        "code": "function removeAssetsOwner(address _owner) public onlyOwner { uint index = assetOwnersIndex[_owner]; delete assetOwnersIndex[_owner]; delete assetOwners[index]; assetOwnersIndexes--; }",
        "vulnerability": "Inconsistent state update",
        "reason": "The function decreases `assetOwnersIndexes` without handling the index properly, leading to potential inconsistencies in the `assetOwners` and `assetOwnersIndexes` mappings. This can result in incorrect asset owner management and potential unauthorized asset ownership changes.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    }
]