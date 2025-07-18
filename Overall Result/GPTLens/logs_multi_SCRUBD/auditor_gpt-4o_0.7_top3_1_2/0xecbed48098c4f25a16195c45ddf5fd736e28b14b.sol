[
    {
        "function_name": "transfer",
        "code": "function transfer(address[] recipients, uint[] values) public payable { for (uint i = 0; i < recipients.length; i++) { recipients[i].transfer(values[i]); } msg.sender.transfer(address(this).balance); }",
        "vulnerability": "Integer Overflow/Underflow",
        "reason": "The function does not check if the sum of `values` exceeds `msg.value`, which can lead to an integer overflow/underflow. An attacker can exploit this by passing a large number of recipients and values, causing the contract to send more ether than intended, or revert unexpectedly.",
        "file_name": "0xecbed48098c4f25a16195c45ddf5fd736e28b14b.sol"
    },
    {
        "function_name": "send",
        "code": "function send(address[] recipients) public payable { uint amount = msg.value / recipients.length; for (uint i = 0; i < recipients.length; i++) { recipients[i].send(amount); } msg.sender.transfer(address(this).balance); }",
        "vulnerability": "Denial of Service (DoS)",
        "reason": "The use of `.send` only forwards 2300 gas, which may be insufficient for the recipient's fallback function, causing it to fail. If any send fails, the contract does not handle it, potentially causing a DoS for the entire batch transfer.",
        "file_name": "0xecbed48098c4f25a16195c45ddf5fd736e28b14b.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address[] recipients, ERC721 token, uint[] values) public { for (uint i = 0; i < recipients.length; i++) { token.transferFrom(msg.sender, recipients[i], values[i]); } }",
        "vulnerability": "Lack of Ownership/Approval Check",
        "reason": "The function does not check if the sender has ownership or approval of the ERC721 tokens being transferred. An attacker can exploit this by transferring tokens they do not own or have approval for, causing unauthorized transfers.",
        "file_name": "0xecbed48098c4f25a16195c45ddf5fd736e28b14b.sol"
    }
]