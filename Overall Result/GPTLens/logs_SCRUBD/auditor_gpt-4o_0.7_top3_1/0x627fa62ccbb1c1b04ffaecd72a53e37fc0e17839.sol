[
    {
        "function_name": "WithdrawToken",
        "code": "function WithdrawToken(address token, uint256 amount, address to) public onlyOwner { token.call(bytes4(sha3(\"transfer(address,uint256)\")),to,amount); }",
        "vulnerability": "Untrusted call vulnerability",
        "reason": "The use of 'call' to transfer tokens does not ensure that the function call was successful. If the call fails, the transaction will not revert, leading to potential loss of tokens or unexpected behavior. This is exploitable if the token contract does not handle 'transfer' calls properly, potentially allowing tokens to be locked or lost.",
        "file_name": "0x627fa62ccbb1c1b04ffaecd72a53e37fc0e17839.sol"
    },
    {
        "function_name": "initTokenBank",
        "code": "function initTokenBank() public { owner = msg.sender; MinDeposit = 1 ether; }",
        "vulnerability": "Re-initialization vulnerability",
        "reason": "The 'initTokenBank' function can be called by anyone to reset the owner to themselves and set the MinDeposit to 1 ether. This allows any attacker to take over the contract after it has been deployed, effectively making them the owner and enabling them to withdraw all funds from Holders.",
        "file_name": "0x627fa62ccbb1c1b04ffaecd72a53e37fc0e17839.sol"
    },
    {
        "function_name": "WithdrawToHolder",
        "code": "function WithdrawToHolder(address _addr, uint _wei) public onlyOwner payable { if(Holders[_addr]>0) { if(_addr.call.value(_wei)()) { Holders[_addr]-=_wei; } } }",
        "vulnerability": "Re-entrancy vulnerability",
        "reason": "The 'WithdrawToHolder' function sends ether to an address using 'call', which allows for re-entrancy attacks. If the recipient is a contract with a fallback function, it can recursively call 'WithdrawToHolder' before the balance is updated, potentially draining the contract of funds.",
        "file_name": "0x627fa62ccbb1c1b04ffaecd72a53e37fc0e17839.sol"
    }
]