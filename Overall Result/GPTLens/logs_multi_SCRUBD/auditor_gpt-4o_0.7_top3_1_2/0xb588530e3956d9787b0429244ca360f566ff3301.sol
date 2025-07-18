[
    {
        "function_name": "revoke",
        "code": "function revoke() public onlyAdministrator activeGame { for (uint i = 0; i < ticketIndex.length; i++) { tickets[ticketIndex[i]].is_active = false; ticketIndex[i].transfer(bet); } state = State.REVOKED; }",
        "vulnerability": "Reentrancy vulnerability during refund",
        "reason": "The function iterates through the ticketIndex array to refund each player their bet amount. However, the transfer of Ether is performed before setting the state to REVOKED, allowing a reentrancy attack. An attacker could repeatedly call the fallback function to drain the contract's funds before all players are refunded.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    },
    {
        "function_name": "finish",
        "code": "function finish() public onlyAdministrator activeGame { uint max_votes; for (uint i = 0; i < ticketIndex.length; i++) { TicketLib.Ticket memory ticket = tickets[ticketIndex[i]]; uint vote = ( ( ticket.block_number * ticket.block_time ) + uint(ticketIndex[i]) ) % ticketIndex.length; tickets[ticketIndex[vote]].num_votes += 1; uint ticketNumVotes = tickets[ticketIndex[vote]].num_votes; if ( ticketNumVotes > max_votes ) { max_votes = ticketNumVotes; winnerIndex = vote; } } uint[] memory prizes = calcaultePrizes(); uint lastId = winnerIndex; for ( i = 0; i < prizes.length; i++ ) { if (tickets[ticketIndex[lastId]].is_active) { tickets[ticketIndex[lastId]].prize = prizes[i]; tickets[ticketIndex[lastId]].is_winner = true; ticketIndex[lastId].transfer(prizes[i]); } else { i--; } if ( lastId <= 0 ) { lastId = ticketIndex.length; } lastId -= 1; } administrator.transfer(this.balance); state = State.ENDED; GameFinished(ticketIndex[winnerIndex]); }",
        "vulnerability": "Potential for Denial of Service (DoS) with Block Gas Limit",
        "reason": "The finish function contains multiple loops that iterate over all tickets and distribute prizes. If the ticketIndex array is too large, the function can run out of gas, making it impossible to finish the game. This affects the availability of the contract, as the game cannot be ended properly.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    },
    {
        "function_name": "finish",
        "code": "function finish() public onlyAdministrator activeGame { uint max_votes; for (uint i = 0; i < ticketIndex.length; i++) { TicketLib.Ticket memory ticket = tickets[ticketIndex[i]]; uint vote = ( ( ticket.block_number * ticket.block_time ) + uint(ticketIndex[i]) ) % ticketIndex.length; tickets[ticketIndex[vote]].num_votes += 1; uint ticketNumVotes = tickets[ticketIndex[vote]].num_votes; if ( ticketNumVotes > max_votes ) { max_votes = ticketNumVotes; winnerIndex = vote; } } uint[] memory prizes = calcaultePrizes(); uint lastId = winnerIndex; for ( i = 0; i < prizes.length; i++ ) { if (tickets[ticketIndex[lastId]].is_active) { tickets[ticketIndex[lastId]].prize = prizes[i]; tickets[ticketIndex[lastId]].is_winner = true; ticketIndex[lastId].transfer(prizes[i]); } else { i--; } if ( lastId <= 0 ) { lastId = ticketIndex.length; } lastId -= 1; } administrator.transfer(this.balance); state = State.ENDED; GameFinished(ticketIndex[winnerIndex]); }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The finish function uses transfer to send Ether, which forwards a fixed amount of gas. If a recipient's fallback function needs more gas than is provided, the transfer will fail. This can cause a revert, preventing the function from completing and potentially locking funds in the contract.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    }
]