[
    {
        "function_name": "send",
        "code": "function send(address[] recipients) public payable { uint amount = msg.value / recipients.length; for (uint i = 0; i < recipients.length; i++) { recipients[i].send(amount); } msg.sender.transfer(address(this).balance); }",
        "vulnerability": "Denial of Service via Unexpected Revert",
        "reason": "The use of send() can lead to a situation where the contract fails to handle reverts properly during Ether transfers to recipients. If any recipient in the list is a contract that reverts on receiving Ether, it can break the loop and prevent further execution, causing a denial of service for the function.",
        "file_name": "0xecbed48098c4f25a16195c45ddf5fd736e28b14b.sol"
    },
    {
        "function_name": "post",
        "code": "function post(string data, address[] recipients, uint[] values) public payable { emit Claim(data); transfer(recipients, values); }",
        "vulnerability": "Unchecked Transfer Amounts",
        "reason": "The function does not check that the sum of the values array is equal to msg.value, allowing an attacker to specify lower values and steal the remaining Ether in the contract by receiving the remainder in msg.sender.transfer(address(this).balance).",
        "file_name": "0xecbed48098c4f25a16195c45ddf5fd736e28b14b.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address[] recipients, ERC721 token, uint[] values) public { for (uint i = 0; i < recipients.length; i++) { token.transferFrom(msg.sender, recipients[i], values[i]); } }",
        "vulnerability": "Lack of Validation for ERC721 Transfers",
        "reason": "The function fails to check whether the token transfers are successful. ERC721's transferFrom function does not return a success boolean, and without validation, an attacker could exploit this to manipulate the state, causing incorrect assumptions about token balances and ownership.",
        "file_name": "0xecbed48098c4f25a16195c45ddf5fd736e28b14b.sol"
    }
]