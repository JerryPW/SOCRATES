[
    {
        "function_name": "voteForCandidate(uint candidate, address payable referrer1)",
        "code": "function voteForCandidate(uint candidate, address payable referrer1) public payable inVotingPeriod { voters[msg.sender].referrers[0] = referrer1; voteForCandidate(candidate); }",
        "vulnerability": "Overloaded function selector collision",
        "reason": "The function 'voteForCandidate' is overloaded with different parameter sets but shares the same name. In Solidity, overloaded functions can cause selector collisions leading to unexpected behavior or making one of the functions unreachable. This could be exploited by an attacker to prevent the correct function from being called.",
        "file_name": "0x064c81842a12127759b85f3b2d261abcacc2bfb0.sol"
    },
    {
        "function_name": "checkEndOfChallenge",
        "code": "function checkEndOfChallenge() public inVotingPeriod returns (bool) { if (!timeOver()) return false; if (teams[0].fullVotes > teams[1].fullVotes) winner = 0; else winner = 1; uint loser = 1 - winner; creator.transfer((teams[loser].fullVotes * creatorFee) / 1000); cryptoVersusPrize = (teams[loser].fullVotes * cryptoVersusFee) / 1000; challengePrize = teams[loser].fullVotes * (1000 - creatorFee - cryptoVersusFee) / 1000; isVotingPeriod = false; emit EndOfChallenge(winner, teams[winner].fullVotes, challengePrize); return true; }",
        "vulnerability": "Reentrancy attack potential",
        "reason": "The 'checkEndOfChallenge' function transfers Ether to the 'creator' address before updating the state variable 'isVotingPeriod'. This opens up a potential reentrancy attack where the 'creator' could call back into the contract before the state is finalized, leading to inconsistent state or double payments.",
        "file_name": "0x064c81842a12127759b85f3b2d261abcacc2bfb0.sol"
    },
    {
        "function_name": "sendReward",
        "code": "function sendReward(address payable to) public afterVotingPeriod { uint winnerVotes = voters[to].weightedVotes[winner]; uint loserVotes = voters[to].fullVotes[1-winner]; address payable referrer1 = voters[to].referrers[0]; address payable referrer2 = voters[to].referrers[1]; uint sum; if (winnerVotes > 0) { uint reward = challengePrize * winnerVotes / teams[winner].weightedVotes; to.transfer(reward + voters[to].fullVotes[winner]); if (referrer1 != address(0)) { sum = reward / 100 * 2; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = reward / 1000 * 2; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); } voters[to].fullVotes[winner] = 0; voters[to].weightedVotes[winner] = 0; emit RewardWasPaid(to, reward); } if (loserVotes > 0) { if (referrer1 != address(0)) { sum = loserVotes / 100 * 1; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = loserVotes / 1000 * 1; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); } voters[to].fullVotes[1-winner] = 0; voters[to].weightedVotes[1-winner] = 0; } }",
        "vulnerability": "Potential overflow in reward calculations",
        "reason": "The reward calculation does not check for potential overflows when multiplying 'challengePrize' with 'winnerVotes' or 'teams[winner].weightedVotes'. This could lead to incorrect reward distribution, potentially allowing attackers to claim more rewards than intended due to integer overflow.",
        "file_name": "0x064c81842a12127759b85f3b2d261abcacc2bfb0.sol"
    }
]