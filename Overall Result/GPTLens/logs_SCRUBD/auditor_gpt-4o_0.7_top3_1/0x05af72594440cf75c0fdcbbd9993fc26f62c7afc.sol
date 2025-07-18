[
    {
        "function_name": "endRound",
        "code": "function endRound() private disableContract { require(games[round].ended == false && games[round].endTime <= now); Game storage g = games[round]; address keyHolder = g.keyHolder; g.ended = true; players[keyHolder].bonus += g.finalPot; startRound(); emit EndRound(g.round, g.finalPot, g.keyHolder, g.keyLevel, g.endTime); }",
        "vulnerability": "Block Timestamp Manipulation",
        "reason": "The function `endRound` uses the block timestamp (`now`) to determine the end of the round. Miners can manipulate timestamps slightly to their advantage, potentially affecting the timing of round endings and the assignment of final pots. This could be exploited by miners to gain unfair advantage in the game rounds, especially when they are key holders.",
        "file_name": "0x05af72594440cf75c0fdcbbd9993fc26f62c7afc.sol"
    },
    {
        "function_name": "sendToTeamMaketing",
        "code": "function sendToTeamMaketing(uint256 _marketingFee) private { uint256 profit = SafeMath.div(SafeMath.mul(_marketingFee, 10), 100); for (uint256 idx = 0; idx < 10; idx++) { teamMarketing[idx].transfer(profit); } }",
        "vulnerability": "DoS with Unexpected Ether Transfer",
        "reason": "The `sendToTeamMaketing` function transfers ether to each address in the `teamMarketing` array. If any of these addresses is a contract that reverts on receiving ether, the entire transaction will fail. This can be exploited as a Denial of Service (DoS) attack vector, preventing the successful completion of the `buy` function and affecting the game flow.",
        "file_name": "0x05af72594440cf75c0fdcbbd9993fc26f62c7afc.sol"
    },
    {
        "function_name": "buy",
        "code": "function buy(address _referral) public payable disableContract { require(init == true); require(games[round].ended == false); require(msg.sender != _referral); if (games[round].endTime <= now) endRound(); Game storage g = games[round]; uint256 keyPrice = SafeMath.mul(g.keyLevel, KEY_PRICE_DEFAULT); uint256 repay = SafeMath.sub(msg.value, keyPrice); uint256 _referralBonus = SafeMath.div(SafeMath.mul(keyPrice, REFERRAL), 100); uint256 _profitTHT = SafeMath.div(SafeMath.mul(keyPrice, THT_TOKEN_OWNERS), 100); uint256 _dividends = SafeMath.div(SafeMath.mul(keyPrice, KEY_HOLDERS_DIVIDEND), 100); uint256 _marketingFee = SafeMath.div(SafeMath.mul(keyPrice, MARKETING), 100); uint256 _finalPot = SafeMath.div(SafeMath.mul(keyPrice, FINAL_POT), 100); uint256 _nextPot = keyPrice - (_referralBonus + _profitTHT + _dividends + _marketingFee + _finalPot); if (msg.value < keyPrice) revert(); if (repay > 0) msg.sender.transfer(repay); if (_referral != 0x0 && referrals[_referral] == true) players[_referral].referrals += _referralBonus; else owner.transfer(_referralBonus); uint256 _fee = _dividends * MAGINITUDE; nextPot = SafeMath.add(nextPot, _nextPot); profitTHT = SafeMath.add(profitTHT, _profitTHT); if (g.keyLevel > 1) { g.profitPerShare += (_dividends * MAGINITUDE / g.keyLevel); _fee = _fee - (_fee - (1 * (_dividends * MAGINITUDE / g.keyLevel))); } int256 _updatedPayouts = (int256) (g.profitPerShare * 1 - _fee); updatePlayer(msg.sender, _updatedPayouts); updateGame(_finalPot); sendToTeamMaketing(_marketingFee); sendProfitTTH(); emit Buy(round, msg.sender, keyPrice, games[round].keyLevel); }",
        "vulnerability": "Reentrancy",
        "reason": "The `buy` function transfers ether back to the `msg.sender` if `repay > 0`, before updating the state variables. If `msg.sender` is a contract, it can re-enter the `buy` function and potentially manipulate the state or cause unexpected behavior. This vulnerability is particularly concerning because the contract uses fallback functions for `msg.sender`, which could lead to reentrancy attacks.",
        "file_name": "0x05af72594440cf75c0fdcbbd9993fc26f62c7afc.sol"
    }
]