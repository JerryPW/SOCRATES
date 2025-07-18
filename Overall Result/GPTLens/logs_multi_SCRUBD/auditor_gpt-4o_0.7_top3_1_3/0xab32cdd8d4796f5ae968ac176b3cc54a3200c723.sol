[
    {
        "function_name": "function()",
        "code": "function() public payable { require( msg.value >= minfinney ); if (now < start || now > (start + duration)) revert(); uint qty = multiply( divide( multiply( msg.value, tokpereth ), 1e20), (bonus() + 100) ); if (qty > tokenSC.balanceOf(address(this)) || qty < 1) revert(); tokenSC.transfer( msg.sender, qty ); if (treasury != address(0)) treasury.transfer( msg.value ); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function allows for the transfer of Ether to the treasury after token transfer, which is a state change. If the treasury address is a contract with a fallback function, it could potentially invoke a reentrancy attack during the Ether transfer. This attack could lead to multiple purchases being processed before the balance is updated.",
        "file_name": "0xab32cdd8d4796f5ae968ac176b3cc54a3200c723.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw( uint amount ) public onlyOwner returns (bool) { require ( treasury == address(0) && amount <= address(this).balance ); return owner.send( amount ); }",
        "vulnerability": "Unsafe use of send()",
        "reason": "The 'send' method is used to transfer Ether, which only forwards 2300 gas. If the recipient is a smart contract with complex logic in the fallback function, it may fail. This may lead to Ether being locked in the contract, making it inaccessible.",
        "file_name": "0xab32cdd8d4796f5ae968ac176b3cc54a3200c723.sol"
    },
    {
        "function_name": "setToken",
        "code": "function setToken( address erc ) public onlyOwner { tokenSC = ERC20(erc); }",
        "vulnerability": "Token contract change vulnerability",
        "reason": "The owner can change the ERC20 token contract at any time using the 'setToken' function. This could be exploited to swap the token for another that has no value, or even a malicious contract, leading to loss of funds for investors who purchased tokens from the ICO.",
        "file_name": "0xab32cdd8d4796f5ae968ac176b3cc54a3200c723.sol"
    }
]