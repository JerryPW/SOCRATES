[
    {
        "function_name": "transfer",
        "code": "function transfer(address to, uint tokens) public returns (bool success) { uint perc = ((balances[msg.sender] * 1000)/tokens); balances[msg.sender] = safeSub(balances[msg.sender], tokens); balances[to] = safeAdd(balances[to], tokens); Transfer(msg.sender, to, tokens); divC.updatePaid(msg.sender,to,perc); return true; }",
        "vulnerability": "Division by Zero",
        "reason": "The calculation of 'perc' involves dividing by 'tokens', which is not checked for zero. This could lead to a division by zero error, causing the transaction to revert unexpectedly and potentially leading to denial of service for users.",
        "file_name": "0x0e9186d1d0c7aa2212e3f42405eda1bc35d826a9.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address from, address to, uint tokens) public returns (bool success) { uint perc = ((balances[from] * 1000)/tokens); balances[from] = safeSub(balances[from], tokens); allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens); balances[to] = safeAdd(balances[to], tokens); Transfer(from, to, tokens); divC.updatePaid(from,to,perc); return true; }",
        "vulnerability": "Division by Zero",
        "reason": "Similar to the 'transfer' function, 'transferFrom' calculates 'perc' by dividing by 'tokens' without checking if 'tokens' is zero. This can lead to a division by zero error, causing the transaction to fail and disrupting the functionality for users.",
        "file_name": "0x0e9186d1d0c7aa2212e3f42405eda1bc35d826a9.sol"
    },
    {
        "function_name": "winner",
        "code": "function winner(uint _theNumber, bytes32 newNumber) onlyOwner payable { require ((timeLimit+86400)<now && number == keccak256(_theNumber)); uint8 add1 = uint8 (Tickets[ticketsSold/4].addr); uint8 add2 = uint8 (Tickets[ticketsSold/3].addr); uint8 time1 = uint8 (Tickets[ticketsSold/2].time); uint8 time2 = uint8 (Tickets[ticketsSold/8].time); uint winningNumber = uint8 (((add1+add2)-(time1+time2))*_theNumber)%ticketsSold; address winningTicket = address (Tickets[winningNumber].addr); uint winnings = uint (address(this).balance / 20) * 19; uint fees = uint (address(this).balance-winnings)/2; uint dividends = uint (address(this).balance-winnings)-fees; winningTicket.transfer(winnings); owner.transfer(fees); dividendsAccount.transfer(dividends); delete ticketsSold; timeLimit = now; number = newNumber; }",
        "vulnerability": "Unsafe Type Casting",
        "reason": "The function casts addresses and timestamps to uint8, which could lead to truncation errors. This might cause the 'winningNumber' calculation to yield incorrect results, potentially resulting in incorrect winner selection and unfair distribution of funds.",
        "file_name": "0x0e9186d1d0c7aa2212e3f42405eda1bc35d826a9.sol"
    }
]