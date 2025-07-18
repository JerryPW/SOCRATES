[
    {
        "function_name": "withdraw",
        "code": "function withdraw(address _address, uint256 amount) public onlyOwner { require(_address != address(0) && amount > 0 && address(this).balance > amount); _address.transfer(amount); }",
        "vulnerability": "Incorrect balance check",
        "reason": "The function checks if the contract's balance is greater than the amount to be withdrawn, but it should check if it's greater or equal. This may lead to situations where the exact balance cannot be withdrawn, leaving a small amount stranded in the contract.",
        "file_name": "0x09f6a183dc0375ccf8032c367881f3aafb5342ef.sol"
    },
    {
        "function_name": "setFee",
        "code": "function setFee(uint256 _ethFee, uint256 _hbWalletFee) public view onlyOwner returns (uint256 ETHFee, uint256 HBWALLETFee){ require(_ethFee > 0 && _hbWalletFee > 0); ETHFee = _ethFee; HBWALLETFee = _hbWalletFee; return (ETHFee, HBWALLETFee); }",
        "vulnerability": "Ineffective state change",
        "reason": "Although this function is intended to set the fees, it is declared as 'view', which means it cannot modify the state of the contract. Therefore, the fees are not updated as intended, which could lead to unexpected behavior in other parts of the contract that rely on the fee values.",
        "file_name": "0x09f6a183dc0375ccf8032c367881f3aafb5342ef.sol"
    },
    {
        "function_name": "buy",
        "code": "function buy(uint256 tokenId) public payable { require(erc721Address.getApproved(tokenId) == address(this)); require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value); erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId); prices[tokenId].tokenOwner.transfer(msg.value); resetPrice(tokenId); }",
        "vulnerability": "Lack of reentrancy protection",
        "reason": "The 'buy' function is vulnerable to reentrancy attacks because it transfers ether to an external address before updating the price state with 'resetPrice'. An attacker could reenter the function during the ether transfer to manipulate contract state or drain funds.",
        "file_name": "0x09f6a183dc0375ccf8032c367881f3aafb5342ef.sol"
    }
]