[
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() public payable { require(msg.value == 0, \"withdraw fee is 0 ether, please set the exact amount\"); uint256 uid = pIDxAddr_[msg.sender]; require(uid != 0, \"no invest\"); for(uint i = 0; i < player_[uid].planCount; i++) { if (player_[uid].plans[i].isClose) { continue; } SDDatasets.Plan plan = plan_[player_[uid].plans[i].planId]; uint256 blockNumber = block.number; bool bClose = false; if (plan.dayRange > 0) { uint256 endBlockNumber = player_[uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks); if (blockNumber > endBlockNumber){ blockNumber = endBlockNumber; bClose = true; } } uint256 amount = player_[uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[uid].plans[i].atBlock) / G_DayBlocks; address sender = msg.sender; sender.send(amount); player_[uid].plans[i].atBlock = block.number; player_[uid].plans[i].isClose = bClose; player_[uid].plans[i].payEth += amount; } }",
        "vulnerability": "Unsafe use of send function",
        "reason": "The withdraw function uses the send method to transfer funds to the msg.sender, which only forwards 2300 gas and does not revert if the transfer fails. This can lead to a loss of funds if the transaction fails and creates a potential attack vector if an attacker intentionally blocks withdrawals by manipulating gas usage.",
        "file_name": "0xd012717342c0a7a24b840605fe7756f6094c9570.sol"
    },
    {
        "function_name": "register_",
        "code": "function register_(uint256 _affCode) private{ G_NowUserId = G_NowUserId.add(1); address _addr = msg.sender; pIDxAddr_[_addr] = G_NowUserId; player_[G_NowUserId].addr = _addr; player_[G_NowUserId].laff = _affCode; player_[G_NowUserId].planCount = 0; uint256 _affID1 = _affCode; uint256 _affID2 = player_[_affID1].laff; uint256 _affID3 = player_[_affID2].laff; uint256 _affID4 = player_[_affID3].laff; player_[_affID1].aff1sum = player_[_affID1].aff1sum.add(1); player_[_affID2].aff2sum = player_[_affID2].aff2sum.add(1); player_[_affID3].aff3sum = player_[_affID3].aff3sum.add(1); player_[_affID4].aff4sum = player_[_affID4].aff4sum.add(1); }",
        "vulnerability": "Lack of validation for affiliate codes",
        "reason": "The register_ function does not validate the provided _affCode, leading to potential manipulation by users to create fake referral chains and gain unfair referral rewards. This can lead to skewed referral data and financial losses for the platform due to fraudulent rewards.",
        "file_name": "0xd012717342c0a7a24b840605fe7756f6094c9570.sol"
    },
    {
        "function_name": "distributeRef",
        "code": "function distributeRef(uint256 _eth, uint256 _affID) private{ uint256 _allaff = (_eth.mul(8)).div(100); uint256 _affID1 = _affID; uint256 _affID2 = player_[_affID1].laff; uint256 _affID3 = player_[_affID2].laff; uint256 _aff = 0; if (_affID1 != 0) { _aff = (_eth.mul(5)).div(100); _allaff = _allaff.sub(_aff); player_[_affID1].aff = _aff.add(player_[_affID1].aff); player_[_affID1].addr.transfer(_aff); } if (_affID2 != 0) { _aff = (_eth.mul(2)).div(100); _allaff = _allaff.sub(_aff); player_[_affID2].aff = _aff.add(player_[_affID2].aff); player_[_affID2].addr.transfer(_aff); } if (_affID3 != 0) { _aff = (_eth.mul(1)).div(100); _allaff = _allaff.sub(_aff); player_[_affID3].aff = _aff.add(player_[_affID3].aff); player_[_affID3].addr.transfer(_aff); } if(_allaff > 0 ){ affiAddr_.transfer(_allaff); } }",
        "vulnerability": "Unsafe use of transfer function",
        "reason": "The distributeRef function uses transfer to send funds to affiliate addresses, which may fail if the receiving address's fallback function requires more than 2300 gas. Failing to handle this properly can lead to funds being stuck in the contract, affecting the distribution of referral rewards and potentially causing inconsistencies in the affiliate system.",
        "file_name": "0xd012717342c0a7a24b840605fe7756f6094c9570.sol"
    }
]