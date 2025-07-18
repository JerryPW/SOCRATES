[
    {
        "function_name": "game",
        "code": "function game (uint level) payable returns (bytes32) { if (msg.value <= 0) throw; if (level > 10) throw; if (level < 1) throw; if (msg.value > 10 ether) throw; uint random_number; bytes32 myid = oraclize_query(\"WolframAlpha\", \"random integer number between 1 and 10\"); bets[myid] = msg.sender; betsvalue[myid] = msg.value; betslevel[myid] = level; LogB(myid); return myid; }",
        "vulnerability": "Unrestricted Bet Value",
        "reason": "Although the function checks if the msg.value is greater than 10 ether, it does not restrict the minimum bet value effectively, allowing the game to be exploited with bets of no value. Also, using 'throw' for conditions can lead to unexpected reverts without proper error messages.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    },
    {
        "function_name": "__callback",
        "code": "function __callback(bytes32 myid, string result) { LogS('callback'); if (msg.sender != oraclize_cbAddress()) throw; if (parseInt(result) > 10) throw; if (results[myid] == 2 || results[myid] == 1) throw; LogB(myid); if (parseInt(result) > betslevel[myid]) { LogS(\"win\"); LogI(betslevel[myid]); uint koef; if (betslevel[myid] == 1) koef = 109; if (betslevel[myid] == 2) koef = 122; if (betslevel[myid] == 3) koef = 140; if (betslevel[myid] == 4) koef = 163; if (betslevel[myid] == 5) koef = 196; if (betslevel[myid] == 6) koef = 245; if (betslevel[myid] == 7) koef = 326; if (betslevel[myid] == 8) koef = 490; if (betslevel[myid] == 9) koef = 980; results[myid]=2; if (!bets[myid].send(betsvalue[myid]*koef/100)) {LogS(\"bug! bet to winner was not sent!\");} else { } } else { results[myid]=1; LogS(\"lose\"); } delete bets[myid]; delete results[myid]; delete betslevel[myid]; delete betsvalue[myid]; }",
        "vulnerability": "Reentrancy",
        "reason": "The use of '.send()' for transferring Ether is vulnerable to reentrancy attacks, as control is transferred to the external address without updating the state beforehand. An attacker could potentially re-enter the function and manipulate the state, causing unexpected behavior or draining funds.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    },
    {
        "function_name": "ownerWithdrawl",
        "code": "function ownerWithdrawl(uint amount) onlyOwner { owner.send(amount); }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The use of 'send' to transfer Ether to the owner is unsafe because it does not handle errors effectively. If the transfer fails, the function does not revert, potentially leaving the contract in an inconsistent state or causing loss of funds.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    }
]