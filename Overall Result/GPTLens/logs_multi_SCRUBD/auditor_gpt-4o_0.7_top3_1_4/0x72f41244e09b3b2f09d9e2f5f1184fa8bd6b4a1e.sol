[
    {
        "function_name": "withdraw",
        "code": "function withdraw() private { require(msg.value == 0, \"withdraw fee is 0 ether, please set the exact amount\"); uint256 uid = pIDxAddr_[rId_][msg.sender]; require(uid != 0, \"no invest\"); for(uint i = 0; i < player_[rId_][uid].planCount; i++) { if (player_[rId_][uid].plans[i].isClose) { continue; } ESDatasets.Plan plan = plan_[player_[rId_][uid].plans[i].planId]; uint256 blockNumber = block.number; bool bClose = false; if (plan.dayRange > 0) { uint256 endBlockNumber = player_[rId_][uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks); if (blockNumber > endBlockNumber){ blockNumber = endBlockNumber; bClose = true; } } uint256 amount = player_[rId_][uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[rId_][uid].plans[i].atBlock) / G_DayBlocks; address sender = msg.sender; sender.send(amount); player_[rId_][uid].plans[i].atBlock = block.number; player_[rId_][uid].plans[i].isClose = bClose; player_[rId_][uid].plans[i].payEth += amount; } if (this.balance < 100000000000000) { rId_ = rId_.add(1); round_[rId_].startTime = now; } }",
        "vulnerability": "Unsafe Ether Transfer with send",
        "reason": "The withdrawal process uses the send function, which can fail without reverting the transaction, potentially allowing Ether to be lost or stuck in the contract if the receiver is a contract with a fallback function that uses more than 2300 gas. This can be exploited by attackers to prevent legitimate users from receiving their funds.",
        "file_name": "0x72f41244e09b3b2f09d9e2f5f1184fa8bd6b4a1e.sol"
    },
    {
        "function_name": "invest",
        "code": "function invest() private { uint256 _planId = bytesToUint(msg.data); if (_planId<1 || _planId > ruleSum_) { _planId = 1; } uint256 uid = pIDxAddr_[rId_][msg.sender]; if (uid == 0) { register_(msg.sender); uid = round_[rId_].nowUserId; } uint256 planCount = player_[rId_][uid].planCount; player_[rId_][uid].plans[planCount].planId = _planId; player_[rId_][uid].plans[planCount].startTime = now; player_[rId_][uid].plans[planCount].startBlock = block.number; player_[rId_][uid].plans[planCount].atBlock = block.number; player_[rId_][uid].plans[planCount].invested = msg.value; player_[rId_][uid].plans[planCount].payEth = 0; player_[rId_][uid].plans[planCount].isClose = false; player_[rId_][uid].planCount = player_[rId_][uid].planCount.add(1); round_[rId_].ethSum = round_[rId_].ethSum.add(msg.value); if (msg.value > 1000000000) { uint256 promoFee = (msg.value.mul(5)).div(100); promoAddr_.transfer(promoFee); } }",
        "vulnerability": "Lack of Validation for Incoming Plan ID",
        "reason": "The plan ID is extracted from msg.data, but there is no validation to ensure that the data is correctly formatted or intended as a valid plan ID. This could lead to incorrect plan allocations or unexpected behavior if arbitrary data is passed, potentially allowing attackers to manipulate or exploit the contract's logic.",
        "file_name": "0x72f41244e09b3b2f09d9e2f5f1184fa8bd6b4a1e.sol"
    },
    {
        "function_name": "register_",
        "code": "function register_(address addr) private{ round_[rId_].nowUserId = round_[rId_].nowUserId.add(1); address _addr = addr; pIDxAddr_[rId_][_addr] = round_[rId_].nowUserId; player_[rId_][round_[rId_].nowUserId].addr = _addr; player_[rId_][round_[rId_].nowUserId].planCount = 0; }",
        "vulnerability": "Unauthorized Access to Private Function",
        "reason": "The register_ function is marked as private but can be indirectly called through the invest function. This allows any address to be registered without any checks, potentially enabling attackers to create multiple accounts or manipulate the registration process to their advantage.",
        "file_name": "0x72f41244e09b3b2f09d9e2f5f1184fa8bd6b4a1e.sol"
    }
]