[
    {
        "function_name": "batchStakeFT",
        "code": "function batchStakeFT( address[] calldata _poolList, uint256[] calldata _userSellNumList ) external payable { uint256 _remainFee = msg.value; for (uint256 i = 0; i < _poolList.length; ) { uint256 _stakeFTprice = IPool(_poolList[i]).stakeFTprice(); address _paymentToken = IPool(_poolList[i]).paymentToken(); uint256 _totalFee = IPool(_poolList[i]).getCalcSellInfo( _userSellNumList[i], _stakeFTprice ); if (_paymentToken == address(0)) { require(_remainFee >= _totalFee, \"not enogh value\"); _remainFee -= _totalFee; IPool(_poolList[i]).stakeFT{value: _totalFee}( _userSellNumList[i], msg.sender ); } else { IPool(_poolList[i]).stakeFT(_userSellNumList[i], msg.sender); } emit StakeFT( msg.sender, _poolList[i], _userSellNumList[i], _totalFee ); unchecked { ++i; } } if (_remainFee > 0) { payable(msg.sender).transfer(_remainFee); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function calls external contracts within a loop and then transfers remaining Ether back to the sender. If any of the external contracts are malicious, they could exploit the reentrancy vulnerability by calling back into this function before it completes, potentially causing unexpected behavior or draining funds.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    },
    {
        "function_name": "withdrawProtocolFee",
        "code": "function withdrawProtocolFee(address _paymentToken) external payable onlyOwner { uint256 _totalFee = totalProtocolFee[_paymentToken]; require(_totalFee > 0, \"Not Fee\"); totalProtocolFee[_paymentToken] = 0; if (_paymentToken == address(0)) { payable(msg.sender).transfer(_totalFee); } else { IERC20(_paymentToken).transfer(msg.sender, _totalFee); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers Ether to the owner before updating the state variable `totalProtocolFee`. If the owner is a contract, it could re-enter `withdrawProtocolFee` and cause unexpected behavior, such as withdrawing more funds than intended.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    },
    {
        "function_name": "withdrawSupportFee",
        "code": "function withdrawSupportFee(address _paymentToken) external payable { uint256 _totalFee = supporterFee[msg.sender][_paymentToken]; require(_totalFee > 0, \"Not Fee\"); supporterFee[msg.sender][_paymentToken] = 0; if (_paymentToken == address(0)) { payable(msg.sender).transfer(_totalFee); } else { IERC20(_paymentToken).transfer(msg.sender, _totalFee); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Similar to `withdrawProtocolFee`, this function transfers Ether before updating the state variable `supporterFee`. If the caller is a contract, it could re-enter `withdrawSupportFee` and withdraw more funds than intended, leading to a potential loss of funds.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    }
]