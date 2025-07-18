[
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() public payable { require(msg.value == 0, \"withdraw fee is 0 ether, please set the exact amount\"); uint256 uid = pIDxAddr_[msg.sender]; require(uid != 0, \"no invest\"); for(uint i = 0; i < player_[uid].planCount; i++) { if (player_[uid].plans[i].isClose) { continue; } SDDatasets.Plan plan = plan_[player_[uid].plans[i].planId]; uint256 blockNumber = block.number; bool bClose = false; if (plan.dayRange > 0) { uint256 endBlockNumber = player_[uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks); if (blockNumber > endBlockNumber){ blockNumber = endBlockNumber; bClose = true; } } uint256 amount = player_[uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[uid].plans[i].atBlock) / G_DayBlocks; address sender = msg.sender; sender.send(amount); player_[uid].plans[i].atBlock = block.number; player_[uid].plans[i].isClose = bClose; player_[uid].plans[i].payEth += amount; } }",
        "vulnerability": "Usage of send function",
        "reason": "The `send` function is used to transfer Ether, which only forwards 2300 gas. If the receiver is a contract that requires more than 2300 gas to process the transaction, the transfer will fail. This could lead to failures in withdrawing funds and potential loss of Ether. It's recommended to use `transfer` or `call` with proper gas stipend.",
        "file_name": "0x465cd6299775dc459a23c80997d2664656be9780.sol"
    },
    {
        "function_name": "distributeRef",
        "code": "function distributeRef(uint256 _eth, uint256 _affID) private{ uint256 _allaff = (_eth.mul(8)).div(100); uint256 _affID1 = _affID; uint256 _affID2 = player_[_affID1].laff; uint256 _affID3 = player_[_affID2].laff; uint256 _aff = 0; if (_affID1 != 0) { _aff = (_eth.mul(5)).div(100); _allaff = _allaff.sub(_aff); player_[_affID1].aff = _aff.add(player_[_affID1].aff); player_[_affID1].addr.transfer(_aff); } if (_affID2 != 0) { _aff = (_eth.mul(2)).div(100); _allaff = _allaff.sub(_aff); player_[_affID2].aff = _aff.add(player_[_affID2].aff); player_[_affID2].addr.transfer(_aff); } if (_affID3 != 0) { _aff = (_eth.mul(1)).div(100); _allaff = _allaff.sub(_aff); player_[_affID3].aff = _aff.add(player_[_affID3].aff); player_[_affID3].addr.transfer(_aff); } if(_allaff > 0 ){ affiAddr_.transfer(_allaff); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `distributeRef` function transfers Ether to multiple addresses without proper reentrancy protection. If any of the recipient addresses is a contract, it could reenter into the contract and manipulate state variables. This function should use a pattern like checks-effects-interactions to prevent reentrancy attacks or employ a reentrancy guard.",
        "file_name": "0x465cd6299775dc459a23c80997d2664656be9780.sol"
    },
    {
        "function_name": "version1Invest",
        "code": "function version1Invest(address addr, uint256 eth, uint256 _affCode, uint256 _planId) isAdmin() public payable { require(activated_ == false, \"Only not active\"); require(_planId >= 1 && _planId <= ruleSum_, \"_planId error\"); uint256 uid = pIDxAddr_[addr]; if (uid == 0) { if (player_[_affCode].addr != address(0x0)) { register_(addr, _affCode); } else { register_(addr, 1000); } uid = G_NowUserId; } uint256 planCount = player_[uid].planCount; player_[uid].plans[planCount].planId = _planId; player_[uid].plans[planCount].startTime = now; player_[uid].plans[planCount].startBlock = block.number; player_[uid].plans[planCount].atBlock = block.number; player_[uid].plans[planCount].invested = eth; player_[uid].plans[planCount].payEth = 0; player_[uid].plans[planCount].isClose = false; player_[uid].planCount = player_[uid].planCount.add(1); G_AllEth = G_AllEth.add(eth); }",
        "vulnerability": "Lack of input validation for 'eth' parameter",
        "reason": "The `version1Invest` function allows the `eth` parameter to be set arbitrarily without checking if it matches the actual Ether sent in the transaction (`msg.value`). This could lead to inconsistencies in state and potentially allow attackers to manipulate the contract's state without sending the required Ether amount. It's crucial to ensure that `eth` matches `msg.value` to maintain the integrity of the contract.",
        "file_name": "0x465cd6299775dc459a23c80997d2664656be9780.sol"
    }
]