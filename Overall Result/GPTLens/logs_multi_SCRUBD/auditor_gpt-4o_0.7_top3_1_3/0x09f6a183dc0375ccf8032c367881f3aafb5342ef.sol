[
    {
        "function_name": "withdraw",
        "code": "function withdraw(address _address, uint256 amount) public onlyOwner { require(_address != address(0) && amount > 0 && address(this).balance > amount); _address.transfer(amount); }",
        "vulnerability": "Incorrect balance check",
        "reason": "The balance check uses '>' instead of '>=' which can lead to reentrancy attacks. If the balance is exactly equal to the amount requested, the condition will fail, and it will prevent legitimate withdrawals.",
        "file_name": "0x09f6a183dc0375ccf8032c367881f3aafb5342ef.sol"
    },
    {
        "function_name": "setFee",
        "code": "function setFee(uint256 _ethFee, uint256 _hbWalletFee) public view onlyOwner returns (uint256 ETHFee, uint256 HBWALLETFee) { require(_ethFee > 0 && _hbWalletFee > 0); ETHFee = _ethFee; HBWALLETFee = _hbWalletFee; return (ETHFee, HBWALLETFee); }",
        "vulnerability": "Ineffective fee update",
        "reason": "The setFee function is marked as 'view', which means it does not modify state variables. As a result, changes to ETHFee and HBWALLETFee are not persisted, making the function ineffective for its intended purpose.",
        "file_name": "0x09f6a183dc0375ccf8032c367881f3aafb5342ef.sol"
    },
    {
        "function_name": "removePrice",
        "code": "function removePrice(uint256 tokenId) public returns (uint256) { require(erc721Address.ownerOf(tokenId) == msg.sender); if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee); resetPrice(tokenId); return prices[tokenId].price; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers Ether to the caller before resetting the price, allowing for potential reentrancy attacks. An attacker could repeatedly call removePrice and drain the contract balance before the state is updated.",
        "file_name": "0x09f6a183dc0375ccf8032c367881f3aafb5342ef.sol"
    }
]