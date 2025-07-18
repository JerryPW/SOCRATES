[
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() public payable { require(msg.value == 0, \"withdraw fee is 0 ether, please set the exact amount\"); uint256 uid = pIDxAddr_[msg.sender]; require(uid != 0, \"no invest\"); for(uint i = 0; i < player_[uid].planCount; i++) { if (player_[uid].plans[i].isClose) { continue; } SDDatasets.Plan plan = plan_[player_[uid].plans[i].planId]; uint256 blockNumber = block.number; bool bClose = false; if (plan.dayRange > 0) { uint256 endBlockNumber = player_[uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks); if (blockNumber > endBlockNumber){ blockNumber = endBlockNumber; bClose = true; } } uint256 amount = player_[uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[uid].plans[i].atBlock) / G_DayBlocks; address sender = msg.sender; sender.send(amount); player_[uid].plans[i].atBlock = block.number; player_[uid].plans[i].isClose = bClose; player_[uid].plans[i].payEth += amount; } }",
        "vulnerability": "Use of 'send' for Ether transfer",
        "reason": "The 'send' method is used to transfer Ether, which only forwards 2300 gas, possibly causing the transaction to fail if the recipient requires more gas. Additionally, 'send' doesn't revert the entire transaction on failure, which could lead to inconsistent state changes.",
        "file_name": "0x465cd6299775dc459a23c80997d2664656be9780.sol"
    },
    {
        "function_name": "version1Invest",
        "code": "function version1Invest(address addr, uint256 eth, uint256 _affCode, uint256 _planId) isAdmin() public payable { require(activated_ == false, \"Only not active\"); require(_planId >= 1 && _planId <= ruleSum_, \"_planId error\"); uint256 uid = pIDxAddr_[addr]; if (uid == 0) { if (player_[_affCode].addr != address(0x0)) { register_(addr, _affCode); } else { register_(addr, 1000); } uid = G_NowUserId; } uint256 planCount = player_[uid].planCount; player_[uid].plans[planCount].planId = _planId; player_[uid].plans[planCount].startTime = now; player_[uid].plans[planCount].startBlock = block.number; player_[uid].plans[planCount].atBlock = block.number; player_[uid].plans[planCount].invested = eth; player_[uid].plans[planCount].payEth = 0; player_[uid].plans[planCount].isClose = false; player_[uid].planCount = player_[uid].planCount.add(1); G_AllEth = G_AllEth.add(eth); }",
        "vulnerability": "Lack of input validation for 'eth'",
        "reason": "The function accepts an 'eth' parameter but does not validate it against the minimum and maximum allowed investment amounts as defined in the 'plan_' mapping. This could allow an attacker to bypass investment constraints.",
        "file_name": "0x465cd6299775dc459a23c80997d2664656be9780.sol"
    },
    {
        "function_name": "distributeRef",
        "code": "function distributeRef(uint256 _eth, uint256 _affID) private{ uint256 _allaff = (_eth.mul(8)).div(100); uint256 _affID1 = _affID; uint256 _affID2 = player_[_affID1].laff; uint256 _affID3 = player_[_affID2].laff; uint256 _aff = 0; if (_affID1 != 0) { _aff = (_eth.mul(5)).div(100); _allaff = _allaff.sub(_aff); player_[_affID1].aff = _aff.add(player_[_affID1].aff); player_[_affID1].addr.transfer(_aff); } if (_affID2 != 0) { _aff = (_eth.mul(2)).div(100); _allaff = _allaff.sub(_aff); player_[_affID2].aff = _aff.add(player_[_affID2].aff); player_[_affID2].addr.transfer(_aff); } if (_affID3 != 0) { _aff = (_eth.mul(1)).div(100); _allaff = _allaff.sub(_aff); player_[_affID3].aff = _aff.add(player_[_affID3].aff); player_[_affID3].addr.transfer(_aff); } if(_allaff > 0 ){ affiAddr_.transfer(_allaff); } }",
        "vulnerability": "Reentrancy risk during Ether transfer",
        "reason": "The function makes multiple Ether transfers using 'transfer', which forwards 2300 gas. However, if the recipient address is a contract, it may still perform a reentrant call despite the gas limit, potentially leading to reentrancy vulnerabilities. Additionally, multiple state changes occur after these transfers, which should ideally precede the transfers to minimize reentrancy risks.",
        "file_name": "0x465cd6299775dc459a23c80997d2664656be9780.sol"
    }
]