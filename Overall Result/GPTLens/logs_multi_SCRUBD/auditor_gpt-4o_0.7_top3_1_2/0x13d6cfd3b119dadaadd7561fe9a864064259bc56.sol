[
    {
        "function_name": "withdraw",
        "code": "function withdraw() isActivated() public payable { require(msg.value == 0, \"withdraw fee is 0 ether, please set the exact amount\"); uint256 uid = pIDxAddr_[msg.sender]; require(uid != 0, \"no invest\"); for(uint i = 0; i < player_[uid].planCount; i++) { if (player_[uid].plans[i].isClose) { continue; } SDDatasets.Plan plan = plan_[player_[uid].plans[i].planId]; uint256 blockNumber = block.number; bool bClose = false; if (plan.dayRange > 0) { uint256 endBlockNumber = player_[uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks); if (blockNumber > endBlockNumber){ blockNumber = endBlockNumber; bClose = true; } } uint256 amount = player_[uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[uid].plans[i].atBlock) / G_DayBlocks; address sender = msg.sender; sender.send(amount); player_[uid].plans[i].atBlock = block.number; player_[uid].plans[i].isClose = bClose; player_[uid].plans[i].payEth += amount; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses 'send' to transfer Ether which forwards only 2300 gas, but does not update the state before the transfer. This allows reentrancy attacks where an attacker could recursively call withdraw() and drain funds because the state update happens after the transfer.",
        "file_name": "0x13d6cfd3b119dadaadd7561fe9a864064259bc56.sol"
    },
    {
        "function_name": "constructor",
        "code": "constructor() public { plan_[1] = SDDatasets.Plan(240,60,1e16, 5e20); plan_[2] = SDDatasets.Plan(350,40,1e18, 1e21); plan_[3] = SDDatasets.Plan(470,35,1e19, 1e22); plan_[4] = SDDatasets.Plan(100,0,1e16, 1e22); plan_[5] = SDDatasets.Plan(900,12,1e18, 1e22); initUsers(); }",
        "vulnerability": "Hardcoded plan conditions",
        "reason": "Plans have hardcoded minimum and maximum investment limits that can be exploited if they are not properly set to realistic economic values, potentially leading to economic manipulation or denial of service if the values are not viable.",
        "file_name": "0x13d6cfd3b119dadaadd7561fe9a864064259bc56.sol"
    },
    {
        "function_name": "version1Invest",
        "code": "function version1Invest(address addr, uint256 eth, uint256 _affCode, uint256 _planId) isAdmin() public { require(activated_ == false, \"Only not active\"); require(_planId >= 1 && _planId <= ruleSum_, \"_planId error\"); uint256 uid = pIDxAddr_[addr]; if (uid == 0) { if (player_[_affCode].addr != address(0x0)) { register_(addr, _affCode); } else { register_(addr, 1000); } uid = G_NowUserId; } uint256 planCount = player_[uid].planCount; player_[uid].plans[planCount].planId = _planId; player_[uid].plans[planCount].startTime = now; player_[uid].plans[planCount].startBlock = block.number; player_[uid].plans[planCount].atBlock = block.number; player_[uid].plans[planCount].invested = eth; player_[uid].plans[planCount].payEth = 0; player_[uid].plans[planCount].isClose = false; player_[uid].planCount = player_[uid].planCount.add(1); G_AllEth = G_AllEth.add(eth); }",
        "vulnerability": "Unauthorized access",
        "reason": "The function does not check if 'eth' is within a valid range for the specified plan. An attacker with admin access could potentially add arbitrary amounts to the player's investment plans, bypassing economic constraints.",
        "file_name": "0x13d6cfd3b119dadaadd7561fe9a864064259bc56.sol"
    }
]