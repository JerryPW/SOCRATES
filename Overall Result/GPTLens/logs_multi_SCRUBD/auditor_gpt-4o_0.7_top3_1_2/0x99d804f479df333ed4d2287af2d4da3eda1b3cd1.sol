[
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Denial of Service by Reverting",
        "reason": "The function uses the send method to transfer ether, which only forwards 2300 gas and does not throw an error on failure, instead returning false. If any of the addresses in the _to array is a contract that reverts the transaction (due to insufficient gas or other reasons), the loop will still continue, and funds will not be distributed entirely. Moreover, the leftover ether can be claimed by the msg.sender if any of the send operations fail, leading to potential fund loss for other recipients.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Integer Division Errors",
        "reason": "The calculation of _val uses integer division, which could lead to the loss of ether when msg.value is not perfectly divisible by _to.length. This results in leftover funds in the contract balance that can be collected by the msg.sender. The leftover ether due to rounding errors is not distributed among recipients as would be expected, potentially leading to unfair distribution.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    },
    {
        "function_name": "split",
        "code": "function split(address[] _to) public payable { uint256 _val = msg.value / _to.length; for (uint256 i=0; i < _to.length; i++) { _to[i].send(_val); } if (address(this).balance > 0) { msg.sender.transfer(address(this).balance); } }",
        "vulnerability": "Lack of Input Validation",
        "reason": "There is no check to ensure that the _to array is not empty. If an empty array is passed, a division by zero will occur, causing the transaction to revert. This lack of input validation allows users to unintentionally (or maliciously) cause the contract to behave unexpectedly or fail.",
        "file_name": "0x99d804f479df333ed4d2287af2d4da3eda1b3cd1.sol"
    }
]