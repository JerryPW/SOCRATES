[
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses `call.value()` which forwards all available gas to the external address. This allows an attacker to recursively call `Collect` before the balance is updated, enabling them to drain all funds from the contract.",
        "file_name": "0x2d5df43d54ae164a912db8de092cf707b446f693.sol"
    },
    {
        "function_name": "Put",
        "code": "function Put(uint _unlockTime) public payable { var acc = Acc[msg.sender]; acc.balance += msg.value; acc.unlockTime = _unlockTime>now?_unlockTime:now; LogFile.AddMessage(msg.sender,msg.value,\"Put\"); }",
        "vulnerability": "Use of deprecated var type",
        "reason": "The use of `var` for the variable `acc` is deprecated in later versions of Solidity as it can lead to unexpected behavior. This is not directly exploitable but is a poor practice that can lead to vulnerabilities if not carefully managed.",
        "file_name": "0x2d5df43d54ae164a912db8de092cf707b446f693.sol"
    },
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "No check for call success",
        "reason": "The contract does not properly handle the case when the external call fails. If `msg.sender.call.value(_am)()` fails, the transaction will not revert, potentially leading to inconsistent state or unexpected behavior.",
        "file_name": "0x2d5df43d54ae164a912db8de092cf707b446f693.sol"
    }
]