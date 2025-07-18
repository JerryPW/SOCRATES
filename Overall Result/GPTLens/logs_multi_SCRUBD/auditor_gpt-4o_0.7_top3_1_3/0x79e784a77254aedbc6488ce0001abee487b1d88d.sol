[
    {
        "function_name": "Collect",
        "code": "function Collect(uint _am) public payable { var acc = Acc[msg.sender]; if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime) { if(msg.sender.call.value(_am)()) { acc.balance-=_am; LogFile.AddMessage(msg.sender,_am,\"Collect\"); } } }",
        "vulnerability": "Reentrancy",
        "reason": "The use of 'call.value()' is susceptible to reentrancy attacks. An attacker can exploit this by calling Collect again before the first transaction completes, allowing them to drain funds from the contract by recursively calling 'Collect' before the balance is updated.",
        "file_name": "0x79e784a77254aedbc6488ce0001abee487b1d88d.sol"
    },
    {
        "function_name": "Y_WALLET",
        "code": "function Y_WALLET(address log) public{ LogFile = Log(log); }",
        "vulnerability": "Unrestricted access to Log contract",
        "reason": "The constructor allows any address to be passed for the Log contract. This could be exploited by an attacker to pass a malicious Log contract address that could disrupt the logging functionality or execute malicious code.",
        "file_name": "0x79e784a77254aedbc6488ce0001abee487b1d88d.sol"
    },
    {
        "function_name": "Put",
        "code": "function Put(uint _unlockTime) public payable { var acc = Acc[msg.sender]; acc.balance += msg.value; acc.unlockTime = _unlockTime>now?_unlockTime:now; LogFile.AddMessage(msg.sender,msg.value,\"Put\"); }",
        "vulnerability": "Incorrect handling of unlockTime",
        "reason": "The unlockTime is set to the greater of _unlockTime or now, meaning if _unlockTime is in the past, it defaults to now, potentially allowing immediate withdrawals. Attackers could exploit this by setting _unlockTime to 0, bypassing the intended locking mechanism.",
        "file_name": "0x79e784a77254aedbc6488ce0001abee487b1d88d.sol"
    }
]