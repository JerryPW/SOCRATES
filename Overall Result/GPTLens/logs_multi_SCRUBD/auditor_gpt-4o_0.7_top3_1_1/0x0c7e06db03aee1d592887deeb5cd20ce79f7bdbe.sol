[
    {
        "function_name": "voteForCandidate",
        "code": "function voteForCandidate(uint candidate) public payable inVotingPeriod { require(0 <= candidate && candidate < 2); require(msg.value > 0); require(!timeOver()); uint coefficient = currentCoefficient(); uint weightedVotes = msg.value * coefficient / 1000000; teams[candidate].fullVotes += msg.value; teams[candidate].weightedVotes += weightedVotes; voters[msg.sender].fullVotes[candidate] += msg.value; voters[msg.sender].weightedVotes[candidate] += weightedVotes; emit NewVotesFor(msg.sender, candidate, msg.value, coefficient); }",
        "vulnerability": "Function Overloading and Lack of Input Validation",
        "reason": "The function voteForCandidate is overloaded without any name differentiation. It uses the same name for different parameter sets, leading to potential misuse. In addition, the overloaded functions don't enforce proper validation for the referrers, allowing manipulation of the referrer system by repeatedly calling the overloaded functions with different referrers.",
        "file_name": "0x0c7e06db03aee1d592887deeb5cd20ce79f7bdbe.sol"
    },
    {
        "function_name": "sendReward",
        "code": "function sendReward(address payable to) public afterVotingPeriod { uint winnerVotes = voters[to].weightedVotes[winner]; uint loserVotes = voters[to].fullVotes[1-winner]; address payable referrer1 = voters[to].referrers[0]; address payable referrer2 = voters[to].referrers[1]; uint sum; if (winnerVotes > 0) { uint reward = challengePrize * winnerVotes / teams[winner].weightedVotes; to.transfer(reward + voters[to].fullVotes[winner]); if (referrer1 != address(0)) { sum = reward / 100 * 2; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = reward / 1000 * 2; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); } voters[to].fullVotes[winner] = 0; voters[to].weightedVotes[winner] = 0; emit RewardWasPaid(to, reward); } if (loserVotes > 0) { if (referrer1 != address(0)) { sum = loserVotes / 100 * 1; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = loserVotes / 1000 * 1; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); } } }",
        "vulnerability": "Reentrancy",
        "reason": "The sendReward function involves transferring Ether to the address 'to' before updating the voter's vote balances. This creates a risk of reentrancy attacks, where an attacker could re-enter the sendReward function before the balance updates occur, potentially leading to multiple reward claims.",
        "file_name": "0x0c7e06db03aee1d592887deeb5cd20ce79f7bdbe.sol"
    },
    {
        "function_name": "checkEndOfChallenge",
        "code": "function checkEndOfChallenge() public inVotingPeriod returns (bool) { if (!timeOver()) return false; if (teams[0].fullVotes > teams[1].fullVotes) winner = 0; else winner = 1; uint loser = 1 - winner; creator.transfer((teams[loser].fullVotes * creatorFee) / 1000); cryptoVersusPrize = (teams[loser].fullVotes * cryptoVersusFee) / 1000; challengePrize = teams[loser].fullVotes * (1000 - creatorFee - cryptoVersusFee) / 1000; isVotingPeriod = false; emit EndOfChallenge(winner, teams[winner].fullVotes, challengePrize); return true; }",
        "vulnerability": "Incorrect Fee Calculation",
        "reason": "The checkEndOfChallenge function uses integer division to calculate fees and prizes. This could lead to rounding errors, especially when the fullVotes count is low. Moreover, the function transfers Ether before checking whether the voting period is over, which could lead to incorrect or premature fee distribution.",
        "file_name": "0x0c7e06db03aee1d592887deeb5cd20ce79f7bdbe.sol"
    }
]