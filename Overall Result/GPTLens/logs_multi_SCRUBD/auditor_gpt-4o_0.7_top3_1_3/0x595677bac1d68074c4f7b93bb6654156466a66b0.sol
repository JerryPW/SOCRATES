[
    {
        "function_name": "multiTransfer",
        "code": "function multiTransfer(address payable[] memory _recipients, uint256[] memory _etherAmounts) public payable nonReentrant { require(_recipients.length == _etherAmounts.length); require(_recipients.length <= _recipientLimit); for (uint256 i = 0; i < _recipients.length; i++) { _recipients[i].send(_etherAmounts[i]); } if (address(this).balance > 0) { wallet.send(address(this).balance); } }",
        "vulnerability": "Use of .send() for Ether transfer",
        "reason": "The function uses the low-level .send() method for transferring Ether, which only forwards 2300 gas and returns false on failure without reverting. This could lead to Ether being stuck in the contract if the recipient is a contract with a fallback function that requires more than 2300 gas. An attacker could exploit this by making a recipient contract with a high gas requirement, causing funds to remain trapped in the contract.",
        "file_name": "0x595677bac1d68074c4f7b93bb6654156466a66b0.sol"
    },
    {
        "function_name": "multiTransfer",
        "code": "function multiTransfer(address payable[] memory _recipients, uint256[] memory _etherAmounts) public payable nonReentrant { require(_recipients.length == _etherAmounts.length); require(_recipients.length <= _recipientLimit); for (uint256 i = 0; i < _recipients.length; i++) { _recipients[i].send(_etherAmounts[i]); } if (address(this).balance > 0) { wallet.send(address(this).balance); } }",
        "vulnerability": "Lack of checks on send() return value",
        "reason": "The function does not check the return value of the .send() method. If .send() fails, the function will continue execution without reverting, potentially leaving recipients without their expected Ether. An attacker can exploit this by creating a recipient contract that intentionally fails, which would prevent proper distribution of funds and potentially leave Ether in an inconsistent state.",
        "file_name": "0x595677bac1d68074c4f7b93bb6654156466a66b0.sol"
    },
    {
        "function_name": "multiTransfer",
        "code": "function multiTransfer(address payable[] memory _recipients, uint256[] memory _etherAmounts) public payable nonReentrant { require(_recipients.length == _etherAmounts.length); require(_recipients.length <= _recipientLimit); for (uint256 i = 0; i < _recipients.length; i++) { _recipients[i].send(_etherAmounts[i]); } if (address(this).balance > 0) { wallet.send(address(this).balance); } }",
        "vulnerability": "Potential gas limit issues",
        "reason": "The function imposes a limit on the number of recipients but does not consider the gas cost of each transfer. If _etherAmounts are large or the recipient contracts consume a significant amount of gas, transactions could run out of gas, leading to unsuccessful transfers. An attacker could exploit this by creating a situation where certain transactions fail due to gas constraints, potentially leading to denial of service.",
        "file_name": "0x595677bac1d68074c4f7b93bb6654156466a66b0.sol"
    }
]