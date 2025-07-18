[
    {
        "function_name": "revoke",
        "code": "function revoke() public onlyAdministrator activeGame { for (uint i = 0; i < ticketIndex.length; i++) { tickets[ticketIndex[i]].is_active = false; ticketIndex[i].transfer(bet); } state = State.REVOKED; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The revoke function involves transferring Ether back to players in a loop without following the checks-effects-interactions pattern. An attacker could exploit this by using a fallback function that calls back into the contract, potentially allowing for manipulation of state variables and disrupting the function execution to cause unintended behavior.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    },
    {
        "function_name": "finish",
        "code": "function finish() public onlyAdministrator activeGame { uint max_votes; for (uint i = 0; i < ticketIndex.length; i++) { TicketLib.Ticket memory ticket = tickets[ticketIndex[i]]; uint vote = ( ( ticket.block_number * ticket.block_time ) + uint(ticketIndex[i]) ) % ticketIndex.length; tickets[ticketIndex[vote]].num_votes += 1; uint ticketNumVotes = tickets[ticketIndex[vote]].num_votes; if ( ticketNumVotes > max_votes ) { max_votes = ticketNumVotes; winnerIndex = vote; } } uint[] memory prizes = calcaultePrizes(); uint lastId = winnerIndex; for ( i = 0; i < prizes.length; i++ ) { if (tickets[ticketIndex[lastId]].is_active) { tickets[ticketIndex[lastId]].prize = prizes[i]; tickets[ticketIndex[lastId]].is_winner = true; ticketIndex[lastId].transfer(prizes[i]); } else { i--; } if ( lastId <= 0 ) { lastId = ticketIndex.length; } lastId -= 1; } administrator.transfer(this.balance); state = State.ENDED; GameFinished(ticketIndex[winnerIndex]); }",
        "vulnerability": "Gas limit and balance manipulation",
        "reason": "The finish function involves transferring prizes in a loop, which could run out of gas if the loop is too large, especially given the fixed gas stipend for transfers. An attacker could exploit this by ensuring many players are in the game, causing the function to fail and potentially locking funds. Additionally, the transfer of the remaining balance to the administrator could be manipulated by altering the contract's balance unexpectedly.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    },
    {
        "function_name": "getPrizeAmount",
        "code": "function getPrizeAmount() public constant returns (uint result) { uint totalAmount = this.balance; if ( state == State.ENDED ) { totalAmount = bet * ticketIndex.length; } result = calculator.getPrizeAmount(totalAmount); return result; }",
        "vulnerability": "Inconsistent prize calculation",
        "reason": "The getPrizeAmount function uses the contract's balance to determine the prize amount unless the state is ENDED, which relies on the bet and player count. If an attacker manipulates the contract balance through direct transfers or other means, it could lead to inconsistent and unfair prize calculations, benefiting the attacker or causing losses to legitimate players.",
        "file_name": "0xb588530e3956d9787b0429244ca360f566ff3301.sol"
    }
]