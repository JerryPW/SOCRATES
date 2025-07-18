[
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of `msg.sender.call.value(_am)()` can lead to a reentrancy attack, where the attacker can recursively call the `Collect` function before the balance is updated, draining the contract's funds.",
        "file_name": "0x10452f898766f59a8514dc6856ff62bbdc6a0f51.sol"
    },
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Improper balance check and update",
        "reason": "The balance of the account is checked and updated after the call is made, which allows for the reentrancy attack to occur. The balance should be updated before the external call to prevent this.",
        "file_name": "0x10452f898766f59a8514dc6856ff62bbdc6a0f51.sol"
    },
    {
        "function_name": "Put",
        "code": "function Put(uint _unlockTime) public payable { var acc = Acc[msg.sender]; acc.balance += msg.value; acc.unlockTime = _unlockTime>now?_unlockTime:now; LogFile.AddMessage(msg.sender,msg.value,\"Put\"); }",
        "vulnerability": "Use of deprecated `var` keyword",
        "reason": "The use of `var` is deprecated and can lead to unexpected behavior. It's not type-safe, and the type inference might not work as intended, leading to unexpected results or errors in the code.",
        "file_name": "0x10452f898766f59a8514dc6856ff62bbdc6a0f51.sol"
    }
]