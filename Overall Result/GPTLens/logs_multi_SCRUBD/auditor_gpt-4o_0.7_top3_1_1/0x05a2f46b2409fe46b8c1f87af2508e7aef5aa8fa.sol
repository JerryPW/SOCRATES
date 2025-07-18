[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens(address tokenContract) public { Token tc = Token(tokenContract); tc.transfer(owner, tc.balanceOf(this)); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The withdrawTokens function allows any caller to transfer all tokens from the contract to the owner's address. There is no restriction on who can call this function, making it possible for an attacker to deplete the contract of its token holdings by calling this function.",
        "file_name": "0x05a2f46b2409fe46b8c1f87af2508e7aef5aa8fa.sol"
    },
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther() public { owner.transfer(this.balance); }",
        "vulnerability": "Lack of Access Control",
        "reason": "Similar to the withdrawTokens function, withdrawEther does not have any access control measures in place. This allows any user to call the function and transfer all Ether held by the contract to the owner's address. An attacker could use this to empty the contract of its Ether balance.",
        "file_name": "0x05a2f46b2409fe46b8c1f87af2508e7aef5aa8fa.sol"
    },
    {
        "function_name": "getTokens",
        "code": "function getTokens(uint num, address addr) public { for(uint i = 0; i < num; i++){ addr.call.value(0 wei)(); } }",
        "vulnerability": "Denial of Service (DoS) via uncontrolled loop",
        "reason": "The getTokens function allows the caller to specify the number of iterations for the loop. An attacker could set a very high value for 'num', leading to a significant amount of gas being consumed, potentially causing the transaction to fail or exhaust the block gas limit. This could result in a Denial of Service condition.",
        "file_name": "0x05a2f46b2409fe46b8c1f87af2508e7aef5aa8fa.sol"
    }
]