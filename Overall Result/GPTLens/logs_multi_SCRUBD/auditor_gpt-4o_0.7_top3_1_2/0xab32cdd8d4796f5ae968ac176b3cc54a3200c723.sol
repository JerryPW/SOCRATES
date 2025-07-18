[
    {
        "function_name": "function()",
        "code": "function() public payable { require( msg.value >= minfinney ); if (now < start || now > (start + duration)) revert(); uint qty = multiply( divide( multiply( msg.value, tokpereth ), 1e20), (bonus() + 100) ); if (qty > tokenSC.balanceOf(address(this)) || qty < 1) revert(); tokenSC.transfer( msg.sender, qty ); if (treasury != address(0)) treasury.transfer( msg.value ); }",
        "vulnerability": "Reentrancy in fallback function",
        "reason": "The fallback function transfers Ether to the treasury after transferring tokens to the sender. If the token contract is malicious, it could re-enter before the treasury transfer, potentially causing inconsistencies or draining funds.",
        "file_name": "0xab32cdd8d4796f5ae968ac176b3cc54a3200c723.sol"
    },
    {
        "function_name": "setToken",
        "code": "function setToken( address erc ) public onlyOwner { tokenSC = ERC20(erc); }",
        "vulnerability": "Token contract replacement",
        "reason": "The owner can change the token contract to another arbitrary address, potentially a malicious one, allowing them to execute arbitrary code during token transfers. This can result in significant security risks, such as token theft.",
        "file_name": "0xab32cdd8d4796f5ae968ac176b3cc54a3200c723.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw( uint amount ) public onlyOwner returns (bool) { require ( treasury == address(0) && amount <= address(this).balance ); return owner.send( amount ); }",
        "vulnerability": "Use of send function",
        "reason": "Using the send function to transfer Ether can lead to potential failures due to its limited gas stipend, causing the withdrawal to fail if the owner is a contract with a fallback function requiring more gas. This could lock funds in the contract.",
        "file_name": "0xab32cdd8d4796f5ae968ac176b3cc54a3200c723.sol"
    }
]