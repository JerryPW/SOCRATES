[
    {
        "function_name": "multiTransfer",
        "code": "function multiTransfer(address payable[] memory _recipients, uint256[] memory _etherAmounts) public payable nonReentrant { require(_recipients.length == _etherAmounts.length); require(_recipients.length <= _recipientLimit); for (uint256 i = 0; i < _recipients.length; i++) { _recipients[i].send(_etherAmounts[i]); } if (address(this).balance > 0) { wallet.send(address(this).balance); } }",
        "vulnerability": "Unsafe usage of send() without error handling",
        "reason": "The use of .send() to transfer ether to recipient addresses is unsafe because it only forwards 2300 gas and does not throw an error if the transfer fails. If any of the send operations fail, the loop will continue without reverting the whole transaction, potentially leading to loss of funds or inconsistent states.",
        "file_name": "0x595677bac1d68074c4f7b93bb6654156466a66b0.sol"
    },
    {
        "function_name": "multiTransfer",
        "code": "function multiTransfer(address payable[] memory _recipients, uint256[] memory _etherAmounts) public payable nonReentrant { require(_recipients.length == _etherAmounts.length); require(_recipients.length <= _recipientLimit); for (uint256 i = 0; i < _recipients.length; i++) { _recipients[i].send(_etherAmounts[i]); } if (address(this).balance > 0) { wallet.send(address(this).balance); } }",
        "vulnerability": "Potential gas limit issues and denial of service",
        "reason": "The function processes all recipients in a single transaction. If the number of recipients or the complexity of operations increases, it could exceed the block gas limit, causing transactions to fail. This allows attackers to potentially cause denial of service by filling up the recipient list with valid but unprocessable transactions.",
        "file_name": "0x595677bac1d68074c4f7b93bb6654156466a66b0.sol"
    },
    {
        "function_name": "multiTransfer",
        "code": "function multiTransfer(address payable[] memory _recipients, uint256[] memory _etherAmounts) public payable nonReentrant { require(_recipients.length == _etherAmounts.length); require(_recipients.length <= _recipientLimit); for (uint256 i = 0; i < _recipients.length; i++) { _recipients[i].send(_etherAmounts[i]); } if (address(this).balance > 0) { wallet.send(address(this).balance); } }",
        "vulnerability": "Lack of sufficient checks on ether amounts",
        "reason": "The function does not check if the total ether amounts being sent out are equal to the msg.value. Attackers can exploit this by sending insufficient ether in msg.value, causing the contract to deplete its ether reserves or fail to send the intended amounts.",
        "file_name": "0x595677bac1d68074c4f7b93bb6654156466a66b0.sol"
    }
]