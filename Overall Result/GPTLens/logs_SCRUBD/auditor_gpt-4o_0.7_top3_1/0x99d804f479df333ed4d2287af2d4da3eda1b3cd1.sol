[
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Integer Division and Rounding",
        "reason": "The calculation of `_val` using integer division `msg.value / _to.length` can lead to rounding errors if `msg.value` is not perfectly divisible by `_to.length`. This could result in a scenario where not all funds are distributed, leaving a remainder in the contract that can be collected by `msg.sender`. An attacker can exploit this to repeatedly call the `split` function with a crafted list that leaves a small remainder, effectively draining the contract balance over time.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Use of `send` instead of `transfer`",
        "reason": "The use of `_to[i].send(_val)` is problematic because `send` only forwards 2300 gas and returns a boolean indicating success. If the transfer fails due to insufficient gas or other reasons, the function does not handle this failure. This could lead to an incomplete transfer of funds and potentially allow an attacker to target recipients with high gas requirements to revert the operation, causing the contract to behave unexpectedly or leave funds unclaimed.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The contract is vulnerable to a reentrancy attack because it calls `msg.sender.transfer(address(this).balance)` after looping through `_to` addresses and sending them `_val`. If one of the recipients is a contract with a fallback function that calls `split` again, it can potentially increase the contract balance and manipulate the amount sent to `msg.sender`. This is due to the fact that the balance check and transfer to `msg.sender` occur after the loop, allowing the reentrant call to happen in between and potentially drain funds.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    }
]