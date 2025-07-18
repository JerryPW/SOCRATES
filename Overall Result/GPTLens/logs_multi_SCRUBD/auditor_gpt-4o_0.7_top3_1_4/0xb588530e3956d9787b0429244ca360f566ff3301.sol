[
    {
        "function_name": "revoke",
        "code": "function revoke() public onlyAdministrator activeGame { for (uint i = 0; i < ticketIndex.length; i++) { tickets[ticketIndex[i]].is_active = false; ticketIndex[i].transfer(bet); } state = State.REVOKED; }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The revoke function transfers Ether to all players in a loop without updating the state beforehand. This allows a potential reentrancy attack where a malicious player could create a fallback function that calls revoke again, allowing them to drain more funds before the state is updated to REVOKED.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    },
    {
        "function_name": "finish",
        "code": "function finish() public onlyAdministrator activeGame { uint max_votes; for (uint i = 0; i < ticketIndex.length; i++) { TicketLib.Ticket memory ticket = tickets[ticketIndex[i]]; uint vote = ( ( ticket.block_number * ticket.block_time ) + uint(ticketIndex[i]) ) % ticketIndex.length; tickets[ticketIndex[vote]].num_votes += 1; uint ticketNumVotes = tickets[ticketIndex[vote]].num_votes; if ( ticketNumVotes > max_votes ) { max_votes = ticketNumVotes; winnerIndex = vote; } } uint[] memory prizes = calcaultePrizes(); uint lastId = winnerIndex; for ( i = 0; i < prizes.length; i++ ) { if (tickets[ticketIndex[lastId]].is_active) { tickets[ticketIndex[lastId]].prize = prizes[i]; tickets[ticketIndex[lastId]].is_winner = true; ticketIndex[lastId].transfer(prizes[i]); } else { i--; } if ( lastId <= 0 ) { lastId = ticketIndex.length; } lastId -= 1; } administrator.transfer(this.balance); state = State.ENDED; GameFinished(ticketIndex[winnerIndex]); }",
        "vulnerability": "Potential Denial of Service with Block Gas Limit",
        "reason": "The finish function contains loops that iterate over the ticketIndex array, which could potentially grow large. If the array size exceeds the block gas limit, the function may run out of gas, resulting in a denial of service as it will be impossible to finish the game.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    },
    {
        "function_name": "play",
        "code": "function play() public payable validBet onlyPlayer { require(tickets[msg.sender].block_number == 0); require(ticketIndex.length < 200); tickets[msg.sender].is_winner = false; tickets[msg.sender].is_active = true; tickets[msg.sender].block_number = block.number; tickets[msg.sender].block_time = block.timestamp; tickets[msg.sender].num_votes = 0; ticketIndex.push(msg.sender); NewPlayerAdded(ticketIndex.length, getPrizeAmount()); }",
        "vulnerability": "Block Timestamp Manipulation",
        "reason": "The play function uses block.timestamp to record the block_time in the Ticket struct. Miners can manipulate the block timestamp to some extent, which can be exploited to gain an advantage in the game, especially if the timestamp is used in calculations affecting the outcome.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    }
]