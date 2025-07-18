[
    {
        "function_name": "transfer",
        "code": "function transfer(uint _sreur_tokens, address[] _addresses) onlyOwner returns (bool) { if(_sreur_tokens < 1) throw; uint amount = _sreur_tokens*100000000; for (uint i = 0; i < _addresses.length; i++) { c.call(bytes4(sha3(\"transfer(address,uint256)\")),_addresses[i], amount); } return true; }",
        "vulnerability": "No verification of external call success",
        "reason": "The function uses 'c.call()', which does not revert if the called contract runs out of gas or throws an exception. This can lead to situations where tokens are not transferred as expected, but the function still returns true, making it appear as if the operation was successful.",
        "file_name": "0xbd8dbefb4e1217e95fa37201c61daf4b57a9fe19.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() onlyOwner returns (bool result) { owner.send(this.balance); return true; }",
        "vulnerability": "Unsafe use of send() function",
        "reason": "The 'send()' function only forwards 2300 gas, which might not be enough for complex fallback functions, potentially causing the transaction to fail. Moreover, 'send()' does not revert the transaction on failure, leading to a situation where the balance is not transferred, but the function still returns true.",
        "file_name": "0xbd8dbefb4e1217e95fa37201c61daf4b57a9fe19.sol"
    },
    {
        "function_name": "onlyOwner",
        "code": "modifier onlyOwner() { if (msg.sender != owner) { throw; } _; }",
        "vulnerability": "Use of deprecated 'throw' statement",
        "reason": "The use of 'throw' is deprecated and can lead to issues with error messages and gas refunds. It is better to use 'require()' or 'revert()' for proper error handling in Solidity.",
        "file_name": "0xbd8dbefb4e1217e95fa37201c61daf4b57a9fe19.sol"
    }
]