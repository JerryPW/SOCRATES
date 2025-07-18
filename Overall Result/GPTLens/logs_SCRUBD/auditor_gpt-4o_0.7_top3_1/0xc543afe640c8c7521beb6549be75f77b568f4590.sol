[
    {
        "function_name": "function ()",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 2 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*PROFIT/100))); uint admin = msg.value*ADMIN_FEE/100; ADMIN.send(admin); pay(); } }",
        "vulnerability": "Unsafe use of send()",
        "reason": "The use of the send() function to transfer Ether is unsafe because it only forwards 2300 gas, which may not be sufficient if the recipient is a contract with a complex fallback function. This can lead to failed transfers and locked Ether, disrupting contract operation.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function pays out to depositors using send(), which forwards limited gas and can fail under certain conditions. Although send() reduces reentrancy risk, the logic here is complex and might still allow reentrancy if the depositor is a contract with a fallback function. Reentrancy can lead to manipulation of contract state, resulting in potential loss or theft of funds.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    },
    {
        "function_name": "function ()",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 2 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*PROFIT/100))); uint admin = msg.value*ADMIN_FEE/100; ADMIN.send(admin); pay(); } }",
        "vulnerability": "Lack of access control",
        "reason": "The fallback function allows anyone to send Ether to the contract and join the queue. Without restrictions or proper access controls, this could be exploited by attackers to drain or manipulate the contract by spamming transactions or flooding the queue.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    }
]