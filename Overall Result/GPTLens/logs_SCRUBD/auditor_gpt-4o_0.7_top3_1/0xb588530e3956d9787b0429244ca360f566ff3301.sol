[
    {
        "function_name": "revoke",
        "code": "function revoke() public onlyAdministrator activeGame { for (uint i = 0; i < ticketIndex.length; i++) { tickets[ticketIndex[i]].is_active = false; ticketIndex[i].transfer(bet); } state = State.REVOKED; }",
        "vulnerability": "Reentrancy",
        "reason": "The 'revoke' function initiates a refund to each player using 'transfer', which could potentially lead to a reentrancy attack if an attacker re-enters the contract during the refund process. Although 'transfer' only forwards 2300 gas, it is still advisable to implement checks-effects-interactions pattern to prevent any reentrancy vulnerabilities.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    },
    {
        "function_name": "finish",
        "code": "function finish() public onlyAdministrator activeGame { uint max_votes; for (uint i = 0; i < ticketIndex.length; i++) { TicketLib.Ticket memory ticket = tickets[ticketIndex[i]]; uint vote = ( ( ticket.block_number * ticket.block_time ) + uint(ticketIndex[i]) ) % ticketIndex.length; tickets[ticketIndex[vote]].num_votes += 1; uint ticketNumVotes = tickets[ticketIndex[vote]].num_votes; if ( ticketNumVotes > max_votes ) { max_votes = ticketNumVotes; winnerIndex = vote; } } uint[] memory prizes = calcaultePrizes(); uint lastId = winnerIndex; for ( i = 0; i < prizes.length; i++ ) { if (tickets[ticketIndex[lastId]].is_active) { tickets[ticketIndex[lastId]].prize = prizes[i]; tickets[ticketIndex[lastId]].is_winner = true; ticketIndex[lastId].transfer(prizes[i]); } else { i--; } if ( lastId <= 0 ) { lastId = ticketIndex.length; } lastId -= 1; } administrator.transfer(this.balance); state = State.ENDED; GameFinished(ticketIndex[winnerIndex]); }",
        "vulnerability": "Incorrect Loop Logic",
        "reason": "The loop logic in the 'finish' function decreases 'lastId' after each iteration, but when 'lastId' is zero, it sets it to 'ticketIndex.length'. This can cause an infinite loop if there are inactive tickets at the end of the list, as 'i--' will decrease the loop counter, potentially skipping the condition to exit the loop.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    },
    {
        "function_name": "play",
        "code": "function play() public payable validBet onlyPlayer { require(tickets[msg.sender].block_number == 0); require(ticketIndex.length < 200); tickets[msg.sender].is_winner = false; tickets[msg.sender].is_active = true; tickets[msg.sender].block_number = block.number; tickets[msg.sender].block_time = block.timestamp; tickets[msg.sender].num_votes = 0; ticketIndex.push(msg.sender); NewPlayerAdded(ticketIndex.length, getPrizeAmount()); }",
        "vulnerability": "Block Timing Manipulation",
        "reason": "The 'play' function records 'block.timestamp' and 'block.number' as part of the player's ticket. These values are later used in the 'finish' function to determine the winner. Miners can manipulate the block timestamp within a certain range, which can be exploited to influence the game's outcome, especially if the miner is also a participant.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    }
]