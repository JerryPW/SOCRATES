[
    {
        "function_name": "checkEndOfChallenge",
        "code": "function checkEndOfChallenge() public inVotingPeriod returns (bool) { if (!timeOver()) return false; if (teams[0].fullVotes > teams[1].fullVotes) winner = 0; else winner = 1; uint loser = 1 - winner; creator.transfer((teams[loser].fullVotes * creatorFee) / 1000); cryptoVersusPrize = (teams[loser].fullVotes * cryptoVersusFee) / 1000; challengePrize = teams[loser].fullVotes * (1000 - creatorFee - cryptoVersusFee) / 1000; isVotingPeriod = false; emit EndOfChallenge(winner, teams[winner].fullVotes, challengePrize); return true; }",
        "vulnerability": "Denial of service if transfer fails",
        "reason": "The function uses transfer() to send Ether to the creator, which forwards a fixed amount of gas. If the recipient is a contract that requires more gas than provided, the transfer will fail, causing the function to revert and the challenge to never end.",
        "file_name": "0x064c81842a12127759b85f3b2d261abcacc2bfb0.sol"
    },
    {
        "function_name": "sendReward",
        "code": "function sendReward(address payable to) public afterVotingPeriod { uint winnerVotes = voters[to].weightedVotes[winner]; uint loserVotes = voters[to].fullVotes[1-winner]; address payable referrer1 = voters[to].referrers[0]; address payable referrer2 = voters[to].referrers[1]; uint sum; if (winnerVotes > 0) { uint reward = challengePrize * winnerVotes / teams[winner].weightedVotes; to.transfer(reward + voters[to].fullVotes[winner]); if (referrer1 != address(0)) { sum = reward / 100 * 2; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = reward / 1000 * 2; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); } voters[to].fullVotes[winner] = 0; voters[to].weightedVotes[winner] = 0; emit RewardWasPaid(to, reward); } if (loserVotes > 0) { if (referrer1 != address(0)) { sum = loserVotes / 100 * 1; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = loserVotes / 1000 * 1; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); } voters[to].fullVotes[1-winner] = 0; voters[to].weightedVotes[1-winner] = 0; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers Ether to the voter's address before setting their vote counts to zero, allowing for potential reentrancy attacks. An attacker could exploit this by using a fallback function to call sendReward again before the votes are reset, effectively draining the contract.",
        "file_name": "0x064c81842a12127759b85f3b2d261abcacc2bfb0.sol"
    },
    {
        "function_name": "voteForCandidate",
        "code": "function voteForCandidate(uint candidate) public payable inVotingPeriod { require(0 <= candidate && candidate < 2); require(msg.value > 0); require(!timeOver()); uint coefficient = currentCoefficient(); uint weightedVotes = msg.value * coefficient / 1000000; teams[candidate].fullVotes += msg.value; teams[candidate].weightedVotes += weightedVotes; voters[msg.sender].fullVotes[candidate] += msg.value; voters[msg.sender].weightedVotes[candidate] += weightedVotes; emit NewVotesFor(msg.sender, candidate, msg.value, coefficient); }",
        "vulnerability": "Lack of input validation for msg.value",
        "reason": "The function does not validate the input value of msg.value beyond being greater than zero. This lack of detailed checks could allow an attacker to send extremely small amounts of Ether (like dust transactions) to manipulate the vote counts in their favor due to how weighted votes are calculated. Additionally, the contract may be susceptible to integer overflow/underflow in older Solidity versions without explicit checks.",
        "file_name": "0x064c81842a12127759b85f3b2d261abcacc2bfb0.sol"
    }
]