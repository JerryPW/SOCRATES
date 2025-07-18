[
    {
        "function_name": "HackDao",
        "code": "function HackDao() { if (owner>0) throw; owner = msg.sender; }",
        "vulnerability": "Uninitialized owner variable",
        "reason": "The constructor checks if the owner is greater than 0, which is always false for an uninitialized address. This makes the check useless, allowing the contract to be reinitialized by any address, leading to potential takeover by an attacker.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    },
    {
        "function_name": "ownerWithdrawl",
        "code": "function ownerWithdrawl(uint amount) onlyOwner { owner.send(amount); }",
        "vulnerability": "Unsafe usage of send()",
        "reason": "The send() function is used without checking if it succeeded. This can lead to loss of funds if the transaction fails, as there is no way to confirm success or handle a failed transaction. It is recommended to use transfer() or check for success when using send().",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    },
    {
        "function_name": "__callback",
        "code": "function __callback(bytes32 myid, string result) { LogS('callback'); if (msg.sender != oraclize_cbAddress()) throw; if (parseInt(result) > 10) throw; if (results[myid] == 2 || results[myid] == 1) throw; LogB(myid); if (parseInt(result) > betslevel[myid]) { LogS('win'); LogI(betslevel[myid]); uint koef; if (betslevel[myid] == 1) koef = 109; if (betslevel[myid] == 2) koef = 122; if (betslevel[myid] == 3) koef = 140; if (betslevel[myid] == 4) koef = 163; if (betslevel[myid] == 5) koef = 196; if (betslevel[myid] == 6) koef = 245; if (betslevel[myid] == 7) koef = 326; if (betslevel[myid] == 8) koef = 490; if (betslevel[myid] == 9) koef = 980; results[myid]=2; if (!bets[myid].send(betsvalue[myid]*koef/100)) {LogS('bug! bet to winner was not sent!');} else { } } else { results[myid]=1; LogS('lose'); } delete bets[myid]; delete results[myid]; delete betslevel[myid]; delete betsvalue[myid]; }",
        "vulnerability": "Race condition due to external call",
        "reason": "The function makes an external call using send() and immediately deletes the bet information. This can lead to a race condition where an attacker could potentially manipulate or re-enter the contract before the state is updated, leading to double spending or other unexpected behavior.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    }
]