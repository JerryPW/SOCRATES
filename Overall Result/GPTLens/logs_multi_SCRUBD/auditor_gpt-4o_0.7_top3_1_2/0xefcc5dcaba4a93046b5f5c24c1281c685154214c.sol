[
    {
        "function_name": "forwardFunds",
        "code": "function forwardFunds(uint _amountEthWei) private{ forwardFundsWallet.send(_amountEthWei); }",
        "vulnerability": "Potential loss of funds due to lack of error handling",
        "reason": "The use of the send function to forward funds is dangerous without proper error handling. If the send fails, funds could be lost or remain stuck in the contract. A better approach would be to use call with a require statement to catch errors.",
        "file_name": "0xefcc5dcaba4a93046b5f5c24c1281c685154214c.sol"
    },
    {
        "function_name": "withdrawAllEther",
        "code": "function withdrawAllEther(){ if (owners[msg.sender]){ msg.sender.send(this.balance); } }",
        "vulnerability": "Potential denial of service and loss of funds",
        "reason": "The use of the send function can lead to a denial of service if the recipient is a contract that has a fallback function consuming more than 2300 gas or if it prevents receiving Ether. This could stop owners from withdrawing funds. Using call with a gas limit and error handling is recommended.",
        "file_name": "0xefcc5dcaba4a93046b5f5c24c1281c685154214c.sol"
    },
    {
        "function_name": "withdrawDistributionCRL",
        "code": "function withdrawDistributionCRL(){ if (owners[msg.sender]){ uint amount = CRLTotal.sub(totalCRLDistributed).sub(totalCRLDistributed); sendTokens(msg.sender, amount); } }",
        "vulnerability": "Incorrect calculation leading to potential token mismanagement",
        "reason": "The calculation for the amount to withdraw uses CRLTotal.sub(totalCRLDistributed).sub(totalCRLDistributed), which is incorrect. It should be CRLTotal.sub(totalCRLDistributed). This mistake could lead to incorrect token distribution or potential underflows.",
        "file_name": "0xefcc5dcaba4a93046b5f5c24c1281c685154214c.sol"
    }
]