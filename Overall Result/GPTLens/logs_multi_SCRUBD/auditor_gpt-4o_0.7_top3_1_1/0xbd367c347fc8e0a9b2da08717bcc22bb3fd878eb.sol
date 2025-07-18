[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) returns (bool) { require(_to != address(0)); var _allowance = allowed[_from][msg.sender]; balances[_from] = balances[_from].sub(_value); balances[_to] = balances[_to].add(_value); allowed[_from][msg.sender] = _allowance.sub(_value); Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Lack of allowance check before state changes",
        "reason": "The function does not check if the '_allowance' is sufficient before making state changes to 'balances'. This can lead to unexpected behavior where funds are deducted from '_from' even if the allowance is insufficient, violating the ERC20 specification.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) returns (bool) { require((_value == 0) || (allowed[msg.sender][_spender] == 0)); allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race condition on allowance setting",
        "reason": "This function allows the possibility of a race condition when changing the allowance. If a spender is allowed to transfer tokens and the allowance is set again (even to zero and then to a new value), there is a window where the spender can use both the old and new allowance. This may lead to double spending.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    },
    {
        "function_name": "removeAssetsOwner",
        "code": "function removeAssetsOwner(address _owner) public onlyOwner { uint index = assetOwnersIndex[_owner]; delete assetOwnersIndex[_owner]; delete assetOwners[index]; assetOwnersIndexes--; }",
        "vulnerability": "Incorrect handling of assetOwnersIndexes",
        "reason": "When removing an asset owner, the 'assetOwnersIndexes' is decremented without considering whether the deleted owner was actually the last in the mapping. This can lead to inconsistencies in the asset owners' list and potential mismanagement of asset ownership.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    }
]