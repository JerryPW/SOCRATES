[
    {
        "function_name": "constructor",
        "code": "constructor (uint256 _initialSupply) public { balanceOf[msg.sender] = _initialSupply; _totalSupply = _initialSupply; }",
        "vulnerability": "Initial token supply not correctly distributed",
        "reason": "The constructor is supposed to initialize the total supply and allocate tokens to the creator. However, the _totalSupply is set to the parameter _initialSupply, which is not necessarily the intended total supply. If a user passes a different value than the hardcoded _totalSupply, the actual supply available for trading could be different, leading to potential discrepancies and unexpected behavior.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { require(_value <= balanceOf[_from]); require(_value <= allowance[_from][msg.sender]); balanceOf[_from] -= _value; balanceOf[_to] += _value; allowance[_from][msg.sender] -= _value; emit Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Lack of safe math operations",
        "reason": "The transferFrom function does not use safe math operations to handle arithmetic operations. This can lead to integer overflow or underflow when manipulating balances and allowances, potentially allowing attackers to transfer more tokens than they should be able to, thus compromising the token's integrity.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    },
    {
        "function_name": "endSale",
        "code": "function endSale() public { require(msg.sender == admin); require(tokenContract.transfer(admin, tokenContract.balanceOf(this))); admin.transfer(address(this).balance); }",
        "vulnerability": "Potential loss of Ether during token sale ending",
        "reason": "The endSale function transfers all the remaining tokens back to the admin and then transfers the contract's Ether balance to the admin. However, if the tokenContract.transfer fails (e.g., due to insufficient tokens or a failed token transfer), the contract will remain with its Ether balance, which can be stuck if not handled properly, leading to potential loss of funds.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    }
]