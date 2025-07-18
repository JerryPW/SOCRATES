[
    {
        "function_name": "HackDao",
        "code": "function HackDao() { if (owner>0) throw; owner = msg.sender; }",
        "vulnerability": "Constructor Re-entrancy",
        "reason": "The constructor checks if the owner variable is greater than 0 and throws an exception if true. However, if the contract is redeployed or if there is a re-entrancy attack during deployment, this condition might allow unauthorized access or incorrect behavior.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    },
    {
        "function_name": "game",
        "code": "function game (uint level) payable returns (bytes32) { if (msg.value <= 0) throw; if (level > 10) throw; if (level < 1) throw; if (msg.value > 10 ether) throw; uint random_number; bytes32 myid = oraclize_query(\"WolframAlpha\", \"random integer number between 1 and 10\"); bets[myid] = msg.sender; betsvalue[myid] = msg.value; betslevel[myid] = level; LogB(myid); return myid; }",
        "vulnerability": "Random Number Generation via Oraclize",
        "reason": "The game function attempts to generate a random number using Oraclize, which is not truly random and can be manipulated by miners or other external factors. This can allow attackers to predict or influence the outcome of the game, leading to unfair advantages.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    },
    {
        "function_name": "__callback",
        "code": "function __callback(bytes32 myid, string result) { LogS('callback'); if (msg.sender != oraclize_cbAddress()) throw; if (parseInt(result) > 10) throw; if (results[myid] == 2 || results[myid] == 1) throw; LogB(myid); if (parseInt(result) > betslevel[myid]) { LogS(\"win\"); LogI(betslevel[myid]); uint koef; if (betslevel[myid] == 1) koef = 109; if (betslevel[myid] == 2) koef = 122; if (betslevel[myid] == 3) koef = 140; if (betslevel[myid] == 4) koef = 163; if (betslevel[myid] == 5) koef = 196; if (betslevel[myid] == 6) koef = 245; if (betslevel[myid] == 7) koef = 326; if (betslevel[myid] == 8) koef = 490; if (betslevel[myid] == 9) koef = 980; results[myid]=2; if (!bets[myid].send(betsvalue[myid]*koef/100)) {LogS(\"bug! bet to winner was not sent!\");} else { } } else { results[myid]=1; LogS(\"lose\"); } delete bets[myid]; delete results[myid]; delete betslevel[myid]; delete betsvalue[myid]; }",
        "vulnerability": "Re-entrancy and Lack of Checks-Effects-Interactions",
        "reason": "The __callback function directly sends Ether to the user before updating the state. This can be exploited using re-entrancy attacks, where an attacker can recursively call the function to drain the contract before the state is updated. The function should follow the Checks-Effects-Interactions pattern to mitigate this risk.",
        "file_name": "0x5c430fa24f782cf8156ca97208c42127b17b0494.sol"
    }
]