[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Authorization Not Revoked",
        "reason": "When ownership is transferred, the previous owner remains authorized. This means that the previous owner can still call functions that are restricted to authorized users, potentially leading to unauthorized access or actions. This can be exploited if the new owner is unaware of the previous owner's retained privileges.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    },
    {
        "function_name": "setRetrive",
        "code": "function setRetrive(uint256 amount) external authorized { payable(marketingFeeReceiver).transfer(amount); }",
        "vulnerability": "Potential Unauthorized Fund Withdrawal",
        "reason": "The function allows any authorized address to withdraw funds to the marketingFeeReceiver. If the authorized address list is not carefully managed, it could lead to unauthorized withdrawals, especially since there is no check on the amount being withdrawn against the contract's balance, potentially depleting the contract's funds.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    },
    {
        "function_name": "setDistributorSettings",
        "code": "function setDistributorSettings(uint256 gas) external authorized { require(gas < 750000); distributorGas = gas; }",
        "vulnerability": "Gas Limit Adjustment Risk",
        "reason": "This function allows any authorized address to set the gas limit for processing dividends. If an attacker gains authorization, they can reduce the gas limit to a point where dividend processing becomes ineffective, disrupting the distribution system. Conversely, they could increase it to a point where it becomes economically costly for other interactions.",
        "file_name": "0x32ed067fb79b38b65e1fdd2bcc8c81078b866c3b.sol"
    }
]