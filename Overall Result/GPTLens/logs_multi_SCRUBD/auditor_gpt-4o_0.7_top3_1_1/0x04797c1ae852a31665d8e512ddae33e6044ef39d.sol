[
    {
        "function_name": "removeBankroll",
        "code": "function removeBankroll(uint _amount, string _callbackFn) public returns (uint _recalled) { address _bankroller = msg.sender; uint _collateral = getCollateral(); uint _balance = address(this).balance; uint _available = _balance > _collateral ? _balance - _collateral : 0; if (_amount > _available) _amount = _available; _amount = ledger.subtract(_bankroller, _amount); bankroll = ledger.total(); if (_amount == 0) return; bytes4 _sig = bytes4(keccak256(_callbackFn)); require(_bankroller.call.value(_amount)(_sig)); emit BankrollRemoved(now, _bankroller, _amount, bankroll); return _amount; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function allows for sending ether to an external address via a call, which can lead to reentrancy attacks. An attacker could call removeBankroll, and while the call to _bankroller.call.value is being processed, they could call removeBankroll again before the first call finishes, potentially draining more funds than intended.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    },
    {
        "function_name": "_finalizePreviousRoll",
        "code": "function _finalizePreviousRoll(User memory _user, Stats memory _stats) private { assert(_user.r_block != uint32(block.number)); assert(_user.r_block != 0); uint8 _result = computeResult(_user.r_block, _user.r_id); bool _isWinner = _result <= _user.r_number; if (_isWinner) { require(msg.sender.call.value(_user.r_payout)()); _stats.totalWon += _user.r_payout; } emit RollFinalized(now, _user.r_id, msg.sender, _result, _isWinner ? _user.r_payout : 0); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Similar to removeBankroll, this function sends ether to an external address via a call. This call can be intercepted by the recipient to perform a reentrant call back into the contract, potentially leading to unexpected behavior or draining of funds.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    },
    {
        "function_name": "_errorAndRefund",
        "code": "function _errorAndRefund(string _msg, uint _bet, uint8 _number) private { require(msg.sender.call.value(msg.value)()); emit RollRefunded(now, msg.sender, _msg, _bet, _number); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "This function attempts to refund a user's bet by sending ether back to the sender. This also opens up the possibility of reentrancy attacks, where the sender can recursively call into the contract and potentially manipulate its state.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    }
]