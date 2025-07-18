[
    {
        "function_name": "function()",
        "code": "function() public payable notFromContract { if (players.length == 0 && paused) { revert(); } if (players.length == limit) { drawing(); if (players.length == 0 && paused || msg.value < PRICE) { msg.sender.transfer(msg.value); return; } } require(msg.value >= PRICE); if (msg.value > PRICE) { msg.sender.transfer(msg.value - PRICE); } if (msg.data.length != 0) { RS.addReferrer(bytesToAddress(bytes(msg.data))); } players.push(msg.sender); x.purchase(msg.sender); RS.newTicket(); LT.emitEvent(msg.sender); emit NewPlayer(msg.sender, gameCount); if (players.length == limit) { drawing(); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function allows Ether transfers back to the sender before updating the state variables, which can be exploited by reentrancy attacks. An attacker could repeatedly call this fallback function, causing unexpected behavior or depletion of contract funds.",
        "file_name": "0x150dbfc384ba5c13c304efd2efee73cc57cc2c16.sol"
    },
    {
        "function_name": "drawing",
        "code": "function drawing() internal { require(block.number > futureblock, \"Awaiting for a future block\"); if (block.number >= futureblock + 230) { futureblock = block.number + 20; return; } uint256 gas = gasleft(); for (uint256 i = 0; i < silver[0]; i++) { address winner = players[uint((blockhash(futureblock - 1 - i))) % players.length]; winner.send(silver[1]); WT.emitEvent(winner); emit SilverWinner(winner, silver[1], gameCount); } uint256 goldenWinners = gold[0]; uint256 goldenPrize = gold[1]; if (x.count() < gold[0]) { goldenWinners = x.count(); goldenPrize = gold[0] * gold[1] / x.count(); } if (goldenWinners != 0) { address[] memory addresses = x.draw(goldenWinners); for (uint256 k = 0; k < addresses.length; k++) { addresses[k].send(goldenPrize); RS.sendBonus(addresses[k]); WT.emitEvent(addresses[k]); emit GoldenWinner(addresses[k], goldenPrize, gameCount); } } uint256 laps = 10; uint256 winnerIdx; uint256 indexes = players.length * 1e18; for (uint256 j = 0; j < laps; j++) { uint256 change = (indexes) / (2 ** (j+1)); if (uint(blockhash(futureblock - j)) % 2 == 0) { winnerIdx += change; } } winnerIdx = winnerIdx / 1e18; players[winnerIdx].send(brilliant[1]); WT.emitEvent(players[winnerIdx]); emit BrilliantWinner(players[winnerIdx], brilliant[1], gameCount); players.length = 0; futureblock = 0; x = new Storage(); gameCount++; uint256 txCost = tx.gasprice * (gas - gasleft()); msg.sender.send(txCost); emit txCostRefunded(msg.sender, txCost); uint256 fee = address(this).balance - msg.value; owner.send(fee); emit FeePayed(owner, fee); }",
        "vulnerability": "Use of blockhash for randomness",
        "reason": "The function uses blockhash to determine winners, which is predictable by miners. Miners can manipulate blockhash values to influence the outcome of the lottery, potentially allowing them to win unfairly.",
        "file_name": "0x150dbfc384ba5c13c304efd2efee73cc57cc2c16.sol"
    },
    {
        "function_name": "withdrawERC20",
        "code": "function withdrawERC20(address ERC20Token, address recipient) external onlyOwner { uint256 amount = IERC20(ERC20Token).balanceOf(address(this)); IERC20(ERC20Token).transfer(recipient, amount); }",
        "vulnerability": "Lack of checks on ERC20 token transfers",
        "reason": "The withdrawERC20 function allows the owner to withdraw any ERC20 token without any restriction. This could be exploited if a malicious or compromised owner withdraws tokens, draining the contract's balance of those tokens without users' consent.",
        "file_name": "0x150dbfc384ba5c13c304efd2efee73cc57cc2c16.sol"
    }
]