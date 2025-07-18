[
    {
        "function_name": "WithdrawToken",
        "code": "function WithdrawToken(address token, uint256 amount,address to) public onlyOwner { token.call(bytes4(sha3(\"transfer(address,uint256)\")),to,amount); }",
        "vulnerability": "Unsafe external call",
        "reason": "The function uses low-level call to invoke the transfer method of an ERC20 token. This is unsafe because it does not check if the call was successful, potentially allowing an attacker to exploit the contract by causing the call to fail without reverting the transaction.",
        "file_name": "0x39cfd754c85023648bf003bea2dd498c5612abfa.sol"
    },
    {
        "function_name": "confirmOwner",
        "code": "function confirmOwner() public { if(msg.sender==newOwner) { owner=newOwner; } }",
        "vulnerability": "Potential frontrunning attack",
        "reason": "The ownership transfer process involves two separate transactions: changeOwner and confirmOwner. This opens up the contract to frontrunning attacks where an attacker can potentially become the owner by monitoring network traffic and calling confirmOwner before the intended new owner.",
        "file_name": "0x39cfd754c85023648bf003bea2dd498c5612abfa.sol"
    },
    {
        "function_name": "WithdrawToHolder",
        "code": "function WithdrawToHolder(address _addr, uint _wei) public onlyOwner payable { if(Holders[msg.sender]>0) { if(Holders[_addr]>=_wei) { _addr.call.value(_wei); Holders[_addr]-=_wei; } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of call.value without checking for a successful call and updating state variables after the call allows for a reentrancy attack. An attacker could re-enter the contract and withdraw more funds than they are entitled to by exploiting this vulnerability.",
        "file_name": "0x39cfd754c85023648bf003bea2dd498c5612abfa.sol"
    }
]