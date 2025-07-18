[
    {
        "function_name": "constructor",
        "code": "constructor (uint256 _initialSupply) public { balanceOf[msg.sender] = _initialSupply; _totalSupply = _initialSupply; }",
        "vulnerability": "Fixed total supply not enforced",
        "reason": "The constructor sets the total supply based on the input parameter _initialSupply, but the _totalSupply variable is initially set to a fixed value (100000000) which is misleading. An attacker could deploy multiple instances of the contract with different initial supplies, leading to confusion about the actual total supply across different instances.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    },
    {
        "function_name": "endSale",
        "code": "function endSale() public { require(msg.sender == admin); require(tokenContract.transfer(admin, tokenContract.balanceOf(this))); admin.transfer(address(this).balance); }",
        "vulnerability": "Unsafe ether transfer without checks",
        "reason": "The endSale function transfers all Ether in the contract to the admin without checking if the transfer was successful. If the admin is a contract, the fallback function of the admin contract may consume more than 2300 gas, causing the transfer to fail and locking the funds in the contract.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    },
    {
        "function_name": "buyTokens",
        "code": "function buyTokens(uint256 _numberOfTokens) public payable { require(msg.value == multiply(_numberOfTokens, tokenPrice)); require(tokenContract.balanceOf(this) >= _numberOfTokens); require(tokenContract.transfer(msg.sender, _numberOfTokens)); tokensSold += _numberOfTokens; emit Sell(msg.sender, _numberOfTokens); }",
        "vulnerability": "Potential reentrancy in token sale",
        "reason": "The buyTokens function calls an external contract's transfer function before updating the state variable tokensSold. If the token contract's transfer function is vulnerable to reentrancy, it could allow an attacker to call buyTokens again before tokensSold is updated, leading to incorrect accounting of tokens sold.",
        "file_name": "0xf796eb0a13b5a75e94f13fd14fb66b2b8007f69b.sol"
    }
]