[
    {
        "function_name": "checkEndOfChallenge",
        "code": "function checkEndOfChallenge() public inVotingPeriod returns (bool) { if (!timeOver()) return false; if (teams[0].fullVotes > teams[1].fullVotes) winner = 0; else winner = 1; uint loser = 1 - winner; creator.transfer((teams[loser].fullVotes * creatorFee) / 1000); cryptoVersusPrize = (teams[loser].fullVotes * cryptoVersusFee) / 1000; challengePrize = teams[loser].fullVotes * (1000 - creatorFee - cryptoVersusFee) / 1000; isVotingPeriod = false; emit EndOfChallenge(winner, teams[winner].fullVotes, challengePrize); return true; }",
        "vulnerability": "Potential Reentrancy Attack",
        "reason": "The function `checkEndOfChallenge` transfers Ether to the `creator` before updating the state variable `isVotingPeriod`. This could allow a potential reentrancy attack where the `creator` could re-enter the contract before the state is updated, leading to inconsistent state changes.",
        "file_name": "0x0c7e06db03aee1d592887deeb5cd20ce79f7bdbe.sol"
    },
    {
        "function_name": "sendReward",
        "code": "function sendReward(address payable to) public afterVotingPeriod { uint winnerVotes = voters[to].weightedVotes[winner]; uint loserVotes = voters[to].fullVotes[1-winner]; address payable referrer1 = voters[to].referrers[0]; address payable referrer2 = voters[to].referrers[1]; uint sum; if (winnerVotes > 0) { uint reward = challengePrize * winnerVotes / teams[winner].weightedVotes; to.transfer(reward + voters[to].fullVotes[winner]); if (referrer1 != address(0)) { sum = reward / 100 * 2; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = reward / 1000 * 2; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); } voters[to].fullVotes[winner] = 0; voters[to].weightedVotes[winner] = 0; emit RewardWasPaid(to, reward); } if (loserVotes > 0) { if (referrer1 != address(0)) { sum = loserVotes / 100 * 1; forwarder.forward.value(sum)(referrer1, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer1, sum); } if (referrer2 != address(0)) { sum = loserVotes / 1000 * 1; forwarder.forward.value(sum)(referrer2, to); cryptoVersusPrize -= sum; emit ReferrerRewardWasPaid(to, referrer2, sum); }}}",
        "vulnerability": "Potential Reentrancy Attack",
        "reason": "The function `sendReward` performs Ether transfers to the voter `to` and referrers before updating the voter's state variables. This could lead to a reentrancy attack where the recipient can re-enter the contract and potentially claim rewards multiple times before the state is updated.",
        "file_name": "0x0c7e06db03aee1d592887deeb5cd20ce79f7bdbe.sol"
    },
    {
        "function_name": "forward",
        "code": "function forward(address payable to, address sender) public payable { to.transfer(msg.value); sendersHash[to].push(sender); sumsHash[to].push(msg.value); }",
        "vulnerability": "Potential Reentrancy Attack",
        "reason": "The `forward` function in the `VotingChallengeForwarder` contract transfers Ether to an address before updating the `sendersHash` and `sumsHash` mappings. This could allow a recipient to re-enter the contract and potentially manipulate the mappings or cause other unintended effects before the state is updated.",
        "file_name": "0x0c7e06db03aee1d592887deeb5cd20ce79f7bdbe.sol"
    }
]