[
    {
        "function_name": "GOOGToken",
        "code": "function GOOGToken () public { uint256 _initialSupply = (2**256)-1; totalSupply = _initialSupply; balanceOf[msg.sender] = totalSupply; }",
        "vulnerability": "Integer Overflow in Initial Supply",
        "reason": "The initial supply is set to (2**256)-1, which is the maximum value a uint256 can hold. This can cause issues in the contract where operations involving totalSupply may overflow, causing unexpected and erroneous behavior.",
        "file_name": "0xa97e65fbb5d1f9698a78f55e3a3529a74417ae69.sol"
    },
    {
        "function_name": "buyTokens",
        "code": "function buyTokens() public payable { uint256 _numberOfTokens; _numberOfTokens = multiply(msg.value,tokenRate); require(tokenContract.balanceOf(this) >= _numberOfTokens); require(tokenContract.transfer(msg.sender, _numberOfTokens)); tokensSold += _numberOfTokens; Sell(msg.sender, _numberOfTokens); }",
        "vulnerability": "Lack of Reentrancy Protection",
        "reason": "The buyTokens function does not implement any form of reentrancy protection. An attacker can exploit this by calling the buyTokens function recursively within a fallback function to deplete the contract's token balance, leading to a denial of service or draining of tokens.",
        "file_name": "0xa97e65fbb5d1f9698a78f55e3a3529a74417ae69.sol"
    },
    {
        "function_name": "endSale",
        "code": "function endSale() public { require(msg.sender == admin); require(tokenContract.transfer(admin, tokenContract.balanceOf(this))); admin.transfer(address(this).balance); }",
        "vulnerability": "Lack of SafeMath and Reentrancy",
        "reason": "The endSale function transfers all remaining tokens and ether to the admin without using SafeMath operations. Further, it calls an external contract function, which can be exploited by reentrancy attacks, potentially allowing an attacker to drain the tokens and ether.",
        "file_name": "0xa97e65fbb5d1f9698a78f55e3a3529a74417ae69.sol"
    }
]