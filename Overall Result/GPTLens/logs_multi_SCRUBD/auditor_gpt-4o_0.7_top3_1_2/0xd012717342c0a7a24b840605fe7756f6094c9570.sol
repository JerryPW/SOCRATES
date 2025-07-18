[
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() public payable { require(msg.value == 0, \"withdraw fee is 0 ether, please set the exact amount\"); uint256 uid = pIDxAddr_[msg.sender]; require(uid != 0, \"no invest\"); for(uint i = 0; i < player_[uid].planCount; i++) { if (player_[uid].plans[i].isClose) { continue; } SDDatasets.Plan plan = plan_[player_[uid].plans[i].planId]; uint256 blockNumber = block.number; bool bClose = false; if (plan.dayRange > 0) { uint256 endBlockNumber = player_[uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks); if (blockNumber > endBlockNumber){ blockNumber = endBlockNumber; bClose = true; } } uint256 amount = player_[uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[uid].plans[i].atBlock) / G_DayBlocks; address sender = msg.sender; sender.send(amount); player_[uid].plans[i].atBlock = block.number; player_[uid].plans[i].isClose = bClose; player_[uid].plans[i].payEth += amount; } }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The `withdraw` function uses `send` to transfer Ether, which does not revert on failure. If the transfer fails, it could lead to loss of Ether or inconsistent state as the transaction won't be reverted.",
        "file_name": "0xd012717342c0a7a24b840605fe7756f6094c9570.sol"
    },
    {
        "function_name": "invest",
        "code": "function invest(uint256 _affCode, uint256 _planId) isActivated() public payable { require(_planId >= 1 && _planId <= ruleSum_, \"_planId error\"); uint256 uid = pIDxAddr_[msg.sender]; if (uid == 0) { if (player_[_affCode].addr != address(0x0)) { register_(_affCode); } else { register_(1000); } uid = G_NowUserId; } require(msg.value >= plan_[_planId].min && msg.value <= plan_[_planId].max, \"invest amount error, please set the exact amount\"); uint256 planCount = player_[uid].planCount; player_[uid].plans[planCount].planId = _planId; player_[uid].plans[planCount].startTime = now; player_[uid].plans[planCount].startBlock = block.number; player_[uid].plans[planCount].atBlock = block.number; player_[uid].plans[planCount].invested = msg.value; player_[uid].plans[planCount].payEth = 0; player_[uid].plans[planCount].isClose = false; player_[uid].planCount = player_[uid].planCount.add(1); G_AllEth = G_AllEth.add(msg.value); if (msg.value > 1000000000) { distributeRef(msg.value, player_[uid].laff); uint256 devFee = (msg.value.mul(2)).div(100); devAddr_.transfer(devFee); uint256 partnerFee = (msg.value.mul(2)).div(100); partnerAddr_.transfer(partnerFee); } }",
        "vulnerability": "Reentrancy",
        "reason": "The `invest` function transfers Ether to other addresses without using a checks-effects-interactions pattern, which allows for potential reentrancy attacks if any of the called addresses are malicious contracts that can reenter `invest` or other functions.",
        "file_name": "0xd012717342c0a7a24b840605fe7756f6094c9570.sol"
    },
    {
        "function_name": "distributeRef",
        "code": "function distributeRef(uint256 _eth, uint256 _affID) private{ uint256 _allaff = (_eth.mul(8)).div(100); uint256 _affID1 = _affID; uint256 _affID2 = player_[_affID1].laff; uint256 _affID3 = player_[_affID2].laff; uint256 _aff = 0; if (_affID1 != 0) { _aff = (_eth.mul(5)).div(100); _allaff = _allaff.sub(_aff); player_[_affID1].aff = _aff.add(player_[_affID1].aff); player_[_affID1].addr.transfer(_aff); } if (_affID2 != 0) { _aff = (_eth.mul(2)).div(100); _allaff = _allaff.sub(_aff); player_[_affID2].aff = _aff.add(player_[_affID2].aff); player_[_affID2].addr.transfer(_aff); } if (_affID3 != 0) { _aff = (_eth.mul(1)).div(100); _allaff = _allaff.sub(_aff); player_[_affID3].aff = _aff.add(player_[_affID3].aff); player_[_affID3].addr.transfer(_aff); } if(_allaff > 0 ){ affiAddr_.transfer(_allaff); } }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The `distributeRef` function uses `transfer` to send Ether, which can fail if the recipient is a contract that does not implement a fallback function or has a higher gas requirement, leading to potential failures in distributing referral rewards.",
        "file_name": "0xd012717342c0a7a24b840605fe7756f6094c9570.sol"
    }
]