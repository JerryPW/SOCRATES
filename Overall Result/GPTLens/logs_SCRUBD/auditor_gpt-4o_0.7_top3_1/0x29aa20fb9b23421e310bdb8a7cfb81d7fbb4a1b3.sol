[
    {
        "function_name": "distribute_reward",
        "code": "function distribute_reward(uint256 _totalAttempt, uint256 _balance) internal { uint256 remaining_balance = _balance; for (uint8 i = 0; i < total_users; i++) { address user_address = active_users[i]; if (user_address > 0 && remaining_balance != 0) { uint256 proportion = users[user_address].proportional_contribution; uint256 divided_portion = (proportion * divisible_units) / _totalAttempt; uint256 payout = (_balance * divided_portion) / divisible_units; if (payout > remaining_balance) { payout = remaining_balance; } balances[user_address] = balances[user_address] + payout; remaining_balance = remaining_balance - payout; } } }",
        "vulnerability": "Integer Overflow/Underflow",
        "reason": "The function does not account for potential overflow or underflow when calculating `proportion * divisible_units` or `_balance * divided_portion`. If `_totalAttempt` is very small, these multiplications could overflow, leading to incorrect payouts and balance updates.",
        "file_name": "0x29aa20fb9b23421e310bdb8a7cfb81d7fbb4a1b3.sol"
    },
    {
        "function_name": "mine",
        "code": "function mine() external nonReentrant { uint256 _blockNum = external_to_internal_block_number(current_external_block()); require(!base_contract.checkMiningAttempt(_blockNum, this)); uint256 total_attempt = 0; uint8 total_ejected = 0; for (uint8 i=0; i < total_users; i++) { address user_address = active_users[i]; if (user_address > 0) { user memory u = users[user_address]; if (u.end_block <= mined_blocks) { if (total_ejected < 10) { delete active_users[i]; slots.push(i); delete users[active_users[i]]; total_ejected = total_ejected + 1; } } else { total_attempt = total_attempt + u.proportional_contribution; } } } if (total_attempt > 0) { attempts[_blockNum] = total_attempt; base_contract.mine.value(total_attempt)(); mined_blocks = mined_blocks + 1; } }",
        "vulnerability": "Potential Denial of Service (DoS)",
        "reason": "The function loops through `total_users` to calculate `total_attempt` and can potentially run out of gas if `total_users` is large. This creates a DoS risk where legitimate mining attempts can be blocked by an attacker with many accounts.",
        "file_name": "0x29aa20fb9b23421e310bdb8a7cfb81d7fbb4a1b3.sol"
    },
    {
        "function_name": "claim",
        "code": "function claim(uint256 _blockNumber, address forCreditTo) nonReentrant external returns (bool) { require(base_contract.checkWinning(_blockNumber)); uint256 initial_balance = base_contract.balanceOf(this); base_contract.claim(_blockNumber, this); uint256 balance = base_contract.balanceOf(this); uint256 total_attempt = attempts[_blockNumber]; distribute_reward(total_attempt, balance - initial_balance); claimed_blocks = claimed_blocks + 1; }",
        "vulnerability": "Incorrect Reward Distribution",
        "reason": "The function assumes that the balance increase after `base_contract.claim` is entirely due to the mined rewards. If there are other transfers to the contract during execution, the `distribute_reward` function will distribute more than it should, potentially draining the contract.",
        "file_name": "0x29aa20fb9b23421e310bdb8a7cfb81d7fbb4a1b3.sol"
    }
]