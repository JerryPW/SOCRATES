[
    {
        "function_name": "removeBankroll",
        "code": "function removeBankroll(uint _amount, string _callbackFn) public returns (uint _recalled) { address _bankroller = msg.sender; uint _collateral = getCollateral(); uint _balance = address(this).balance; uint _available = _balance > _collateral ? _balance - _collateral : 0; if (_amount > _available) _amount = _available; _amount = ledger.subtract(_bankroller, _amount); bankroll = ledger.total(); if (_amount == 0) return; bytes4 _sig = bytes4(keccak256(_callbackFn)); require(_bankroller.call.value(_amount)(_sig)); emit BankrollRemoved(now, _bankroller, _amount, bankroll); return _amount; }",
        "vulnerability": "Arbitrary external call vulnerability",
        "reason": "The function uses `call` with a function signature generated from a string input without any validation, allowing an attacker to execute any arbitrary function on the recipient contract. This can be exploited to redirect funds or execute unintended logic, potentially leading to loss of funds for the contract.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    },
    {
        "function_name": "sendProfits",
        "code": "function sendProfits() public returns (uint _profits) { int _p = profits(); if (_p <= 0) return; _profits = uint(_p); profitsSent += _profits; address _tr = getTreasury(); require(_tr.call.value(_profits)()); emit ProfitsSent(now, _tr, _profits); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of `call.value()` to transfer ether to the treasury contract without proper checks or synchronization allows for reentrancy attacks. An attacker could potentially exploit this by reentering the contract and draining funds before the state changes are finalized.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    },
    {
        "function_name": "_finalizePreviousRoll",
        "code": "function _finalizePreviousRoll(User memory _user, Stats memory _stats) private { assert(_user.r_block != uint32(block.number)); assert(_user.r_block != 0); uint8 _result = computeResult(_user.r_block, _user.r_id); bool _isWinner = _result <= _user.r_number; if (_isWinner) { require(msg.sender.call.value(_user.r_payout)()); _stats.totalWon += _user.r_payout; } emit RollFinalized(now, _user.r_id, msg.sender, _result, _isWinner ? _user.r_payout : 0); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function sends ether to the user using `call.value()` without any reentrancy protection. This allows an attacker to reenter the contract and manipulate its state or drain funds by triggering multiple roll finalizations before the state is properly updated.",
        "file_name": "0x04797c1ae852a31665d8e512ddae33e6044ef39d.sol"
    }
]