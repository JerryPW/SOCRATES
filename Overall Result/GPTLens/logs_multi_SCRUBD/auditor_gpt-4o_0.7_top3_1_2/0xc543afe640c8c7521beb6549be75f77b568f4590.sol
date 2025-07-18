[
    {
        "function_name": "function()",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 2 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*PROFIT/100))); uint admin = msg.value*ADMIN_FEE/100; ADMIN.send(admin); pay(); } }",
        "vulnerability": "Potential reentrancy attack",
        "reason": "The contract sends ether to an external address (ADMIN) and then immediately calls the pay() function, which itself sends ether to other depositors. If ADMIN is a contract, it could potentially re-enter the contract within the send call, leading to unexpected behavior or draining of funds. Although the send method is generally considered safe from reentrancy (it only forwards 2300 gas), the logic flow could be exploited if the gas stipend changes or if there are other vulnerabilities present that increase the gas limit.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    },
    {
        "function_name": "function pay()",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Improper decrement of expected payment",
        "reason": "If the contract does not have enough balance to pay the full expected amount to a depositor, it sends whatever is left and reduces the depositor's expected amount by that partial payment. However, this could lead to a situation where subsequent deposits are insufficient to cover the remaining expectation, causing the depositor to receive less than their due. This is compounded by the fact that there is no mechanism for a depositor to claim the residual amount later.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    },
    {
        "function_name": "function getDeposits(address)",
        "code": "function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) { uint c = getDepositsCount(depositor); idxs = new uint[](c); deposits = new uint128[](c); expects = new uint128[](c); if(c > 0) { uint j = 0; for(uint i=currentReceiverIndex; i<queue.length; ++i){ Deposit storage dep = queue[i]; if(dep.depositor == depositor){ idxs[j] = i; deposits[j] = dep.deposit; expects[j] = dep.expect; j++; } } } }",
        "vulnerability": "Potential out-of-gas exception",
        "reason": "The getDeposits function iterates over the entire queue from the currentReceiverIndex to the end, which could be quite large. This could lead to an out-of-gas exception, especially when the queue length is large. This potential denial of service could be exploited by an attacker to disrupt the function execution and prevent users from retrieving their deposit information.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    }
]