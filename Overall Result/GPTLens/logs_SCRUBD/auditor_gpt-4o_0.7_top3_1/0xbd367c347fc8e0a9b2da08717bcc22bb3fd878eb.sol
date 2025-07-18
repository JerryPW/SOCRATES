[
    {
        "function_name": "transfer",
        "code": "function transfer(address _to, uint256 _value) returns (bool) { require(_to != address(0)); balances[msg.sender] = balances[msg.sender].sub(_value); balances[_to] = balances[_to].add(_value); Transfer(msg.sender, _to, _value); return true; }",
        "vulnerability": "Missing balance check before subtraction",
        "reason": "The transfer function does not check if the sender has enough balance before subtracting _value from balances[msg.sender]. This can lead to an underflow if the sender's balance is less than _value, causing an unintended large balance for the sender and potentially allowing unauthorized token transfer.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) returns (bool) { require(_to != address(0)); var _allowance = allowed[_from][msg.sender]; balances[_from] = balances[_from].sub(_value); balances[_to] = balances[_to].add(_value); allowed[_from][msg.sender] = _allowance.sub(_value); Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Missing balance check before subtraction",
        "reason": "The transferFrom function does not check if the _from address has enough balance before subtracting _value from balances[_from]. This can lead to an underflow if _from's balance is less than _value, causing an unintended large balance for _from and potentially allowing unauthorized token transfer.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    },
    {
        "function_name": "removeAssetsOwner",
        "code": "function removeAssetsOwner(address _owner) public onlyOwner { uint index = assetOwnersIndex[_owner]; delete assetOwnersIndex[_owner]; delete assetOwners[index]; assetOwnersIndexes--; }",
        "vulnerability": "Potential data inconsistency",
        "reason": "The removeAssetsOwner function decreases the assetOwnersIndexes count without properly maintaining the mapping integrity. This can cause data inconsistency and potential mapping key collisions, leading to incorrect owner management.",
        "file_name": "0xbd367c347fc8e0a9b2da08717bcc22bb3fd878eb.sol"
    }
]