[
    {
        "function_name": "transfer",
        "code": "function transfer(uint _sreur_tokens, address[] _addresses) onlyOwner returns (bool) { if(_sreur_tokens < 1) throw; uint amount = _sreur_tokens*100000000; for (uint i = 0; i < _addresses.length; i++) { c.call(bytes4(sha3(\"transfer(address,uint256)\")),_addresses[i], amount); } return true; }",
        "vulnerability": "Use of call without checking return value",
        "reason": "The use of `c.call` for invoking the `transfer` function on an external contract does not check the return value. If the call fails, the transaction will not revert, potentially causing token loss or incomplete transfers which attackers could exploit to disrupt token distribution.",
        "file_name": "0xbd8dbefb4e1217e95fa37201c61daf4b57a9fe19.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() onlyOwner returns (bool result) { owner.send(this.balance); return true; }",
        "vulnerability": "Use of send method without checking return value",
        "reason": "The `withdraw` function uses the `send` method to transfer funds to the owner without checking the return value. The `send` method can fail, especially if the receiving address is a contract with a fallback function that uses more than 2300 gas. This can lead to locked funds within the contract if send fails and is not handled appropriately.",
        "file_name": "0xbd8dbefb4e1217e95fa37201c61daf4b57a9fe19.sol"
    },
    {
        "function_name": "fallback",
        "code": "function() payable { }",
        "vulnerability": "Lack of access control on fallback function",
        "reason": "The fallback function is payable and does not have access restrictions, allowing anyone to send ether to the contract. This could lead to accidental ether deposits with no means of recovery for non-owners, as only the owner can withdraw funds with the `withdraw` function.",
        "file_name": "0xbd8dbefb4e1217e95fa37201c61daf4b57a9fe19.sol"
    }
]