[
    {
        "function_name": "withdrawProtocolFee",
        "code": "function withdrawProtocolFee(address _paymentToken) external payable onlyOwner { uint256 _totalFee = totalProtocolFee[_paymentToken]; require(_totalFee > 0, \"Not Fee\"); totalProtocolFee[_paymentToken] = 0; if (_paymentToken == address(0)) { payable(msg.sender).transfer(_totalFee); } else { IERC20(_paymentToken).transfer(msg.sender, _totalFee); } }",
        "vulnerability": "Reentrancy",
        "reason": "The function `withdrawProtocolFee` performs a state update on `totalProtocolFee[_paymentToken]` after sending funds. This opens up the potential for a reentrancy attack where an attacker can call the function again before the state is updated, allowing them to withdraw more funds than they should.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    },
    {
        "function_name": "withdrawSupportFee",
        "code": "function withdrawSupportFee(address _paymentToken) external payable { uint256 _totalFee = supporterFee[msg.sender][_paymentToken]; require(_totalFee > 0, \"Not Fee\"); supporterFee[msg.sender][_paymentToken] = 0; if (_paymentToken == address(0)) { payable(msg.sender).transfer(_totalFee); } else { IERC20(_paymentToken).transfer(msg.sender, _totalFee); } }",
        "vulnerability": "Reentrancy",
        "reason": "Similar to `withdrawProtocolFee`, the function `withdrawSupportFee` updates `supporterFee[msg.sender][_paymentToken]` after transferring funds. This can lead to a reentrancy attack where the function is called repeatedly before the state update, resulting in unauthorized fund withdrawals.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    },
    {
        "function_name": "batchStakeFT",
        "code": "function batchStakeFT( address[] calldata _poolList, uint256[] calldata _userSellNumList ) external payable { uint256 _remainFee = msg.value; for (uint256 i = 0; i < _poolList.length; ) { uint256 _stakeFTprice = IPool(_poolList[i]).stakeFTprice(); address _paymentToken = IPool(_poolList[i]).paymentToken(); uint256 _totalFee = IPool(_poolList[i]).getCalcSellInfo( _userSellNumList[i], _stakeFTprice ); if (_paymentToken == address(0)) { require(_remainFee >= _totalFee, \"not enogh value\"); _remainFee -= _totalFee; IPool(_poolList[i]).stakeFT{value: _totalFee}( _userSellNumList[i], msg.sender ); } else { IPool(_poolList[i]).stakeFT(_userSellNumList[i], msg.sender); } emit StakeFT( msg.sender, _poolList[i], _userSellNumList[i], _totalFee ); unchecked { ++i; } } if (_remainFee > 0) { payable(msg.sender).transfer(_remainFee); } }",
        "vulnerability": "Reentrancy and Insufficient Fee Check",
        "reason": "In `batchStakeFT`, if `_paymentToken == address(0)`, Ether is sent to an external call `stakeFT`. If this external call is reentrant, it may manipulate the remaining fee balance. Moreover, the remaining balance is transferred back to `msg.sender` at the end, which could be exploited if the function is called with malicious contract addresses.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    }
]