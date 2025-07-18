[
    {
        "function_name": "WithdrawToken",
        "code": "function WithdrawToken(address token, uint256 amount,address to) public onlyOwner { token.call(bytes4(sha3(\"transfer(address,uint256)\")),to,amount); }",
        "vulnerability": "Arbitrary token transfer via unchecked call",
        "reason": "The WithdrawToken function uses the low-level call function to transfer tokens without checking if the target contract actually supports the token transfer function. This can lead to failed transfers that go undetected or unexpected behavior if the token contract does not conform to the expected interface.",
        "file_name": "0x8fd1e427396ddb511533cf9abdbebd0a7e08da35.sol"
    },
    {
        "function_name": "WitdrawTokenToHolder",
        "code": "function WitdrawTokenToHolder(address _to,address _token,uint _amount) public onlyOwner { if(Holders[_to]>0) { Holders[_to]=0; WithdrawToken(_token,_amount,_to); } }",
        "vulnerability": "Incorrect Holder balance update",
        "reason": "The WitdrawTokenToHolder function sets the Holder's balance to zero before transferring tokens. This can be exploited if the token transfer fails, as the Holder's balance would still be zero, effectively losing their funds. Additionally, it does not check if the Holder actually has enough tokens in the bank to cover the withdrawal.",
        "file_name": "0x8fd1e427396ddb511533cf9abdbebd0a7e08da35.sol"
    },
    {
        "function_name": "WithdrawToHolder",
        "code": "function WithdrawToHolder(address _addr, uint _wei) public onlyOwner payable { if(Holders[msg.sender]>0) { if(Holders[_addr]>=_wei) { _addr.call.value(_wei); Holders[_addr]-=_wei; } } }",
        "vulnerability": "Reentrancy attack vulnerability",
        "reason": "The WithdrawToHolder function allows for a reentrancy attack as it sends Ether to an address using the low-level call without ensuring that the state changes (updating the Holders map) are made before the call. An attacker could exploit this by re-entering the contract and manipulating their balance before it's correctly updated, potentially extracting more funds than intended.",
        "file_name": "0x8fd1e427396ddb511533cf9abdbebd0a7e08da35.sol"
    }
]