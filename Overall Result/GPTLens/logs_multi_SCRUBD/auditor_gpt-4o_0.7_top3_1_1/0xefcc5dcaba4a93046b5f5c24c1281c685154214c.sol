[
    {
        "function_name": "forwardFunds",
        "code": "function forwardFunds(uint _amountEthWei) private{\n    forwardFundsWallet.send(_amountEthWei);\n}",
        "vulnerability": "Unsafe use of send",
        "reason": "The use of the send method to transfer Ether is unsafe because it only forwards 2300 gas, which can cause the transaction to fail if the recipient is a smart contract with a fallback function requiring more gas. This can result in funds being stuck in the contract.",
        "file_name": "0xefcc5dcaba4a93046b5f5c24c1281c685154214c.sol"
    },
    {
        "function_name": "withdrawAllEther",
        "code": "function withdrawAllEther(){\n    if (owners[msg.sender]){\n        msg.sender.send(this.balance);\n    }\n}",
        "vulnerability": "Unsafe use of send and reentrancy risk",
        "reason": "The send method is used to transfer the entire contract balance to the caller. This is unsafe because it does not check if the send was successful, and it only forwards a limited amount of gas, which could lead to failed transactions. Additionally, if the caller is a contract, this function can be exploited via reentrancy attacks due to the lack of reentrancy protection.",
        "file_name": "0xefcc5dcaba4a93046b5f5c24c1281c685154214c.sol"
    },
    {
        "function_name": "claimTokens",
        "code": "function claimTokens(address _addr){\n    uint amount = 0;\n    if (dateInvested[_addr] > 0 && vestedTokens[_addr] > 0 && now > firstDeadline[_addr]){\n        amount = amount.add(vestedTokens[_addr]);\n        vestedTokens[_addr] = 0;\n        if (amount > 0){\n            sendTokens(msg.sender, amount);\n            totalVesting = totalVesting.sub(amount);\n        }\n    }\n}",
        "vulnerability": "Incorrect access control",
        "reason": "The function allows any address to claim tokens on behalf of another address without any checks to ensure that the caller is authorized to do so. This can result in an unauthorized user claiming tokens for themselves, leading to a loss of tokens for the intended recipient.",
        "file_name": "0xefcc5dcaba4a93046b5f5c24c1281c685154214c.sol"
    }
]