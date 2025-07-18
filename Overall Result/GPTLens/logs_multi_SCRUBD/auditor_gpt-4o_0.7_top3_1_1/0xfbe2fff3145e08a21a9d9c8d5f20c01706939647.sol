[
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `Collect` uses `call.value()` to send Ether to the caller without updating the balance before the call. This allows an attacker to re-enter the `Collect` function in the fallback function and drain the contract's balance.",
        "file_name": "0xfbe2fff3145e08a21a9d9c8d5f20c01706939647.sol"
    },
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Unrestricted Ether withdrawal",
        "reason": "The function allows any user with a balance over `MinSum` to withdraw arbitrary amounts of Ether, provided they meet the unlock time condition. This can be exploited by users to withdraw excess Ether if there are issues with the logic or state management.",
        "file_name": "0xfbe2fff3145e08a21a9d9c8d5f20c01706939647.sol"
    },
    {
        "function_name": "Put",
        "code": "function Put(uint _unlockTime) public payable { var acc = Acc[msg.sender]; acc.balance += msg.value; acc.unlockTime = _unlockTime>now?_unlockTime:now; LogFile.AddMessage(msg.sender,msg.value,\"Put\"); }",
        "vulnerability": "Incorrect use of var keyword",
        "reason": "The function `Put` uses the `var` keyword, which was removed in Solidity 0.5.0, as it can lead to unintended type inference. This can cause vulnerabilities or errors in future Solidity versions or when migrating to newer compiler versions.",
        "file_name": "0xfbe2fff3145e08a21a9d9c8d5f20c01706939647.sol"
    }
]