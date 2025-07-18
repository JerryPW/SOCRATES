[
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Denial of Service via send()",
        "reason": "The function uses the send() method to transfer Ether to each address. The send() method only forwards 2,300 gas, which is often not enough if the recipient is a contract with higher gas requirements. If any transfer fails, due to lack of gas or any other reason, the funds can get stuck in the contract, causing a denial of service for the remaining recipients. Moreover, the loop will continue executing even if one of the sends fails, which can lead to an inconsistent state.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Integer Division Errors",
        "reason": "The function calculates the value to be sent to each address by dividing msg.value by _to.length. If msg.value is not perfectly divisible by _to.length, the division will truncate and the remainder will be left in the contract. This remainder is transferred back to the sender at the end, which can lead to situations where the intended split does not occur correctly and the sender retrieves some of the funds that should have been distributed.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The function transfers Ether back to the msg.sender after attempting to send Ether to all addresses in _to. If the sender is a contract, it can perform a reentrancy attack by calling split again before the first invocation finishes. This allows the attacker to drain the contract by repeatedly calling split within the fallback function of the sender's contract. The use of send() mitigates this risk somewhat by forwarding only 2,300 gas, but it is still a potential vector for attack if msg.sender is a contract.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    }
]