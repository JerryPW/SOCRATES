[
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Denial of Service via Out-of-Gas",
        "reason": "The use of send() in a loop can lead to a denial of service (DoS) if any of the recipients in the _to array is a contract that uses more than 2300 gas units, causing the send to fail. This will prevent the entire loop from executing correctly, blocking the function and trapping funds in the contract.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Arithmetic Division by Zero",
        "reason": "If the _to array is empty, the division operation msg.value / _to.length will result in a division by zero, causing the transaction to revert. This is an unchecked division operation that can potentially lead to failed transactions if not properly guarded.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Reentrancy",
        "reason": "Although send() is generally considered to be safe against reentrancy, the subsequent transfer of remaining balance to msg.sender can be exploited. If an attacker gains control of one of the addresses in _to and performs a reentrant call, they could potentially drain funds or disrupt the contract's logic before the final transfer to msg.sender is executed.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    }
]