[
    {
        "function_name": "oraclize_query",
        "code": "function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){ uint price = oraclize.getPrice(datasource); if (price > 1 ether + tx.gasprice*200000) return 0; return oraclize.query.value(price)(0, datasource, arg); }",
        "vulnerability": "Oraclize query payment calculation vulnerability",
        "reason": "The function calculates the payment for the Oraclize query without checking the actual available balance in the contract. This can allow an attacker to call queries without paying the necessary gas costs, leading to potential denial of service due to excessive queries or financial loss for the contract owner.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    },
    {
        "function_name": "buyTicket",
        "code": "function buyTicket(uint in_amount) public payable { uint amount = in_amount; if(in_amount > ticketPool.sub(ticketsBought)){ amount = ticketPool.sub(ticketsBought); queueAmount[queueLength] = in_amount.sub(amount); queueAddress[queueLength] = msg.sender; queueFunds = queueFunds.add((in_amount.sub(amount)).mul(ticketPrice)); queueLength = queueLength.add(1); } require(msg.value == (ticketPrice.mul(in_amount))); require(amount <= ticketPool.sub(ticketsBought)); require(in_amount > 0); if(amount > 0){ ticketsBought = ticketsBought.add(amount); buyers[buyerNumber] = msg.sender; amounts[buyerNumber] = amount; buyerNumber++; BuyTickets(address(this), msg.sender, amount); if(ticketsBought >= ticketPool){ jackpot = jackpot.add(jackpotCut); token.awardToken(msg.sender, 1); ledgerCount = 0; getRandom(); } token.awardToken(msg.sender, amount); } }",
        "vulnerability": "Incorrect payment handling",
        "reason": "The function does not correctly handle the situation when the provided ETH does not match the required ticket price. This can lead to incorrect bookkeeping and potential financial discrepancies. Also, users can queue for more tickets than available without an immediate payment, allowing them to potentially block others from purchasing tickets.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    },
    {
        "function_name": "takeAll",
        "code": "function takeAll() public onlyOwner { msg.sender.transfer(address(this).balance); }",
        "vulnerability": "Potential loss of funds",
        "reason": "This function allows the contract owner to withdraw all ether from the contract. It does not account for outstanding obligations (e.g., prize payouts or refunds), which could lead to scenarios where winners are not paid out or refunds cannot be issued, resulting in potential loss of funds for users.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    }
]