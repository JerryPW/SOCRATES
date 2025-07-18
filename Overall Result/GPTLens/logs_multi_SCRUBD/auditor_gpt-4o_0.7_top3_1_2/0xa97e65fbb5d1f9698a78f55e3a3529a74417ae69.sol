[
    {
        "function_name": "GOOGToken",
        "code": "function GOOGToken () public { uint256 _initialSupply = (2**256)-1; totalSupply = _initialSupply; balanceOf[msg.sender] = totalSupply; }",
        "vulnerability": "Overflow in initial supply",
        "reason": "The initial supply is set to the maximum value of a uint256, which is 2^256 - 1. This could potentially cause overflow issues in calculations involving the total supply. It also gives an absurdly high number of tokens to the contract deployer, which could lead to market manipulation and devaluation of the token.",
        "file_name": "0xa97e65fbb5d1f9698a78f55e3a3529a74417ae69.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { require(_value <= balanceOf[_from]); require(_value <= allowance[_from][msg.sender]); balanceOf[_from] -= _value; balanceOf[_to] += _value; allowance[_from][msg.sender] -= _value; Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Lack of event emission for approval change",
        "reason": "The function does not emit an Approval event after modifying the allowance. This could lead to inconsistencies in off-chain systems that rely on the event log to track allowance changes, potentially causing unexpected behavior in token transfers.",
        "file_name": "0xa97e65fbb5d1f9698a78f55e3a3529a74417ae69.sol"
    },
    {
        "function_name": "endSale",
        "code": "function endSale() public { require(msg.sender == admin); require(tokenContract.transfer(admin, tokenContract.balanceOf(this))); admin.transfer(address(this).balance); }",
        "vulnerability": "Potential reentrancy in endSale",
        "reason": "The function first transfers tokens and then transfers ether. While the token transfer is not directly reentrant, if the token contract allows for reentrancy either through a fallback function or another mechanism, it could be exploited. Additionally, transferring ether last is a bad practice as it opens up the potential for reentrancy if the external call (token transfer) allows reentrancy.",
        "file_name": "0xa97e65fbb5d1f9698a78f55e3a3529a74417ae69.sol"
    }
]