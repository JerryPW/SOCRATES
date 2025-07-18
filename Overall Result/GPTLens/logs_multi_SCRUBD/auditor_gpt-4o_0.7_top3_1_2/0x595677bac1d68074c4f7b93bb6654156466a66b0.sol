[
    {
        "function_name": "multiTransfer",
        "code": "function multiTransfer(address payable[] memory _recipients, uint256[] memory _etherAmounts) public payable nonReentrant { require(_recipients.length == _etherAmounts.length); require(_recipients.length <= _recipientLimit); for (uint256 i = 0; i < _recipients.length; i++) { _recipients[i].send(_etherAmounts[i]); } if (address(this).balance > 0) { wallet.send(address(this).balance); } }",
        "vulnerability": "Insecure Ether Transfer via send",
        "reason": "The use of '.send()' for transferring Ether is insecure because it only forwards a limited gas stipend (2300 gas). If any recipient is a contract that requires more than 2300 gas to execute its fallback/receive function, the transfer will fail, potentially leaving the contract in an unexpected state. This could be exploited by an attacker to block further transactions or cause unintended behavior, especially if the system depends on these transfers succeeding.",
        "file_name": "0x595677bac1d68074c4f7b93bb6654156466a66b0.sol"
    },
    {
        "function_name": "multiTransfer",
        "code": "function multiTransfer(address payable[] memory _recipients, uint256[] memory _etherAmounts) public payable nonReentrant { require(_recipients.length == _etherAmounts.length); require(_recipients.length <= _recipientLimit); for (uint256 i = 0; i < _recipients.length; i++) { _recipients[i].send(_etherAmounts[i]); } if (address(this).balance > 0) { wallet.send(address(this).balance); } }",
        "vulnerability": "Lack of Checks for Failed Transfers",
        "reason": "The function does not check the return value of the '.send()' calls. In Solidity, '.send()' returns a boolean indicating success or failure, but the current implementation ignores this. If a transfer fails due to any reason (e.g., running out of gas or rejection by the recipient), this could lead to loss of funds or inconsistent states without any alert to the contract owner or users. Attackers could exploit this by ensuring some transfers fail deliberately.",
        "file_name": "0x595677bac1d68074c4f7b93bb6654156466a66b0.sol"
    },
    {
        "function_name": "multiTransfer",
        "code": "function multiTransfer(address payable[] memory _recipients, uint256[] memory _etherAmounts) public payable nonReentrant { require(_recipients.length == _etherAmounts.length); require(_recipients.length <= _recipientLimit); for (uint256 i = 0; i < _recipients.length; i++) { _recipients[i].send(_etherAmounts[i]); } if (address(this).balance > 0) { wallet.send(address(this).balance); } }",
        "vulnerability": "Potential Denial of Service via Insufficient Gas for Wallet Send",
        "reason": "The use of '.send()' for transferring remaining contract balance to the 'wallet' address at the end of the function does not ensure that the transfer will succeed due to the limited gas stipend. If the wallet is a contract that requires more gas for execution, the send operation will fail. This can lead to funds being stuck in the contract and potential denial-of-service (DoS) scenarios, as the contract may not operate correctly if any expected transfers fail.",
        "file_name": "0x595677bac1d68074c4f7b93bb6654156466a66b0.sol"
    }
]