[
    {
        "function_name": "function () public payable",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 2 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*PROFIT/100))); uint admin = msg.value*ADMIN_FEE/100; ADMIN.send(admin); pay(); } }",
        "vulnerability": "Potential Denial of Service via Reentrancy",
        "reason": "The fallback function sends Ether to the ADMIN address before executing the pay() function. If the ADMIN address is a smart contract, it could potentially re-enter the contract during the send operation and manipulate the queue by altering the state before pay() is executed. This could potentially lead to a situation where the queue is manipulated to the advantage of the ADMIN contract, disrupting the expected payout order and potentially causing denial of service for other participants.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Unsafe usage of send() without handling failures",
        "reason": "The pay() function uses the send() method to transfer Ether to depositors. If the send operation fails (e.g., due to a recipient using more than 2300 gas units), it does not revert the transaction or handle the failure gracefully, which could lead to funds being stuck in the contract or an inconsistent state. This is especially critical in situations where the queue is partially processed, leaving some depositors unpaid when funds are available.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    },
    {
        "function_name": "getDeposits",
        "code": "function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) { uint c = getDepositsCount(depositor); idxs = new uint[](c); deposits = new uint128[](c); expects = new uint128[](c); if(c > 0) { uint j = 0; for(uint i=currentReceiverIndex; i<queue.length; ++i){ Deposit storage dep = queue[i]; if(dep.depositor == depositor){ idxs[j] = i; deposits[j] = dep.deposit; expects[j] = dep.expect; j++; } } } }",
        "vulnerability": "Potential Out of Gas Exception",
        "reason": "The getDeposits() function iterates over the entire queue to find deposits from a specific depositor. If the queue is large, this operation can consume a significant amount of gas, potentially leading to out-of-gas exceptions for users calling this function. This could prevent users from retrieving their deposit information, especially as the queue grows over time, leading to a denial of service for those attempting to view their deposit details.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    }
]