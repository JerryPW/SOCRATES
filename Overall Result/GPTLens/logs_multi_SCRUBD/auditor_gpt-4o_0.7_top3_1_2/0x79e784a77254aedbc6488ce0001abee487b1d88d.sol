[
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The Collect function uses call.value() to send funds, which is vulnerable to reentrancy attacks. An attacker could call Collect and recursively call it again before the balance is updated, allowing them to drain funds.",
        "file_name": "0x79e784a77254aedbc6488ce0001abee487b1d88d.sol"
    },
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Improper handling of send failure",
        "reason": "The function does not handle the failure of msg.sender.call.value(_am)(). If the call fails, the balance is not updated, and the function does not return any indication of failure, potentially leading to inconsistencies.",
        "file_name": "0x79e784a77254aedbc6488ce0001abee487b1d88d.sol"
    },
    {
        "function_name": "Put",
        "code": "function Put(uint _unlockTime) public payable { var acc = Acc[msg.sender]; acc.balance += msg.value; acc.unlockTime = _unlockTime>now?_unlockTime:now; LogFile.AddMessage(msg.sender,msg.value,\"Put\"); }",
        "vulnerability": "Timestamp dependence",
        "reason": "The function uses the now keyword to set unlockTime. This makes the contract vulnerable to miners influencing the block timestamp to their advantage, potentially affecting when funds can be collected.",
        "file_name": "0x79e784a77254aedbc6488ce0001abee487b1d88d.sol"
    }
]