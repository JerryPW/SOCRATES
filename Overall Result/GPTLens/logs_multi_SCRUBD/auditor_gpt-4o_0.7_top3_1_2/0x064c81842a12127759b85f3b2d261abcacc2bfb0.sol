[
    {
        "function_name": "voteForCandidate",
        "code": "function voteForCandidate(uint candidate) public payable inVotingPeriod { require(0 <= candidate && candidate < 2); require(msg.value > 0); require(!timeOver()); uint coefficient = currentCoefficient(); uint weightedVotes = msg.value * coefficient / 1000000; teams[candidate].fullVotes += msg.value; teams[candidate].weightedVotes += weightedVotes; voters[msg.sender].fullVotes[candidate] += msg.value; voters[msg.sender].weightedVotes[candidate] += weightedVotes; emit NewVotesFor(msg.sender, candidate, msg.value, coefficient); }",
        "vulnerability": "Lack of input validation allows repeated voting",
        "reason": "The function does not restrict the number of times a voter can vote for a candidate. An attacker can repeatedly call this function to disproportionately increase their influence over the voting outcome, as there is no check to ensure a single vote per voter.",
        "file_name": "0x064c81842a12127759b85f3b2d261abcacc2bfb0.sol"
    },
    {
        "function_name": "checkEndOfChallenge",
        "code": "function checkEndOfChallenge() public inVotingPeriod returns (bool) { if (!timeOver()) return false; if (teams[0].fullVotes > teams[1].fullVotes) winner = 0; else winner = 1; uint loser = 1 - winner; creator.transfer((teams[loser].fullVotes * creatorFee) / 1000); cryptoVersusPrize = (teams[loser].fullVotes * cryptoVersusFee) / 1000; challengePrize = teams[loser].fullVotes * (1000 - creatorFee - cryptoVersusFee) / 1000; isVotingPeriod = false; emit EndOfChallenge(winner, teams[winner].fullVotes, challengePrize); return true; }",
        "vulnerability": "Potential to lock funds due to lack of reentrancy guard",
        "reason": "The function `checkEndOfChallenge` transfers funds directly to the creator without a reentrancy guard. If the creator's address is a contract, it could perform a reentrancy attack, potentially disrupting the proper completion of the function and locking funds.",
        "file_name": "0x064c81842a12127759b85f3b2d261abcacc2bfb0.sol"
    },
    {
        "function_name": "sendReward",
        "code": "function sendReward(address payable to) public afterVotingPeriod { uint winnerVotes = voters[to].weightedVotes[winner]; uint loserVotes = voters[to].fullVotes[1-winner]; address payable referrer1 = voters[to].referrers[0]; address payable referrer2 = voters[to].referrers[1]; uint sum; if (winnerVotes > 0) { uint reward = challengePrize * winnerVotes / teams[winner].weightedVotes; to.transfer(reward + voters[to].fullVotes[winner]); if (referrer1 != address(0)) { sum = reward / 100 * 2; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = reward / 1000 * 2; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); } voters[to].fullVotes[winner] = 0; voters[to].weightedVotes[winner] = 0; emit RewardWasPaid(to, reward); } if (loserVotes > 0) { if (referrer1 != address(0)) { sum = loserVotes / 100 * 1; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = loserVotes / 1000 * 1; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); } voters[to].fullVotes[1-winner] = 0; voters[to].weightedVotes[1-winner] = 0; } }",
        "vulnerability": "Reentrancy vulnerability due to external call",
        "reason": "The `sendReward` function makes external calls to `to.transfer` and `forwarder.forward` without a reentrancy guard. An attacker could exploit this vulnerability by reentering the contract through a fallback function, causing unexpected behavior and potentially draining funds.",
        "file_name": "0x064c81842a12127759b85f3b2d261abcacc2bfb0.sol"
    }
]