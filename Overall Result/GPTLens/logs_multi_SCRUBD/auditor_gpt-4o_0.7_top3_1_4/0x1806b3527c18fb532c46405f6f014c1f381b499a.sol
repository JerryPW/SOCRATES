[
    {
        "function_name": "withdrawTaxEarning",
        "code": "function withdrawTaxEarning() public { uint256 taxEarnings = playersFundsOwed[msg.sender]; playersFundsOwed[msg.sender] = 0; tax_fund = tax_fund.sub(taxEarnings); if(!msg.sender.send(taxEarnings)) { playersFundsOwed[msg.sender] = playersFundsOwed[msg.sender] + taxEarnings; tax_fund = tax_fund.add(taxEarnings); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function sends funds to msg.sender using the send method, which can lead to a reentrancy attack if the msg.sender is a contract. The attacker contract could re-enter the function before the state is updated, draining funds from the contract.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    },
    {
        "function_name": "processReferer",
        "code": "function processReferer(address _referrer) internal returns(uint256) { uint256 _referrerAmnt = 0; if(_referrer != msg.sender && _referrer != address(0)) { _referrerAmnt = m_refPercent.mul(msg.value); if(_referrer.send(_referrerAmnt)) { emit referralPaid(_referrer, _referrer, _referrerAmnt, now); } } return _referrerAmnt; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "This function sends ether to the _referrer using the send method. This can allow a reentrancy attack if the _referrer is a contract, as it can execute code upon receiving ether and potentially re-enter the function, leading to unexpected behavior.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    },
    {
        "function_name": "processDevPayment",
        "code": "function processDevPayment(uint256 _runningTotal) internal { if(!devBankAddress.send(m_newPlot_devPercent.mul(_runningTotal))){ devHoldings = devHoldings.add(m_newPlot_devPercent.mul(_runningTotal)); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function sends ether to devBankAddress using the send method. If devBankAddress is a contract, it could execute code upon receiving ether and re-enter the function before the state is updated, causing unexpected behavior.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    }
]