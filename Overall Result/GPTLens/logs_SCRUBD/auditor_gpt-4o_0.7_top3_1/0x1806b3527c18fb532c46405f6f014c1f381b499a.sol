[
    {
        "function_name": "withdrawTaxEarning",
        "code": "function withdrawTaxEarning() public { uint256 taxEarnings = playersFundsOwed[msg.sender]; playersFundsOwed[msg.sender] = 0; tax_fund = tax_fund.sub(taxEarnings); if(!msg.sender.send(taxEarnings)) { playersFundsOwed[msg.sender] = playersFundsOwed[msg.sender] + taxEarnings; tax_fund = tax_fund.add(taxEarnings); } }",
        "vulnerability": "Reentrancy",
        "reason": "The function withdrawTaxEarning is vulnerable to reentrancy attacks because it sends Ether to the msg.sender before updating the state variables. An attacker could exploit this by reentering the function through the fallback function and draining funds before the state is reverted.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    },
    {
        "function_name": "buyLand",
        "code": "function buyLand(bytes32 _name, int256[] _plots_lat, int256[] _plots_lng, address _referrer ) validatePurchase(_plots_lat, _plots_lng) validateLand(_plots_lat, _plots_lng) updateUsersLastAccess() public payable { require(_name.length > 4); uint256 _runningTotal = msg.value; _runningTotal = _runningTotal.sub(processReferer(_referrer)); tax_fund = tax_fund.add(m_newPlot_taxPercent.mul(_runningTotal)); processDevPayment(_runningTotal); processPurchase(_name, _plots_lat, _plots_lng); calcPlayerDivs(m_newPlot_taxPercent.mul(_runningTotal)); game_started = true; if(_plots_lat.length >= min_plots_purchase_for_token_reward && tokens_rewards_available > 0) { uint256 _token_rewards = _plots_lat.length / plots_token_reward_divisor; if(_token_rewards > tokens_rewards_available) _token_rewards = tokens_rewards_available; planetCryptoCoin_interface.transfer(msg.sender, _token_rewards); emit issueCoinTokens(msg.sender, msg.sender, _token_rewards, now); tokens_rewards_allocated = tokens_rewards_allocated + _token_rewards; tokens_rewards_available = tokens_rewards_available - _token_rewards; } }",
        "vulnerability": "Lack of proper checks for game_started",
        "reason": "The function sets game_started to true without proper checks. This could allow an attacker to prematurely start the game, potentially disrupting the intended game flow and affecting other participants.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    },
    {
        "function_name": "processReferer",
        "code": "function processReferer(address _referrer) internal returns(uint256) { uint256 _referrerAmnt = 0; if(_referrer != msg.sender && _referrer != address(0)) { _referrerAmnt = m_refPercent.mul(msg.value); if(_referrer.send(_referrerAmnt)) { emit referralPaid(_referrer, _referrer, _referrerAmnt, now); } } return _referrerAmnt; }",
        "vulnerability": "Untrusted External Call",
        "reason": "The function processReferer uses the send method to transfer Ether to the _referrer. This method could fail or be exploited by a malicious contract, potentially locking the contract or causing unexpected behavior. Reentrancy attacks could also occur if the referrer is a contract with a fallback function.",
        "file_name": "0x1806b3527c18fb532c46405f6f014c1f381b499a.sol"
    }
]