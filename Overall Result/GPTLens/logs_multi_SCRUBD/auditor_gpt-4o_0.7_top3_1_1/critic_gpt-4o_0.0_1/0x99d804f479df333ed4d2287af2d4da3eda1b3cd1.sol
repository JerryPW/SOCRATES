[
    {
        "function_name": "split",
        "vulnerability": "Denial of Service via Out-of-Gas",
        "criticism": "The reasoning is correct. The use of send() in a loop can indeed lead to a denial of service if any of the recipients in the _to array is a contract that uses more than 2300 gas units. This can prevent the entire loop from executing correctly, blocking the function and trapping funds in the contract. The severity is high because it can block the function and trap funds. The profitability is moderate because an attacker can cause a denial of service but cannot directly profit from it.",
        "correctness": 9,
        "severity": 8,
        "profitability": 5,
        "reason": "The use of send() in a loop can lead to a denial of service (DoS) if any of the recipients in the _to array is a contract that uses more than 2300 gas units, causing the send to fail. This will prevent the entire loop from executing correctly, blocking the function and trapping funds in the contract.",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "vulnerability": "Arithmetic Division by Zero",
        "criticism": "The reasoning is correct. If the _to array is empty, the division operation msg.value / _to.length will indeed result in a division by zero, causing the transaction to revert. This is an unchecked division operation that can potentially lead to failed transactions if not properly guarded. The severity is high because it can cause the transaction to fail. The profitability is low because an attacker cannot directly profit from it.",
        "correctness": 9,
        "severity": 8,
        "profitability": 1,
        "reason": "If the _to array is empty, the division operation msg.value / _to.length will result in a division by zero, causing the transaction to revert. This is an unchecked division operation that can potentially lead to failed transactions if not properly guarded.",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "vulnerability": "Reentrancy",
        "criticism": "The reasoning is partially correct. While it's true that send() is generally considered to be safe against reentrancy, the subsequent transfer of remaining balance to msg.sender is not necessarily exploitable. The attacker would need to control the fallback function of the recipient contract and be able to perform a reentrant call, which is a complex and unlikely scenario. Therefore, the severity and profitability are moderate.",
        "correctness": 6,
        "severity": 5,
        "profitability": 5,
        "reason": "Although send() is generally considered to be safe against reentrancy, the subsequent transfer of remaining balance to msg.sender can be exploited. If an attacker gains control of one of the addresses in _to and performs a reentrant call, they could potentially drain funds or disrupt the contract's logic before the final transfer to msg.sender is executed.",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    }
]