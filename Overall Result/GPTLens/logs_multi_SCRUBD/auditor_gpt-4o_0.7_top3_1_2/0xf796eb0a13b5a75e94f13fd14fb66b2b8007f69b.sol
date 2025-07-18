[
    {
        "function_name": "constructor",
        "code": "constructor (uint256 _initialSupply) public { balanceOf[msg.sender] = _initialSupply; _totalSupply = _initialSupply; }",
        "vulnerability": "Constructor does not set total supply correctly",
        "reason": "The constructor allows the creator to set the total supply of the token, but the public variable `_totalSupply` is already initialized to 100000000. This can cause confusion and potentially lead to unintended behaviors if a different initial supply is expected.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { require(_value <= balanceOf[_from]); require(_value <= allowance[_from][msg.sender]); balanceOf[_from] -= _value; balanceOf[_to] += _value; allowance[_from][msg.sender] -= _value; emit Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Missing zero address check",
        "reason": "The function does not check if `_to` is the zero address, which can lead to tokens being sent to the zero address and thus being irretrievable, effectively burning them. This can be exploited to destroy tokens maliciously.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    },
    {
        "function_name": "endSale",
        "code": "function endSale() public { require(msg.sender == admin); require(tokenContract.transfer(admin, tokenContract.balanceOf(this))); admin.transfer(address(this).balance); }",
        "vulnerability": "Unsafe transfer of Ether",
        "reason": "The contract uses `admin.transfer`, which forwards a fixed amount of gas and can fail if the gas requirement is higher due to fallback functions or other reasons. This can lead to scenarios where the sale cannot be ended properly if the transfer fails.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    }
]