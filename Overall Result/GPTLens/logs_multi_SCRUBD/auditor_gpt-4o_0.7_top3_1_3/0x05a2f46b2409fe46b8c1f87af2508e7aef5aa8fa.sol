[
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens(address tokenContract) public { Token tc = Token(tokenContract); tc.transfer(owner, tc.balanceOf(this)); }",
        "vulnerability": "Missing access control",
        "reason": "The withdrawTokens function lacks access control, allowing any user to call it and transfer all tokens from the contract to the owner. This enables an attacker to drain all token balances from the contract for the benefit of the owner, even if the owner did not intend for tokens to be withdrawn at that time.",
        "file_name": "0x05a2f46b2409fe46b8c1f87af2508e7aef5aa8fa.sol"
    },
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther() public { owner.transfer(this.balance); }",
        "vulnerability": "Missing access control",
        "reason": "Similar to withdrawTokens, the withdrawEther function is missing access control mechanisms. Any user can call this function to transfer all Ether from the contract to the owner's address, potentially allowing an attacker to deplete the contract's Ether balance and deny other legitimate operations dependent on that balance.",
        "file_name": "0x05a2f46b2409fe46b8c1f87af2508e7aef5aa8fa.sol"
    },
    {
        "function_name": "getTokens",
        "code": "function getTokens(uint num, address addr) public { for(uint i = 0; i < num; i++){ addr.call.value(0 wei)(); } }",
        "vulnerability": "Reentrancy and DOS from untrusted call",
        "reason": "The getTokens function uses an untrusted external call in a loop without any control over the number of iterations, which can lead to Denial of Service (DoS) by consuming all gas. Additionally, if the called contract has a fallback function with reentrancy logic, it can potentially exploit the lack of state changes prior to the call to execute unexpected actions on the EtherGet contract.",
        "file_name": "0x05a2f46b2409fe46b8c1f87af2508e7aef5aa8fa.sol"
    }
]