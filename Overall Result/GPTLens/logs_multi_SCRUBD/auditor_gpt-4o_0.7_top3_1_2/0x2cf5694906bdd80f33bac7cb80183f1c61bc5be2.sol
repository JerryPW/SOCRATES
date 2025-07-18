[
    {
        "function_name": "destroyAndSend",
        "code": "function destroyAndSend(address _recipient) public onlyOwner { selfdestruct(_recipient); }",
        "vulnerability": "Potential fund loss due to self-destruct",
        "reason": "The function allows the owner to self-destruct the contract and send remaining Ether to an arbitrary address. This can result in loss of funds if the address is incorrectly set or if the owner becomes compromised.",
        "file_name": "0x2cf5694906bdd80f33bac7cb80183f1c61bc5be2.sol"
    },
    {
        "function_name": "withdrawAllTokensToExchange",
        "code": "function withdrawAllTokensToExchange(address _tokenAddress, address _depositAccount, uint _minAmount) external onlyMerchantOrMonetha whenNotPaused { require(_tokenAddress != address(0)); uint balance = GenericERC20(_tokenAddress).balanceOf(address(this)); require(balance >= _minAmount); GenericERC20(_tokenAddress).transfer(_depositAccount, balance); }",
        "vulnerability": "ERC20 token theft",
        "reason": "This function allows the merchant or Monetha address to withdraw all tokens from the contract to a specified account. If the Monetha address is compromised or malicious, it can steal all tokens from the contract.",
        "file_name": "0x2cf5694906bdd80f33bac7cb80183f1c61bc5be2.sol"
    },
    {
        "function_name": "setMonethaAddress",
        "code": "function setMonethaAddress(address _address, bool _isMonethaAddress) public { require(msg.sender == admin || msg.sender == owner); isMonethaAddress[_address] = _isMonethaAddress; emit MonethaAddressSet(_address, _isMonethaAddress); }",
        "vulnerability": "Arbitrary address authorization",
        "reason": "The function allows the owner or admin to set any address as a Monetha address, which can then execute privileged actions. If the admin or owner account is compromised, an attacker can set their own address as Monetha and exploit the contract.",
        "file_name": "0x2cf5694906bdd80f33bac7cb80183f1c61bc5be2.sol"
    }
]