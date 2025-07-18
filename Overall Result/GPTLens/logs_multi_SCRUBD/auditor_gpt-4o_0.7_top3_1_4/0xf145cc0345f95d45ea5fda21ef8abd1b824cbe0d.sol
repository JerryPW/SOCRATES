[
    {
        "function_name": "withdrawEther",
        "code": "function withdrawEther() onlyOwner public returns(bool) { return contractOwner.send(this.balance); }",
        "vulnerability": "Unsafe Ether transfer with send",
        "reason": "The function uses the send method to transfer Ether, which only forwards 2300 gas and does not throw an error on failure, possibly causing Ether to be stuck in the contract. Using call.value is a safer alternative as it allows specifying the gas limit and handling potential failure.",
        "file_name": "0xf145cc0345f95d45ea5fda21ef8abd1b824cbe0d.sol"
    },
    {
        "function_name": "transfer",
        "code": "function transfer(address _to, uint256 _tokenId) external { require(tradable == true); require(_to != address(0)); require(msg.sender != _to); uint256 _divisibility = _tokenId; require(tokenToOwnersHoldings[firstCommonsForumId][msg.sender] >= _divisibility); _removeShareFromLastOwner(msg.sender, firstCommonsForumId, _divisibility); _removeLastOwnerHoldingsFromToken(msg.sender, firstCommonsForumId, _divisibility); _addNewOwnerHoldingsToToken(_to, firstCommonsForumId, _divisibility); _addShareToNewOwner(_to, firstCommonsForumId, _divisibility); Transfer(msg.sender, _to, firstCommonsForumId); }",
        "vulnerability": "Improper token transfer logic",
        "reason": "The logic for transferring tokens assumes that _tokenId represents the divisibility of tokens to be transferred, which is misleading and can lead to incorrect transfers. Moreover, the function does not verify the existence of the token being transferred with an onlyExistentToken modifier, potentially allowing transfers of non-existent tokens.",
        "file_name": "0xf145cc0345f95d45ea5fda21ef8abd1b824cbe0d.sol"
    },
    {
        "function_name": "submitTransaction",
        "code": "function submitTransaction(address destination, uint value, bytes data) public returns (uint transactionId) { transactionId = addTransaction(destination, value, data); confirmTransaction(transactionId); }",
        "vulnerability": "Automatic confirmation of transaction upon submission",
        "reason": "The function automatically confirms a transaction upon submission, which compromises the security and purpose of a multisig wallet. This bypasses the need for multiple confirmations from different owners before executing a transaction, allowing a single owner to potentially execute any transaction unilaterally.",
        "file_name": "0xf145cc0345f95d45ea5fda21ef8abd1b824cbe0d.sol"
    }
]