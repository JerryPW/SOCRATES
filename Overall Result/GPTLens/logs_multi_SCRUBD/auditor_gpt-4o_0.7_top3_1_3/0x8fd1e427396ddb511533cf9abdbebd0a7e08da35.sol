[
    {
        "function_name": "WithdrawToken",
        "code": "function WithdrawToken(address token, uint256 amount,address to) public onlyOwner { token.call(bytes4(sha3(\"transfer(address,uint256)\")),to,amount); }",
        "vulnerability": "Unchecked low-level call",
        "reason": "The function uses a low-level call to invoke the transfer function on an ERC20 token contract. This call does not check if the transfer was successful, which can lead to a loss of tokens if the transfer fails. An attacker could exploit this by sending a token that always fails on transfer, causing a loss of ether without receiving the respective tokens.",
        "file_name": "0x8fd1e427396ddb511533cf9abdbebd0a7e08da35.sol"
    },
    {
        "function_name": "WitdrawTokenToHolder",
        "code": "function WitdrawTokenToHolder(address _to,address _token,uint _amount) public onlyOwner { if(Holders[_to]>0) { Holders[_to]=0; WithdrawToken(_token,_amount,_to); } }",
        "vulnerability": "Incorrect token holder balance reset",
        "reason": "The function resets the holder's balance to zero before attempting to transfer tokens. If the transfer fails (due to the unchecked low-level call in WithdrawToken), the holder's balance is still zeroed out, resulting in a loss of recorded balance without any successful token transfer.",
        "file_name": "0x8fd1e427396ddb511533cf9abdbebd0a7e08da35.sol"
    },
    {
        "function_name": "WithdrawToHolder",
        "code": "function WithdrawToHolder(address _addr, uint _wei) public onlyOwner payable { if(Holders[msg.sender]>0) { if(Holders[_addr]>=_wei) { _addr.call.value(_wei); Holders[_addr]-=_wei; } } }",
        "vulnerability": "Reentrancy due to low-level call",
        "reason": "The function uses a low-level call to send ether, which can lead to reentrancy attacks. An attacker could re-enter into the contract before the holder's balance is updated, allowing them to withdraw more funds than they should be able to, depleting the contract's balance.",
        "file_name": "0x8fd1e427396ddb511533cf9abdbebd0a7e08da35.sol"
    }
]