[
    {
        "function_name": "Put",
        "code": "function Put(uint _unlockTime) public payable { var acc = Acc[msg.sender]; acc.balance += msg.value; acc.unlockTime = _unlockTime>now?_unlockTime:now; LogFile.AddMessage(msg.sender,msg.value,\"Put\"); }",
        "vulnerability": "Incorrect use of var and potential overwrite of account details.",
        "reason": "The use of `var` for `acc` only assigns a copy of the `Holder` struct, and any changes made to `acc` are not reflected back to the `Acc` mapping. This means changes to `acc.balance` and `acc.unlockTime` are not stored, potentially allowing any funds sent to this function to be lost as they don't affect the actual state of `Acc[msg.sender]`.",
        "file_name": "0x62500ad71aa50744bbd4917d1a64938897e952bf.sol"
    },
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Reentrancy vulnerability.",
        "reason": "The function uses `msg.sender.call.value(_am)()` to send ether, which is vulnerable to reentrancy. An attacker could create a fallback function in a malicious contract that calls `Collect` again before `acc.balance` is updated, potentially draining the contract's funds.",
        "file_name": "0x62500ad71aa50744bbd4917d1a64938897e952bf.sol"
    },
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Lack of proper error handling.",
        "reason": "The contract assumes that `msg.sender.call.value(_am)()` will always succeed, which is not guaranteed. If the transfer fails, the function does not have any mechanism to revert changes or handle the error, potentially leading to an inconsistent state.",
        "file_name": "0x62500ad71aa50744bbd4917d1a64938897e952bf.sol"
    }
]