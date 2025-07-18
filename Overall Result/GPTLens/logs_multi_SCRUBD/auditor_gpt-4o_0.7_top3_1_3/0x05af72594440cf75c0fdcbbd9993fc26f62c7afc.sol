[
    {
        "function_name": "buy",
        "code": "function buy(address _referral) public payable disableContract { require(init == true); require(games[round].ended == false); require(msg.sender != _referral); if (games[round].endTime <= now) endRound(); Game storage g = games[round]; uint256 keyPrice = SafeMath.mul(g.keyLevel, KEY_PRICE_DEFAULT); uint256 repay = SafeMath.sub(msg.value, keyPrice); uint256 _referralBonus = SafeMath.div(SafeMath.mul(keyPrice, REFERRAL), 100); uint256 _profitTHT = SafeMath.div(SafeMath.mul(keyPrice, THT_TOKEN_OWNERS), 100); uint256 _dividends = SafeMath.div(SafeMath.mul(keyPrice, KEY_HOLDERS_DIVIDEND), 100); uint256 _marketingFee = SafeMath.div(SafeMath.mul(keyPrice, MARKETING), 100); uint256 _finalPot = SafeMath.div(SafeMath.mul(keyPrice, FINAL_POT), 100); uint256 _nextPot = keyPrice - (_referralBonus + _profitTHT + _dividends + _marketingFee + _finalPot); if (msg.value < keyPrice) revert(); if (repay > 0) msg.sender.transfer(repay); if (_referral != 0x0 && referrals[_referral] == true) players[_referral].referrals += _referralBonus; else owner.transfer(_referralBonus); uint256 _fee = _dividends * MAGINITUDE; nextPot = SafeMath.add(nextPot, _nextPot); profitTHT = SafeMath.add(profitTHT, _profitTHT); if (g.keyLevel > 1) { g.profitPerShare += (_dividends * MAGINITUDE / g.keyLevel); _fee = _fee - (_fee - (1 * (_dividends * MAGINITUDE / g.keyLevel))); } int256 _updatedPayouts = (int256) (g.profitPerShare * 1 - _fee); updatePlayer(msg.sender, _updatedPayouts); updateGame(_finalPot); sendToTeamMaketing(_marketingFee); sendProfitTTH(); emit Buy(round, msg.sender, keyPrice, games[round].keyLevel); }",
        "vulnerability": "Reentrancy vulnerability in refund logic",
        "reason": "The function attempts to refund the excess ether sent by the buyer before updating the state variables. An attacker could exploit this by calling the function recursively and draining the contract's funds. The refund should occur after the state variables have been updated to prevent reentrancy attacks.",
        "file_name": "0x05af72594440cf75c0fdcbbd9993fc26f62c7afc.sol"
    },
    {
        "function_name": "sendToTeamMaketing",
        "code": "function sendToTeamMaketing(uint256 _marketingFee) private { uint256 profit = SafeMath.div(SafeMath.mul(_marketingFee, 10), 100); for (uint256 idx = 0; idx < 10; idx++) { teamMarketing[idx].transfer(profit); } }",
        "vulnerability": "Unrestricted ether transfer to team addresses",
        "reason": "The function assumes that all addresses in the teamMarketing array can accept ether transfers. If any of these addresses are contracts without a payable fallback function, the transfer will fail and revert the transaction, potentially locking funds in the contract.",
        "file_name": "0x05af72594440cf75c0fdcbbd9993fc26f62c7afc.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public disableContract { if (games[round].ended == false && games[round].endTime <= now) endRound(); if (games[players[msg.sender].curentRound].ended == true) updatePlayerEndRound(msg.sender); Player storage p = players[msg.sender]; uint256 _dividends = calculateDividends(msg.sender, p.curentRound); uint256 balance = SafeMath.add(p.bonus, _dividends); balance = SafeMath.add(balance, p.dividends); require(balance > 0); if (address(this).balance >= balance) { p.bonus = 0; p.dividends = 0; if (p.curentRound == round) p.payouts += (int256) (_dividends * MAGINITUDE); msg.sender.transfer(balance); emit Withdraw(msg.sender, balance); } }",
        "vulnerability": "Potential denial of service due to gas limit",
        "reason": "The withdraw function can consume a significant amount of gas, especially when the number of players or rounds is large. If the gas limit is exceeded, the function call will fail, preventing users from withdrawing their funds. This could lead to a denial of service for users trying to access their dividends.",
        "file_name": "0x05af72594440cf75c0fdcbbd9993fc26f62c7afc.sol"
    }
]