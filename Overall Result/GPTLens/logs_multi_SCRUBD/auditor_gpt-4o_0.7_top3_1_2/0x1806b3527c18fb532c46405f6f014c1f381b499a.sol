[
    {
        "function_name": "withdrawTaxEarning",
        "code": "function withdrawTaxEarning() public { uint256 taxEarnings = playersFundsOwed[msg.sender]; playersFundsOwed[msg.sender] = 0; tax_fund = tax_fund.sub(taxEarnings); if(!msg.sender.send(taxEarnings)) { playersFundsOwed[msg.sender] = playersFundsOwed[msg.sender] + taxEarnings; tax_fund = tax_fund.add(taxEarnings); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function sends Ether to the caller using `send` which only forwards 2300 gas, but it doesn't prevent reentrancy attacks. An attacker can re-enter the function before the state variables `playersFundsOwed` and `tax_fund` are updated, allowing them to withdraw more funds than intended.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    },
    {
        "function_name": "processReferer",
        "code": "function processReferer(address _referrer) internal returns(uint256) { uint256 _referrerAmnt = 0; if(_referrer != msg.sender && _referrer != address(0)) { _referrerAmnt = m_refPercent.mul(msg.value); if(_referrer.send(_referrerAmnt)) { emit referralPaid(_referrer, _referrer, _referrerAmnt, now); } } return _referrerAmnt; }",
        "vulnerability": "Improper Handling of Ether Transfer",
        "reason": "The function attempts to send Ether to a referrer using `send`. If the transaction fails, it does not handle the failure properly. This could lead to inconsistencies in the contract state, as the amount is deducted from the total but not reflected in the referrer's balance.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    },
    {
        "function_name": "p_withdrawDevHoldings",
        "code": "function p_withdrawDevHoldings() public { require(msg.sender == devBankAddress); uint256 _t = devHoldings; devHoldings = 0; if(!devBankAddress.send(devHoldings)){ devHoldings = _t; } }",
        "vulnerability": "Incorrect Balance Reset",
        "reason": "The function sets `devHoldings` to zero before sending the funds, and if the send fails, it attempts to reset `devHoldings` but uses the old value incorrectly. This results in a zero balance regardless of the send success or failure, potentially leading to loss of funds.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    }
]