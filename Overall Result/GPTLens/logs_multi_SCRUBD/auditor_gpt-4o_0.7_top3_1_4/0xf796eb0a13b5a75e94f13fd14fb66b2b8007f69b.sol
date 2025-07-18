[
    {
        "function_name": "constructor",
        "code": "constructor (uint256 _initialSupply) public { balanceOf[msg.sender] = _initialSupply; _totalSupply = _initialSupply; }",
        "vulnerability": "Hardcoded total supply mismatch",
        "reason": "The constructor allows the initial supply to be set by the deployer, which can lead to a total supply mismatch as '_totalSupply' is hardcoded to 100000000 at the top of the contract but is assigned '_initialSupply' in the constructor. This can mislead users about the actual total supply of tokens, resulting in potential miscalculations and exploitation by the deployer.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { require(_value <= balanceOf[_from]); require(_value <= allowance[_from][msg.sender]); balanceOf[_from] -= _value; balanceOf[_to] += _value; allowance[_from][msg.sender] -= _value; emit Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Lack of safe math",
        "reason": "The transferFrom function does not use safe math operations for balance and allowance updates. This can lead to integer underflow or overflow attacks, potentially allowing attackers to transfer more tokens than they actually have or are allowed to spend. This vulnerability can result in unauthorized token transfers and significant financial loss.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    },
    {
        "function_name": "endSale",
        "code": "function endSale() public { require(msg.sender == admin); require(tokenContract.transfer(admin, tokenContract.balanceOf(this))); admin.transfer(address(this).balance); }",
        "vulnerability": "Potential reentrancy vulnerability",
        "reason": "The endSale function transfers ether to the admin without the checks-effects-interactions pattern. This allows for potential reentrancy attacks where an attacker could exploit the fallback function to recall the endSale function before the contract state is updated, potentially draining funds from the contract.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    }
]