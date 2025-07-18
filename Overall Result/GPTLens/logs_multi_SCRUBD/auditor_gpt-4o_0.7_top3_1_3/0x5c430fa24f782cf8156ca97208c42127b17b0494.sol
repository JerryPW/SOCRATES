[
    {
        "function_name": "HackDao",
        "code": "function HackDao() { if (owner>0) throw; owner = msg.sender; }",
        "vulnerability": "Constructor vulnerability",
        "reason": "The constructor uses an incorrect check for the owner initialization. Instead of 'if (owner > 0)', it should be checking whether 'owner' is already set to prevent re-initialization. This can lead to the contract being hijacked if re-deployed or in case of a failed deployment that allows re-initialization.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    },
    {
        "function_name": "__callback",
        "code": "function __callback(bytes32 myid, string result) { LogS('callback'); if (msg.sender != oraclize_cbAddress()) throw; if (parseInt(result) > 10) throw; if (results[myid] == 2 || results[myid] == 1) throw; LogB(myid); if (parseInt(result) > betslevel[myid]) { LogS('win'); LogI(betslevel[myid]); uint koef; if (betslevel[myid] == 1) koef = 109; if (betslevel[myid] == 2) koef = 122; if (betslevel[myid] == 3) koef = 140; if (betslevel[myid] == 4) koef = 163; if (betslevel[myid] == 5) koef = 196; if (betslevel[myid] == 6) koef = 245; if (betslevel[myid] == 7) koef = 326; if (betslevel[myid] == 8) koef = 490; if (betslevel[myid] == 9) koef = 980; results[myid]=2; if (!bets[myid].send(betsvalue[myid]*koef/100)) {LogS('bug! bet to winner was not sent!');} else { } } else { results[myid]=1; LogS('lose'); } delete bets[myid]; delete results[myid]; delete betslevel[myid]; delete betsvalue[myid]; }",
        "vulnerability": "Re-entrancy vulnerability",
        "reason": "The use of `.send()` to transfer ether can lead to re-entrancy issues if an attacker creates a contract that re-enters the `__callback` function. This could potentially allow the attacker to manipulate the state before it is properly cleaned up, especially since the state updates and cleanup occur after the send operation.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    },
    {
        "function_name": "ownerWithdrawl",
        "code": "function ownerWithdrawl(uint amount) onlyOwner { owner.send(amount); }",
        "vulnerability": "Unsafe ether transfer",
        "reason": "Using `send` to transfer ether does not propagate errors if the transfer fails, potentially leaving the contract's funds locked. Using `transfer` or ensuring proper handling of the `send` return value is safer, as these methods ensure the transaction either completes successfully or reverts.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    }
]