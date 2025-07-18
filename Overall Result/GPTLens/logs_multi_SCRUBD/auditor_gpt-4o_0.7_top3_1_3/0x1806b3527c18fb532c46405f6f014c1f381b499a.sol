[
    {
        "function_name": "withdrawTaxEarning",
        "code": "function withdrawTaxEarning() public { uint256 taxEarnings = playersFundsOwed[msg.sender]; playersFundsOwed[msg.sender] = 0; tax_fund = tax_fund.sub(taxEarnings); if(!msg.sender.send(taxEarnings)) { playersFundsOwed[msg.sender] = playersFundsOwed[msg.sender] + taxEarnings; tax_fund = tax_fund.add(taxEarnings); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses `send` to transfer funds, which only sends 2300 gas and does not revert on failure, making it susceptible to reentrancy attacks. An attacker could exploit this by calling back into this function before the original call completes, potentially draining funds.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    },
    {
        "function_name": "processReferer",
        "code": "function processReferer(address _referrer) internal returns(uint256) { uint256 _referrerAmnt = 0; if(_referrer != msg.sender && _referrer != address(0)) { _referrerAmnt = m_refPercent.mul(msg.value); if(_referrer.send(_referrerAmnt)) { emit referralPaid(_referrer, _referrer, _referrerAmnt, now); } } return _referrerAmnt; }",
        "vulnerability": "Unreliable ether transfer",
        "reason": "This function uses `send` to transfer ether to the referrer, which only forwards 2300 gas. If the referrer's fallback function requires more than this, the transfer will fail silently, potentially leading to loss of funds without notification.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    },
    {
        "function_name": "p_update_action",
        "code": "function p_update_action(uint256 _type, address _address, uint256 _val, string _strVal) public onlyOwner { if(_type == 0){ owner = _address; } if(_type == 1){ tokenBankAddress = _address; } if(_type == 2) { devBankAddress = _address; } if(_type == 3) { cardChangeNameCost = _val; } if(_type == 4) { cardImageCost = _val; } if(_type == 5) { baseURI = _strVal; } if(_type == 6) { price_update_amount = _val; } if(_type == 7) { current_plot_empire_score = _val; } if(_type == 8) { planetCryptoCoinAddress = _address; if(address(planetCryptoCoinAddress) != address(0)){ planetCryptoCoin_interface = PlanetCryptoCoin_I(planetCryptoCoinAddress); } } if(_type ==9) { planetCryptoUtilsAddress = _address; if(address(planetCryptoUtilsAddress) != address(0)){ planetCryptoUtils_interface = PlanetCryptoUtils_I(planetCryptoUtilsAddress); } } if(_type == 10) { m_newPlot_devPercent = Percent.percent(_val,100); } if(_type == 11) { m_newPlot_taxPercent = Percent.percent(_val,100); } if(_type == 12) { m_resalePlot_devPercent = Percent.percent(_val,100); } if(_type == 13) { m_resalePlot_taxPercent = Percent.percent(_val,100); } if(_type == 14) { m_resalePlot_ownerPercent = Percent.percent(_val,100); } if(_type == 15) { m_refPercent = Percent.percent(_val,100); } if(_type == 16) { m_empireScoreMultiplier = Percent.percent(_val, 100); } if(_type == 17) { m_resaleMultipler = Percent.percent(_val, 100); } if(_type == 18) { tokens_rewards_available = _val; } if(_type == 19) { tokens_rewards_allocated = _val; } if(_type == 20) { plotDetails[ tokenIDplotdetailsIndexId[_val] ].img = ''; emit cardChange( _val, msg.sender, _val, msg.sender, 1, '', now); } if(_type == 99) { address _token_owner = ownerOf(_val); processBurn(_token_owner, _val); } }",
        "vulnerability": "Improper access control",
        "reason": "The function allows the owner to update critical contract parameters and addresses. If the owner's private key is compromised, an attacker could change these parameters or addresses to malicious ones, leading to potential theft or loss of funds.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    }
]