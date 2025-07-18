[
    {
        "function_name": "checkEndOfChallenge",
        "code": "function checkEndOfChallenge() public inVotingPeriod returns (bool) { if (!timeOver()) return false; if (teams[0].fullVotes > teams[1].fullVotes) winner = 0; else winner = 1; uint loser = 1 - winner; creator.transfer((teams[loser].fullVotes * creatorFee) / 1000); cryptoVersusPrize = (teams[loser].fullVotes * cryptoVersusFee) / 1000; challengePrize = teams[loser].fullVotes * (1000 - creatorFee - cryptoVersusFee) / 1000; isVotingPeriod = false; emit EndOfChallenge(winner, teams[winner].fullVotes, challengePrize); return true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function 'checkEndOfChallenge' transfers funds to the 'creator' before updating the state variable 'isVotingPeriod'. This can be exploited by attackers to repeatedly call the function, potentially draining funds.",
        "file_name": "0x0c7e06db03aee1d592887deeb5cd20ce79f7bdbe.sol"
    },
    {
        "function_name": "sendReward",
        "code": "function sendReward(address payable to) public afterVotingPeriod { uint winnerVotes = voters[to].weightedVotes[winner]; uint loserVotes = voters[to].fullVotes[1-winner]; address payable referrer1 = voters[to].referrers[0]; address payable referrer2 = voters[to].referrers[1]; uint sum; if (winnerVotes > 0) { uint reward = challengePrize * winnerVotes / teams[winner].weightedVotes; to.transfer(reward + voters[to].fullVotes[winner]); if (referrer1 != address(0)) { sum = reward / 100 * 2; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = reward / 1000 * 2; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); } voters[to].fullVotes[winner] = 0; voters[to].weightedVotes[winner] = 0; emit RewardWasPaid(to, reward); } if (loserVotes > 0) { if (referrer1 != address(0)) { sum = loserVotes / 100 * 1; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = loserVotes / 1000 * 1; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); }}}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function 'sendReward' transfers funds to 'to' before updating the voter's state. This creates a window for reentrancy attacks, where the recipient can call back into the contract and manipulate its state in an unintended manner.",
        "file_name": "0x0c7e06db03aee1d592887deeb5cd20ce79f7bdbe.sol"
    },
    {
        "function_name": "voteForCandidate",
        "code": "function voteForCandidate(uint candidate) public payable inVotingPeriod { require(0 <= candidate && candidate < 2); require(msg.value > 0); require(!timeOver()); uint coefficient = currentCoefficient(); uint weightedVotes = msg.value * coefficient / 1000000; teams[candidate].fullVotes += msg.value; teams[candidate].weightedVotes += weightedVotes; voters[msg.sender].fullVotes[candidate] += msg.value; voters[msg.sender].weightedVotes[candidate] += weightedVotes; emit NewVotesFor(msg.sender, candidate, msg.value, coefficient); }",
        "vulnerability": "Lack of input validation for voting",
        "reason": "The function 'voteForCandidate' does not check if the candidate index is valid or if the voting period is over, which could lead to invalid votes being cast or the function being called after the voting period, resulting in incorrect accounting of votes.",
        "file_name": "0x0c7e06db03aee1d592887deeb5cd20ce79f7bdbe.sol"
    }
]