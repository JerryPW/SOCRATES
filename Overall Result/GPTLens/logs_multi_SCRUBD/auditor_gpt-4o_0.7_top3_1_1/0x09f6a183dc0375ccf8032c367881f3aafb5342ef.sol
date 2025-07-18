[
    {
        "function_name": "removePrice",
        "code": "function removePrice(uint256 tokenId) public returns (uint256){ require(erc721Address.ownerOf(tokenId) == msg.sender); if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee); resetPrice(tokenId); return prices[tokenId].price; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function removePrice allows the caller to receive ether back (prices[tokenId].fee) before resetting the price data. This opens up the potential for a reentrancy attack where an attacker could recursively call removePrice to drain funds before the state is updated by resetPrice.",
        "file_name": "0x09f6a183dc0375ccf8032c367881f3aafb5342ef.sol"
    },
    {
        "function_name": "setFee",
        "code": "function setFee(uint256 _ethFee, uint256 _hbWalletFee) public view onlyOwner returns (uint256 ETHFee, uint256 HBWALLETFee){ require(_ethFee > 0 && _hbWalletFee > 0); ETHFee = _ethFee; HBWALLETFee = _hbWalletFee; return (ETHFee, HBWALLETFee); }",
        "vulnerability": "Ineffectual function logic",
        "reason": "The setFee function is declared as view, implying it does not modify the state. However, it is meant to set new fee values, but it does not update the stored ETHFee or HBWALLETFee variables due to its view nature. This makes the function's purpose unachievable, potentially confusing the contract owner into thinking they updated the fees when they haven't.",
        "file_name": "0x09f6a183dc0375ccf8032c367881f3aafb5342ef.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw(address _address, uint256 amount) public onlyOwner { require(_address != address(0) && amount > 0 && address(this).balance > amount); _address.transfer(amount); }",
        "vulnerability": "Improper balance check",
        "reason": "The withdraw function checks if the contract's balance is greater than the amount to withdraw, but it should be greater than or equal to the amount. This can lead to a scenario where an exact withdrawal of the contract's full balance would be incorrectly blocked.",
        "file_name": "0x09f6a183dc0375ccf8032c367881f3aafb5342ef.sol"
    }
]