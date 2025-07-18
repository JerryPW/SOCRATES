[
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Denial of Service (DoS) with Block Gas Limit",
        "reason": "The function iterates over the entire _to array and performs an action (sending ether), which incurs a gas cost. If the _to array is large enough, the gas required to execute the loop could exceed the block gas limit, causing the transaction to fail. This would result in a denial of service for the function, as it would be unable to complete successfully with large input sizes.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function uses the send method, which forwards a fixed amount of gas. If the receiving address is a contract, it can execute further code when receiving ether. If such a contract were to call back into the split function, it could cause unexpected behavior or exploit any state changes made after the send call, especially the final transfer of remaining balance back to the msg.sender.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Integer Division Truncation",
        "reason": "The calculation of _val = msg.value / _to.length performs integer division, which can result in truncation if msg.value is not exactly divisible by _to.length. This can lead to a situation where a small remainder of ether is left in the contract, which then gets transferred to the caller. This unintended ether transfer might be exploited by attackers repeatedly calling the function with carefully chosen msg.value and _to.length to accumulate the leftover ether.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    }
]