[
    {
        "function_name": "endRound",
        "code": "function endRound() private disableContract { require(games[round].ended == false && games[round].endTime <= now); Game storage g = games[round]; address keyHolder = g.keyHolder; g.ended = true; players[keyHolder].bonus += g.finalPot; startRound(); emit EndRound(g.round, g.finalPot, g.keyHolder, g.keyLevel, g.endTime); }",
        "vulnerability": "Reentrancy",
        "reason": "The `endRound` function updates the game state and player's bonuses before calling `startRound()`, which could be manipulated by an attacker to re-enter the function. This could lead to multiple claims of the `finalPot` if an attacker manages to re-enter the function before it completes.",
        "file_name": "0x05af72594440cf75c0fdcbbd9993fc26f62c7afc.sol"
    },
    {
        "function_name": "verifyReferrals",
        "code": "function verifyReferrals() public payable disableContract { require(msg.value >= VERIFY_REFERRAL_PRICE); referrals[msg.sender] = true; owner.transfer(msg.value); }",
        "vulnerability": "Improper Ether Handling",
        "reason": "The `verifyReferrals` function transfers Ether from the caller to the owner without any checks on the owner's ability to receive Ether. If the owner's address is a contract with no payable fallback, the transaction will fail, causing a denial of service for this function.",
        "file_name": "0x05af72594440cf75c0fdcbbd9993fc26f62c7afc.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public disableContract { if (games[round].ended == false && games[round].endTime <= now) endRound(); if (games[players[msg.sender].curentRound].ended == true) updatePlayerEndRound(msg.sender); Player storage p = players[msg.sender]; uint256 _dividends = calculateDividends(msg.sender, p.curentRound); uint256 balance = SafeMath.add(p.bonus, _dividends); balance = SafeMath.add(balance, p.dividends); require(balance > 0); if (address(this).balance >= balance) { p.bonus = 0; p.dividends = 0; if (p.curentRound == round) p.payouts += (int256) (_dividends * MAGINITUDE); msg.sender.transfer(balance); emit Withdraw(msg.sender, balance); } }",
        "vulnerability": "Reentrancy",
        "reason": "The `withdraw` function sends Ether to `msg.sender` before updating the player's state variables (`bonus`, `dividends`). An attacker could exploit this by re-entering the `withdraw` function through a fallback function, potentially allowing multiple withdrawals before the state is updated, leading to loss of funds.",
        "file_name": "0x05af72594440cf75c0fdcbbd9993fc26f62c7afc.sol"
    }
]