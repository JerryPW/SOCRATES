[
    {
        "function_name": "do_redemption",
        "code": "function do_redemption() internal { uint256 balance = balances[msg.sender]; if (balance > 0) { uint256 owner_cut = (balance / 100) * pool_percentage; uint256 remainder = balance - owner_cut; if (owner_cut > 0) { base_contract.transfer(owner, owner_cut); } base_contract.transfer(msg.sender, remainder); balances[msg.sender] = 0; } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `do_redemption` function transfers tokens to a user before setting their balance to zero. This allows an attacker to exploit this by calling the `redeem` function recursively before the balance is reset, withdrawing more funds than they should be able to.",
        "file_name": "0x29aa20fb9b23421e310bdb8a7cfb81d7fbb4a1b3.sol"
    },
    {
        "function_name": "distribute_reward",
        "code": "function distribute_reward(uint256 _totalAttempt, uint256 _balance) internal { uint256 remaining_balance = _balance; for (uint8 i = 0; i < total_users; i++) { address user_address = active_users[i]; if (user_address > 0 && remaining_balance != 0) { uint256 proportion = users[user_address].proportional_contribution; uint256 divided_portion = (proportion * divisible_units) / _totalAttempt; uint256 payout = (_balance * divided_portion) / divisible_units; if (payout > remaining_balance) { payout = remaining_balance; } balances[user_address] = balances[user_address] + payout; remaining_balance = remaining_balance - payout; } } }",
        "vulnerability": "Integer overflow/underflow vulnerability",
        "reason": "The function computes several arithmetic operations that manipulate balances and payouts. Without using SafeMath, these operations are susceptible to integer overflow and underflow, which could lead to incorrect balances being calculated and distributed.",
        "file_name": "0x29aa20fb9b23421e310bdb8a7cfb81d7fbb4a1b3.sol"
    },
    {
        "function_name": "mine",
        "code": "function mine() external nonReentrant { uint256 _blockNum = external_to_internal_block_number(current_external_block()); require(!base_contract.checkMiningAttempt(_blockNum, this)); uint256 total_attempt = 0; uint8 total_ejected = 0; for (uint8 i=0; i < total_users; i++) { address user_address = active_users[i]; if (user_address > 0) { user memory u = users[user_address]; if (u.end_block <= mined_blocks) { if (total_ejected < 10) { delete active_users[i]; slots.push(i); delete users[active_users[i]]; total_ejected = total_ejected + 1; } } else { total_attempt = total_attempt + u.proportional_contribution; } } } if (total_attempt > 0) { attempts[_blockNum] = total_attempt; base_contract.mine.value(total_attempt)(); mined_blocks = mined_blocks + 1; } }",
        "vulnerability": "Improper handling of user data",
        "reason": "The function deletes user data without properly managing the mapping indexes, which could overwrite user data or leave dangling references. Additionally, it does not handle cases where `total_attempt` could be manipulated to improperly calculate contributions, affecting mining and subsequent reward distribution.",
        "file_name": "0x29aa20fb9b23421e310bdb8a7cfb81d7fbb4a1b3.sol"
    }
]