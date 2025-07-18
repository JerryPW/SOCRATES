[
    {
        "function_name": "distribute_reward",
        "code": "function distribute_reward(uint256 _totalAttempt, uint256 _balance) internal { uint256 remaining_balance = _balance; for (uint8 i = 0; i < total_users; i++) { address user_address = active_users[i]; if (user_address > 0 && remaining_balance != 0) { uint256 proportion = users[user_address].proportional_contribution; uint256 divided_portion = (proportion * divisible_units) / _totalAttempt; uint256 payout = (_balance * divided_portion) / divisible_units; if (payout > remaining_balance) { payout = remaining_balance; } balances[user_address] = balances[user_address] + payout; remaining_balance = remaining_balance - payout; } } }",
        "vulnerability": "Integer Overflow/Underflow",
        "reason": "The function performs arithmetic operations like multiplication and division without any checks for overflow or underflow. If `_totalAttempt` is very large or very small, these operations can result in unexpected behavior. This can be exploited to manipulate the distribution of rewards, potentially causing incorrect payouts.",
        "file_name": "0x29aa20fb9b23421e310bdb8a7cfb81d7fbb4a1b3.sol"
    },
    {
        "function_name": "mine",
        "code": "function mine() external nonReentrant { uint256 _blockNum = external_to_internal_block_number(current_external_block()); require(!base_contract.checkMiningAttempt(_blockNum, this)); uint256 total_attempt = 0; uint8 total_ejected = 0; for (uint8 i=0; i < total_users; i++) { address user_address = active_users[i]; if (user_address > 0) { user memory u = users[user_address]; if (u.end_block <= mined_blocks) { if (total_ejected < 10) { delete active_users[i]; slots.push(i); delete users[active_users[i]]; total_ejected = total_ejected + 1; } } else { total_attempt = total_attempt + u.proportional_contribution; } } } if (total_attempt > 0) { attempts[_blockNum] = total_attempt; base_contract.mine.value(total_attempt)(); mined_blocks = mined_blocks + 1; } }",
        "vulnerability": "Reentrancy",
        "reason": "The `mine` function, even though marked as `nonReentrant`, calls an external contract `base_contract.mine.value(total_attempt)()`. If this external call is compromised or behaves unexpectedly, it can re-enter the contract, potentially disrupting the state and causing inconsistencies in the mining operation.",
        "file_name": "0x29aa20fb9b23421e310bdb8a7cfb81d7fbb4a1b3.sol"
    },
    {
        "function_name": "allocate_slot",
        "code": "function allocate_slot(address _who) internal { if(total_users < max_users) { active_users[total_users] = _who; total_users += 1; } else { if (slots.length == 0) { revert(); } else { uint8 location = slots[slots.length-1]; active_users[location] = _who; delete slots[slots.length-1]; } } }",
        "vulnerability": "Denial of Service",
        "reason": "The function uses a revert statement if slots are full and no available slot is found. An attacker can exploit this by filling the slots, causing new users to be unable to join the pool, effectively launching a denial of service attack.",
        "file_name": "0x29aa20fb9b23421e310bdb8a7cfb81d7fbb4a1b3.sol"
    }
]