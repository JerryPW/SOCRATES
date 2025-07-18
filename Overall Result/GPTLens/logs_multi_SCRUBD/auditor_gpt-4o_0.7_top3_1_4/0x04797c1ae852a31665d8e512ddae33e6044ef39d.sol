[
    {
        "function_name": "removeBankroll",
        "code": "function removeBankroll(uint _amount, string _callbackFn) public returns (uint _recalled) { address _bankroller = msg.sender; uint _collateral = getCollateral(); uint _balance = address(this).balance; uint _available = _balance > _collateral ? _balance - _collateral : 0; if (_amount > _available) _amount = _available; _amount = ledger.subtract(_bankroller, _amount); bankroll = ledger.total(); if (_amount == 0) return; bytes4 _sig = bytes4(keccak256(_callbackFn)); require(_bankroller.call.value(_amount)(_sig)); emit BankrollRemoved(now, _bankroller, _amount, bankroll); return _amount; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `removeBankroll` uses `call.value` to send Ether, which can trigger a fallback function in the recipient contract. This allows the recipient to re-enter the `removeBankroll` function before the state is updated, potentially allowing an attacker to drain funds.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    },
    {
        "function_name": "_finalizePreviousRoll",
        "code": "function _finalizePreviousRoll(User memory _user, Stats memory _stats) private { assert(_user.r_block != uint32(block.number)); assert(_user.r_block != 0); uint8 _result = computeResult(_user.r_block, _user.r_id); bool _isWinner = _result <= _user.r_number; if (_isWinner) { require(msg.sender.call.value(_user.r_payout)()); _stats.totalWon += _user.r_payout; } emit RollFinalized(now, _user.r_id, msg.sender, _result, _isWinner ? _user.r_payout : 0); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Similarly to `removeBankroll`, this function uses `call.value` for payout, which can be exploited by an attacker to perform reentrancy attacks, allowing them to potentially drain funds by repeatedly triggering payouts.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    },
    {
        "function_name": "_errorAndRefund",
        "code": "function _errorAndRefund(string _msg, uint _bet, uint8 _number) private { require(msg.sender.call.value(msg.value)()); emit RollRefunded(now, msg.sender, _msg, _bet, _number); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `_errorAndRefund` uses `call.value` to refund Ether, which can be exploited through reentrancy. Attackers could exploit this to call into the contract and manipulate its state or drain funds by repeatedly triggering refunds.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    }
]