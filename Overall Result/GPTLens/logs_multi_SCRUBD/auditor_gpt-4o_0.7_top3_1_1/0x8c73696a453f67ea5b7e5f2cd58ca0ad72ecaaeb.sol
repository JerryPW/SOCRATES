[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to].add(_value) > balances[_to]) { balances[_to] = _value.add(balances[_to]); balances[_from] = balances[_from].sub(_value); allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); emit Transfer(_from, _to, _value); return true; } else { return false; } }",
        "vulnerability": "Incorrect balance update order",
        "reason": "The function updates the balance of the recipient before subtracting the allowance and sender's balance, which could lead to re-entrancy issues. If an external call is made after the recipient's balance is updated, it might exploit this inconsistency.",
        "file_name": "0x8c73696a453f67ea5b7e5f2cd58ca0ad72ecaaeb.sol"
    },
    {
        "function_name": "deposit",
        "code": "function deposit(address _userAddress, uint256 _amount, uint256 _days) public ownerOnly { require(_amount > 0); require(md.transferFrom(_userAddress, this, _amount)); uint256 releaseTime = block.timestamp + _days * 1 days; LockRecord memory r = LockRecord(_userAddress, _amount, releaseTime); uint256 l = lockRecords.push(r); emit Deposit(_userAddress, _amount, releaseTime, l.sub(1)); }",
        "vulnerability": "Lack of validation for transferFrom call",
        "reason": "The deposit function assumes that transferFrom will always succeed. There's no check to see if the transferFrom function call actually resulted in the expected transfer, which could lead to a state where the deposit is considered successful even if the tokens were not transferred.",
        "file_name": "0x8c73696a453f67ea5b7e5f2cd58ca0ad72ecaaeb.sol"
    },
    {
        "function_name": "constructor (TokenLock)",
        "code": "constructor(address _owner, address _md_address) public{ owner = _owner; md_address = _md_address; md = MD(md_address); }",
        "vulnerability": "Unrestricted token contract reference",
        "reason": "The constructor accepts an arbitrary token contract address for md_address without verification. An attacker could deploy a malicious token contract with the same interface but with malicious behavior to exploit this contract.",
        "file_name": "0x8c73696a453f67ea5b7e5f2cd58ca0ad72ecaaeb.sol"
    }
]