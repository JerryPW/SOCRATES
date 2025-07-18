[
    {
        "function_name": "removeBankroll",
        "code": "function removeBankroll(uint _amount, string _callbackFn) public returns (uint _recalled) { address _bankroller = msg.sender; uint _collateral = getCollateral(); uint _balance = address(this).balance; uint _available = _balance > _collateral ? _balance - _collateral : 0; if (_amount > _available) _amount = _available; _amount = ledger.subtract(_bankroller, _amount); bankroll = ledger.total(); if (_amount == 0) return; bytes4 _sig = bytes4(keccak256(_callbackFn)); require(_bankroller.call.value(_amount)(_sig)); emit BankrollRemoved(now, _bankroller, _amount, bankroll); return _amount; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses `call.value()` to send Ether to `_bankroller` which can lead to reentrancy attacks if the recipient is a contract with a fallback function that calls back into the contract. Execution of arbitrary code before state updates can allow for reentrancy exploits, leading to potential loss of funds.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    },
    {
        "function_name": "payoutPreviousRoll",
        "code": "function payoutPreviousRoll() public returns (bool _success) { User memory _prevUser = users[msg.sender]; if (_prevUser.r_block == uint32(block.number)){ emit PayoutError(now, \"Cannot payout roll on the same block\"); return false; } if (_prevUser.r_block == 0){ emit PayoutError(now, \"No roll to pay out.\"); return false; } User storage _user = users[msg.sender]; _user.r_id = 0; _user.r_block = 0; _user.r_number = 0; _user.r_payout = 0; Stats memory _stats = stats; _finalizePreviousRoll(_prevUser, _stats); stats.totalWon = _stats.totalWon; return true; }",
        "vulnerability": "Block hash dependency",
        "reason": "The function finalizes a roll based on the block hash of a past block. If too much time has passed, the block hash will be inaccessible, leading to an inability to finalize the roll. This dependency on block hashes makes the function unreliable in the long term, potentially blocking payouts.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    },
    {
        "function_name": "_errorAndRefund",
        "code": "function _errorAndRefund(string _msg, uint _bet, uint8 _number) private { require(msg.sender.call.value(msg.value)()); emit RollRefunded(now, msg.sender, _msg, _bet, _number); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Similar to the `removeBankroll` function, this function uses `call.value()` for refunds without updating the state beforehand. This allows a malicious contract to perform a reentrancy attack by calling the contract again before the state is updated, potentially draining funds from the contract.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    }
]