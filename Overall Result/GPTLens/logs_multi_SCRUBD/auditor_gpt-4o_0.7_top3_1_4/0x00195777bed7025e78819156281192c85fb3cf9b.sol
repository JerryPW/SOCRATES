[
    {
        "function_name": "buyTicket",
        "code": "function buyTicket(uint in_amount) public payable { uint amount = in_amount; if(in_amount > ticketPool.sub(ticketsBought)){ amount = ticketPool.sub(ticketsBought); queueAmount[queueLength] = in_amount.sub(amount); queueAddress[queueLength] = msg.sender; queueFunds = queueFunds.add((in_amount.sub(amount)).mul(ticketPrice)); queueLength = queueLength.add(1); } require(msg.value == (ticketPrice.mul(in_amount))); require(amount <= ticketPool.sub(ticketsBought)); require(in_amount > 0); if(amount > 0){ ticketsBought = ticketsBought.add(amount); buyers[buyerNumber] = msg.sender; amounts[buyerNumber] = amount; buyerNumber++; BuyTickets(address(this), msg.sender, amount); if(ticketsBought >= ticketPool){ jackpot = jackpot.add(jackpotCut); token.awardToken(msg.sender, 1); ledgerCount = 0; getRandom(); } token.awardToken(msg.sender, amount); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function does not implement any reentrancy guard. An attacker can potentially exploit this by recursively calling buyTicket and modifying the state variables like queueAmount or queueFunds, which could lead to incorrect balances and loss of funds.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    },
    {
        "function_name": "startRaffle",
        "code": "function startRaffle(uint random) internal { require(ticketsBought == ticketPool); address winner = owner; uint tempSum = amounts[0]; uint count = 0; uint windex = (random % ticketPool).add(1); while(tempSum < windex){ count++; tempSum = tempSum.add(amounts[count]); } winner = buyers[count]; buyerNumber = 0; ticketsBought = 0; if (random <= ((jackpotChance.mul(1000000)).div(100)) && jackpotFactor > 0){ Winner(address(this), winner, winnerPrize, random, count); Jackpot(address(this), winner, (jackpot.mul(jackpotFactor)).div(100)); winner.transfer(winnerPrize.add((jackpot.mul(jackpotFactor)).div(100))); jackpot = jackpot.sub((jackpot.mul(jackpotFactor)).div(100)); } else { Winner(address(this), winner, winnerPrize, random, count); winner.transfer(winnerPrize); } bank.receiveFromGame.value(address(this).balance.sub((jackpot.add(tokenCut.add(queueFunds)))))(); bonus.receiveFromGame.value(tokenCut)(); if(queueAmount[queueIndex] > 0){ fillFromQueue(); } }",
        "vulnerability": "Unsafe Randomness",
        "reason": "The random number generation relies on the result from Oraclize, which is not a secure source of randomness. If an attacker can predict or manipulate the random number, they could potentially control the outcome of the raffle and win the prize unfairly.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    },
    {
        "function_name": "takeAll",
        "code": "function takeAll() public onlyOwner { msg.sender.transfer(address(this).balance); }",
        "vulnerability": "Owner Withdrawal of All Funds",
        "reason": "This function allows the contract owner to withdraw all funds from the contract at any time. This centralizes control and trust in the owner, which is against the ethos of decentralization and could be abused if the owner is malicious or compromised.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    }
]