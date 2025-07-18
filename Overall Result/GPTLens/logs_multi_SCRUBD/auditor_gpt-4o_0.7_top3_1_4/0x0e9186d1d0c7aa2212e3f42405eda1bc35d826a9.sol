[
    {
        "function_name": "transfer",
        "code": "function transfer(address to, uint tokens) public returns (bool success) { uint perc = ((balances[msg.sender] * 1000)/tokens); balances[msg.sender] = safeSub(balances[msg.sender], tokens); balances[to] = safeAdd(balances[to], tokens); Transfer(msg.sender, to, tokens); divC.updatePaid(msg.sender,to,perc); return true; }",
        "vulnerability": "Division by zero vulnerability",
        "reason": "In the transfer function, the calculation of 'perc' can lead to a division by zero error if 'tokens' is zero. This would cause the transaction to revert, potentially disrupting the functionality for users transferring zero tokens, which is a likely scenario given that users might not always check the token value before initiating a transfer.",
        "file_name": "0x0e9186d1d0c7aa2212e3f42405eda1bc35d826a9.sol"
    },
    {
        "function_name": "transferAnyERC20Token",
        "code": "function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) { return ERC20Interface(tokenAddress).transfer(owner, tokens); }",
        "vulnerability": "Owner can withdraw any ERC20 tokens from the contract",
        "reason": "The function transferAnyERC20Token allows the owner to withdraw any amount of ERC20 tokens from the contract's balance. This poses a risk of the owner maliciously transferring tokens to themselves, which can be detrimental to token holders and the trust in the contract. This is a severe vulnerability as it centralizes control over the contract's assets to a single entity.",
        "file_name": "0x0e9186d1d0c7aa2212e3f42405eda1bc35d826a9.sol"
    },
    {
        "function_name": "winner",
        "code": "function winner(uint _theNumber, bytes32 newNumber) onlyOwner payable { require ((timeLimit+86400)<now && number == keccak256(_theNumber)); uint8 add1 = uint8 (Tickets[ticketsSold/4].addr); uint8 add2 = uint8 (Tickets[ticketsSold/3].addr); uint8 time1 = uint8 (Tickets[ticketsSold/2].time); uint8 time2 = uint8 (Tickets[ticketsSold/8].time); uint winningNumber = uint8 (((add1+add2)-(time1+time2))*_theNumber)%ticketsSold; address winningTicket = address (Tickets[winningNumber].addr); uint winnings = uint (address(this).balance / 20) * 19; uint fees = uint (address(this).balance-winnings)/2; uint dividends = uint (address(this).balance-winnings)-fees; winningTicket.transfer(winnings); owner.transfer(fees); dividendsAccount.transfer(dividends); delete ticketsSold; timeLimit = now; number = newNumber; }",
        "vulnerability": "Predictable randomness vulnerability",
        "reason": "The function winner uses predictable values (addresses and timestamps of tickets) to determine the winning number. This makes it possible for a malicious actor to predict the outcome of the draw, especially if they have knowledge of the ticket addresses and timestamps. The use of predictable factors for randomness compromises the integrity of the draw and can be exploited to manipulate the outcome.",
        "file_name": "0x0e9186d1d0c7aa2212e3f42405eda1bc35d826a9.sol"
    }
]