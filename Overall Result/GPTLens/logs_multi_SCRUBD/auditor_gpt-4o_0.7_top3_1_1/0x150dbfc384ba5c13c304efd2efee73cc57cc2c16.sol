[
    {
        "function_name": "purchase",
        "code": "function purchase(address addr) public { require(msg.sender == owner); amount[addr]++; if (amount[addr] > 1) { level[amount[addr]].push(addr); if (amount[addr] > 2) { for (uint256 i = 0; i < level[amount[addr] - 1].length; i++) { if (level[amount[addr] - 1][i] == addr) { delete level[amount[addr] - 1][i]; break; } } } else if (amount[addr] == 2) { count++; } if (amount[addr] > maximum) { maximum = amount[addr]; } } }",
        "vulnerability": "Owner-only function with no external checks",
        "reason": "The 'purchase' function can only be called by the owner, which means it's vulnerable to a compromised owner account. If an attacker gains access to the owner's account, they can manipulate the purchasing mechanism and potentially disrupt the integrity of the lottery structure.",
        "file_name": "0x150dbfc384ba5c13c304efd2efee73cc57cc2c16.sol"
    },
    {
        "function_name": "draw",
        "code": "function draw(uint256 goldenWinners) public view returns(address[] addresses) { addresses = new address[](goldenWinners); uint256 winnersCount; for (uint256 i = maximum; i >= 2; i--) { for (uint256 j = 0; j < level[i].length; j++) { if (level[i][j] != address(0)) { addresses[winnersCount] = level[i][j]; winnersCount++; if (winnersCount == goldenWinners) { return; } } } } }",
        "vulnerability": "Potential out-of-gas error",
        "reason": "The 'draw' function iterates over mappings that can grow indefinitely in size. When the mappings get too large, this function can run out of gas and fail, making it unusable and potentially blocking the lottery draw process.",
        "file_name": "0x150dbfc384ba5c13c304efd2efee73cc57cc2c16.sol"
    },
    {
        "function_name": "function()",
        "code": "function() public payable notFromContract { if (players.length == 0 && paused) { revert(); } if (players.length == limit) { drawing(); if (players.length == 0 && paused || msg.value < PRICE) { msg.sender.transfer(msg.value); return; } } require(msg.value >= PRICE); if (msg.value > PRICE) { msg.sender.transfer(msg.value - PRICE); } if (msg.data.length != 0) { RS.addReferrer(bytesToAddress(bytes(msg.data))); } players.push(msg.sender); x.purchase(msg.sender); RS.newTicket(); LT.emitEvent(msg.sender); emit NewPlayer(msg.sender, gameCount); if (players.length == limit) { drawing(); } }",
        "vulnerability": "Improper use of blockhash for randomness",
        "reason": "The fallback function relies on 'blockhash' for randomness in selecting winners. However, blockhash is manipulatable by miners within a certain range, allowing them to influence the outcome of the lottery draws and potentially choose winners dishonestly.",
        "file_name": "0x150dbfc384ba5c13c304efd2efee73cc57cc2c16.sol"
    }
]