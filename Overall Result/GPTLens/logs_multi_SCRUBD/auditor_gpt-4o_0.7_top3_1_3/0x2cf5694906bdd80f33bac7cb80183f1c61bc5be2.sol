[
    {
        "function_name": "destroyAndSend",
        "code": "function destroyAndSend(address _recipient) public onlyOwner { selfdestruct(_recipient); }",
        "vulnerability": "Unauthorized fund transfer on self-destruction",
        "reason": "The destroyAndSend function allows the contract owner to self-destruct the contract and send all the contract's ether balance to a specified address. If the owner's private key is compromised or if the owner is malicious, they could drain the contract's funds by calling this function. Additionally, there's no check to ensure the recipient is a valid address or intended beneficiary, which could lead to unintended loss of funds.",
        "file_name": "0x2cf5694906bdd80f33bac7cb80183f1c61bc5be2.sol"
    },
    {
        "function_name": "withdrawToExchange",
        "code": "function withdrawToExchange(address depositAccount, uint amount) external onlyMerchantOrMonetha whenNotPaused { doWithdrawal(depositAccount, amount); }",
        "vulnerability": "Potential fund misdirection",
        "reason": "The withdrawToExchange function allows the merchant or Monetha address to withdraw a specified amount of ether to a deposit account. However, there is no verification whether the deposit account is a valid address intended for receiving funds. This could be exploited if the merchant's account is compromised, resulting in the withdrawal of funds to an attacker's address.",
        "file_name": "0x2cf5694906bdd80f33bac7cb80183f1c61bc5be2.sol"
    },
    {
        "function_name": "withdrawAllTokensToExchange",
        "code": "function withdrawAllTokensToExchange(address _tokenAddress, address _depositAccount, uint _minAmount) external onlyMerchantOrMonetha whenNotPaused { require(_tokenAddress != address(0)); uint balance = GenericERC20(_tokenAddress).balanceOf(address(this)); require(balance >= _minAmount); GenericERC20(_tokenAddress).transfer(_depositAccount, balance); }",
        "vulnerability": "Unauthorized token transfer",
        "reason": "In the withdrawAllTokensToExchange function, all tokens of a specified type can be transferred to a deposit account by the merchant or a Monetha address. There is no check to ensure that the deposit account is intended to receive the tokens, which could lead to unauthorized transfers if the calling account is compromised or misconfigured.",
        "file_name": "0x2cf5694906bdd80f33bac7cb80183f1c61bc5be2.sol"
    }
]