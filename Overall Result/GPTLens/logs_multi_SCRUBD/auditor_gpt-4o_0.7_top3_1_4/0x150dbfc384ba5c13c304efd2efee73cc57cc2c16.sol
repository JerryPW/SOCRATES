[
    {
        "function_name": "purchase",
        "code": "function purchase(address addr) public { require(msg.sender == owner); amount[addr]++; if (amount[addr] > 1) { level[amount[addr]].push(addr); if (amount[addr] > 2) { for (uint256 i = 0; i < level[amount[addr] - 1].length; i++) { if (level[amount[addr] - 1][i] == addr) { delete level[amount[addr] - 1][i]; break; } } } else if (amount[addr] == 2) { count++; } if (amount[addr] > maximum) { maximum = amount[addr]; } } }",
        "vulnerability": "Owner-only function with critical operations",
        "reason": "The `purchase` function can only be called by the contract owner, which means user purchases can't be independently verified or executed. This could allow the owner to manipulate the purchase records, potentially adding entries for addresses that have not actually purchased anything.",
        "file_name": "0x150dbfc384ba5c13c304efd2efee73cc57cc2c16.sol"
    },
    {
        "function_name": "drawing",
        "code": "function drawing() internal { require(block.number > futureblock, \"Awaiting for a future block\"); if (block.number >= futureblock + 230) { futureblock = block.number + 20; return; } uint256 gas = gasleft(); for (uint256 i = 0; i < silver[0]; i++) { address winner = players[uint((blockhash(futureblock - 1 - i))) % players.length]; winner.send(silver[1]); WT.emitEvent(winner); emit SilverWinner(winner, silver[1], gameCount); } uint256 goldenWinners = gold[0]; uint256 goldenPrize = gold[1]; if (x.count() < gold[0]) { goldenWinners = x.count(); goldenPrize = gold[0] * gold[1] / x.count(); } if (goldenWinners != 0) { address[] memory addresses = x.draw(goldenWinners); for (uint256 k = 0; k < addresses.length; k++) { addresses[k].send(goldenPrize); RS.sendBonus(addresses[k]); WT.emitEvent(addresses[k]); emit GoldenWinner(addresses[k], goldenPrize, gameCount); } } uint256 laps = 10; uint256 winnerIdx; uint256 indexes = players.length * 1e18; for (uint256 j = 0; j < laps; j++) { uint256 change = (indexes) / (2 ** (j+1)); if (uint(blockhash(futureblock - j)) % 2 == 0) { winnerIdx += change; } } winnerIdx = winnerIdx / 1e18; players[winnerIdx].send(brilliant[1]); WT.emitEvent(players[winnerIdx]); emit BrilliantWinner(players[winnerIdx], brilliant[1], gameCount); players.length = 0; futureblock = 0; x = new Storage(); gameCount++; uint256 txCost = tx.gasprice * (gas - gasleft()); msg.sender.send(txCost); emit txCostRefunded(msg.sender, txCost); uint256 fee = address(this).balance - msg.value; owner.send(fee); emit FeePayed(owner, fee); }",
        "vulnerability": "Predictable randomness",
        "reason": "The `drawing` function uses `blockhash` for randomness, which can be manipulated by miners. This predictability allows an attacker to influence the outcome of the lottery drawing, potentially ensuring they win a prize.",
        "file_name": "0x150dbfc384ba5c13c304efd2efee73cc57cc2c16.sol"
    },
    {
        "function_name": "withdrawERC20",
        "code": "function withdrawERC20(address ERC20Token, address recipient) external onlyOwner { uint256 amount = IERC20(ERC20Token).balanceOf(address(this)); IERC20(ERC20Token).transfer(recipient, amount); }",
        "vulnerability": "Lack of access control for emergency withdrawal",
        "reason": "The `withdrawERC20` function allows the owner to withdraw any ERC20 token from the contract at any time. While it is restricted by `onlyOwner`, there's no mechanism to ensure this is used only in emergencies, potentially leading to misuse by the contract owner.",
        "file_name": "0x150dbfc384ba5c13c304efd2efee73cc57cc2c16.sol"
    }
]