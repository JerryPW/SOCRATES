[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) returns (bool) { require(_to != address(0)); var _allowance = allowed[_from][msg.sender]; balances[_from] = balances[_from].sub(_value); balances[_to] = balances[_to].add(_value); allowed[_from][msg.sender] = _allowance.sub(_value); Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Missing allowance check",
        "reason": "The transferFrom function does not check if the _allowance value is sufficient before subtracting _value from it. This could lead to unintended fund transfers because the function will revert only after the subtraction, allowing for the potential manipulation of balances.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) returns (bool) { require((_value == 0) || (allowed[msg.sender][_spender] == 0)); allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race condition on allowance change",
        "reason": "The approve function has a potential race condition vulnerability if a spender is able to use the current allowance while it's being changed. If the spender is able to make a transaction before the allowance is set to a new value, they may be able to spend both the old and new allowance.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    },
    {
        "function_name": "removeAssetsOwner",
        "code": "function removeAssetsOwner(address _owner) public onlyOwner { uint index = assetOwnersIndex[_owner]; delete assetOwnersIndex[_owner]; delete assetOwners[index]; assetOwnersIndexes--; }",
        "vulnerability": "Incorrect index management",
        "reason": "When removing an asset owner, decrementing assetOwnersIndexes without correctly managing the indices could result in inconsistencies in the assetOwners mapping, potentially leading to gaps and incorrect owner references.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    }
]