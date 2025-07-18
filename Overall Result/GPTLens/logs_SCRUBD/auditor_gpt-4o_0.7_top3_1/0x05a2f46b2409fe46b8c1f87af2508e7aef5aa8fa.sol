[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens(address tokenContract) public { Token tc = Token(tokenContract); tc.transfer(owner, tc.balanceOf(this)); }",
        "vulnerability": "Arbitrary Token Withdrawal",
        "reason": "The withdrawTokens function allows any caller to transfer all tokens from the contract to the owner's address. There is no access control, meaning anyone can call this function and move tokens, leading to unauthorized token withdrawals.",
        "file_name": "0x05a2f46b2409fe46b8c1f87af2508e7aef5aa8fa.sol"
    },
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther() public { owner.transfer(this.balance); }",
        "vulnerability": "Unrestricted Ether Withdrawal",
        "reason": "The withdrawEther function can be called by anyone to transfer all Ether from the contract to the owner's address. This function lacks access control, allowing any user to trigger the withdrawal and potentially block the owner from executing it when intended.",
        "file_name": "0x05a2f46b2409fe46b8c1f87af2508e7aef5aa8fa.sol"
    },
    {
        "function_name": "getTokens",
        "code": "function getTokens(uint num, address addr) public { for(uint i = 0; i < num; i++){ addr.call.value(0 wei)(); } }",
        "vulnerability": "Reentrancy and Denial of Service (DoS) Risk",
        "reason": "The getTokens function allows the caller to execute an arbitrary number of calls to the specified address with the potential for reentrancy attacks, especially if the address is a contract with fallback or receive functions. This can be exploited to create reentrancy conditions or lead to a denial of service by exhausting gas limits.",
        "file_name": "0x05a2f46b2409fe46b8c1f87af2508e7aef5aa8fa.sol"
    }
]