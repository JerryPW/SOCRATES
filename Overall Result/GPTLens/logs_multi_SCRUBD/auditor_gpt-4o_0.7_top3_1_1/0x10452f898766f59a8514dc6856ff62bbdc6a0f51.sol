[
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The Collect function uses call.value()() to send ether to the msg.sender. This is a low-level call that forwards all remaining gas, allowing the recipient to re-enter the contract before the state update acc.balance -= _am is executed. An attacker could exploit this by re-entering and calling Collect again, draining funds.",
        "file_name": "0x10452f898766f59a8514dc6856ff62bbdc6a0f51.sol"
    },
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Improper balance checks",
        "reason": "The Collect function checks whether acc.balance >= _am and acc.balance >= MinSum but does not check if acc.balance - _am is still >= MinSum after the deduction. This could allow partial withdrawals below the minimum balance required, potentially leading to inconsistencies or bypassing intended contract restrictions.",
        "file_name": "0x10452f898766f59a8514dc6856ff62bbdc6a0f51.sol"
    },
    {
        "function_name": "function()",
        "code": "function() public payable { Put(0); }",
        "vulnerability": "Fallback function can reset unlock time",
        "reason": "The fallback function calls Put with a parameter of 0, which can set the unlockTime to 'now' if the current unlockTime is in the future. This allows anyone sending ether to the contract to reset the unlockTime for their account, potentially unlocking funds prematurely.",
        "file_name": "0x10452f898766f59a8514dc6856ff62bbdc6a0f51.sol"
    }
]