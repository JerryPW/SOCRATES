[
    {
        "function_name": "forwardFunds",
        "code": "function forwardFunds(uint _amountEthWei) private{ forwardFundsWallet.send(_amountEthWei); }",
        "vulnerability": "Use of send() for ETH transfer",
        "reason": "The use of 'send()' for transferring Ether is dangerous because it only forwards 2300 gas, which may not be enough if the recipient is a smart contract that needs more gas for execution. This could lead to loss of funds if the transaction fails and is not handled securely.",
        "file_name": "0xefcc5dcaba4a93046b5f5c24c1281c685154214c.sol"
    },
    {
        "function_name": "withdrawAllEther",
        "code": "function withdrawAllEther(){ if (owners[msg.sender]){ msg.sender.send(this.balance); } }",
        "vulnerability": "Potential reentrancy vulnerability",
        "reason": "The 'send()' method is used for Ether transfer, which can lead to reentrancy attacks if the calling contract is malicious and attempts to call back into 'withdrawAllEther' before the balance is updated. This can be exploited to drain the contract balance.",
        "file_name": "0xefcc5dcaba4a93046b5f5c24c1281c685154214c.sol"
    },
    {
        "function_name": "withdrawDistributionCRL",
        "code": "function withdrawDistributionCRL(){ if (owners[msg.sender]){ uint amount = CRLTotal.sub(totalCRLDistributed).sub(totalCRLDistributed); sendTokens(msg.sender, amount); } }",
        "vulnerability": "Incorrect calculation of CRL tokens",
        "reason": "The calculation `CRLTotal.sub(totalCRLDistributed).sub(totalCRLDistributed)` is incorrect and can lead to an underflow or incorrect token distribution. This may allow owners to withdraw more tokens than intended.",
        "file_name": "0xefcc5dcaba4a93046b5f5c24c1281c685154214c.sol"
    }
]