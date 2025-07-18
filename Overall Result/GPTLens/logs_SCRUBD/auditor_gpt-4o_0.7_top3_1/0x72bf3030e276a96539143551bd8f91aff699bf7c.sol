[
    {
        "function_name": "Owned",
        "code": "function Owned() { owner = msg.sender; }",
        "vulnerability": "Constructor does not set visibility",
        "reason": "In Solidity versions prior to 0.4.22, constructors were defined with a function that has the same name as the contract. This function lacks the visibility specifier, which is defaulted to 'public', making it vulnerable to being called multiple times and potentially exploited in derived contracts if not carefully managed. However, since it is called during contract deployment, this is not a major issue here.",
        "file_name": "0x72bf3030e276a96539143551bd8f91aff699bf7c.sol"
    },
    {
        "function_name": "finalizeRound",
        "code": "function finalizeRound() onlyOwner onlyAfterDraw returns(address) { address roundAddress = address(currentRound); if (!currentRound.paidOut()) { currentRound.distributeWinnings(); currentRound.claimOwnerFee(curator); } else if (currentRound.balance > 0) { currentRound.withdraw(); } currentRound.transferOwnership(curator); delete currentRound; return roundAddress; }",
        "vulnerability": "Potential reentrancy during finalize",
        "reason": "The finalizeRound function interacts with an external contract (currentRound) by calling distributeWinnings, claimOwnerFee, and withdraw. If any of these functions are not properly secured against reentrancy, an attacker could exploit this by re-entering the contract during the external calls. This could potentially allow the attacker to drain funds or cause unintended behavior.",
        "file_name": "0x72bf3030e276a96539143551bd8f91aff699bf7c.sol"
    },
    {
        "function_name": "startRound",
        "code": "function startRound(bytes32 saltHash, bytes32 saltNHash) onlyCurator onlyWhenNoRound { if (this.balance > 0) { currentRound = LotteryRoundInterface( roundFactory.createRound.value(this.balance)(saltHash, saltNHash) ); } else { currentRound = LotteryRoundInterface(roundFactory.createRound(saltHash, saltNHash)); } }",
        "vulnerability": "Unprotected balance handling",
        "reason": "The function transfers the entire contract balance to the new round using createRound.value(this.balance). If there is a vulnerability in the createRound function or the round contract, an attacker could exploit it to redirect the funds. There's no check to ensure the funds are sent correctly or to handle failures gracefully, increasing the risk of loss.",
        "file_name": "0x72bf3030e276a96539143551bd8f91aff699bf7c.sol"
    }
]