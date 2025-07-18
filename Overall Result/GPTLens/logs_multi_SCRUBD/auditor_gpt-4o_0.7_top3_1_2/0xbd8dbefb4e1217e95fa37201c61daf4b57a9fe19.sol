[
    {
        "function_name": "transfer",
        "code": "function transfer(uint _sreur_tokens, address[] _addresses) onlyOwner returns (bool) { if(_sreur_tokens < 1) throw; uint amount = _sreur_tokens*100000000; for (uint i = 0; i < _addresses.length; i++) { c.call(bytes4(sha3(\"transfer(address,uint256)\")),_addresses[i], amount); } return true; }",
        "vulnerability": "Unchecked call return value",
        "reason": "The function uses `c.call` to invoke the transfer method on the contract at address `c`, but it does not check the return value of this call. If the call fails, the loop continues without any indication of failure, potentially leading to the assumption that the transfers were successful when they were not.",
        "file_name": "0xbd8dbefb4e1217e95fa37201c61daf4b57a9fe19.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() onlyOwner returns (bool result) { owner.send(this.balance); return true; }",
        "vulnerability": "Unsafe use of send",
        "reason": "The use of `send` is risky because it only forwards 2300 gas, which is often insufficient for complex fallback functions. Moreover, `send` does not throw an exception on failure, potentially leading to loss of ether if the send operation fails and the failure is not handled. The contract should use `transfer` or handle the failure case of `send`.",
        "file_name": "0xbd8dbefb4e1217e95fa37201c61daf4b57a9fe19.sol"
    },
    {
        "function_name": "onlyOwner",
        "code": "modifier onlyOwner() { if (msg.sender != owner) { throw; } _; }",
        "vulnerability": "Use of deprecated throw",
        "reason": "The modifier uses the deprecated `throw` statement for error handling. In Solidity versions >= 0.4.13, `require` should be used instead of `throw`, as it provides a more informative error message and is the recommended approach for error handling.",
        "file_name": "0xbd8dbefb4e1217e95fa37201c61daf4b57a9fe19.sol"
    }
]