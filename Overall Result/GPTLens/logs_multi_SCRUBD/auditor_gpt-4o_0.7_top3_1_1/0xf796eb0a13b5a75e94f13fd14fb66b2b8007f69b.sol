[
    {
        "function_name": "constructor",
        "code": "constructor (uint256 _initialSupply) public { balanceOf[msg.sender] = _initialSupply; _totalSupply = _initialSupply; }",
        "vulnerability": "Incorrect total supply initialization",
        "reason": "The constructor allows setting an arbitrary initial supply, which can lead to inconsistencies with the declared total supply in the contract (_totalSupply) if the deployed instance does not set the initial supply to 100000000. This discrepancy can lead to potential misunderstandings or misuse, especially if the contract is assumed to have a fixed total supply as declared in the contract code.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    },
    {
        "function_name": "endSale",
        "code": "function endSale() public { require(msg.sender == admin); require(tokenContract.transfer(admin, tokenContract.balanceOf(this))); admin.transfer(address(this).balance); }",
        "vulnerability": "Unsafe Ether transfer",
        "reason": "The endSale function transfers the entire balance of the contract to the admin. This operation does not check for the success of the transfer, nor does it account for gas limitations or potential reentrancy attacks. If the transfer fails, the function may behave unexpectedly, and it could be exploited if the admin is a contract with a fallback function that consumes more than the 2300 gas stipend, causing the transfer to fail.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { require(_value <= balanceOf[_from]); require(_value <= allowance[_from][msg.sender]); balanceOf[_from] -= _value; balanceOf[_to] += _value; allowance[_from][msg.sender] -= _value; emit Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Potential integer underflow",
        "reason": "The transferFrom function directly subtracts from balanceOf[_from] and allowance[_from][msg.sender] without checking for potential underflows. While Solidity 0.4.2 does not have built-in overflow checks, this can lead to an integer underflow if _value is greater than balanceOf[_from] or allowance[_from][msg.sender], causing undesired behavior and potential exploitation by transferring more tokens than available.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    }
]