[
    {
        "function_name": "withdrawProtocolFee",
        "vulnerability": "Lack of Reentrancy Guard",
        "criticism": "The reasoning is correct. The function transfers funds to the caller without any reentrancy protection, which could allow an attacker to reenter the function before `totalProtocolFee[_paymentToken]` is set to zero. This could potentially lead to draining the contract's funds. The severity is high because it can lead to a complete loss of funds in the contract. The profitability is also high for an attacker who can exploit this vulnerability.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The function transfers funds to the caller without any reentrancy protection. An attacker could potentially reenter this function before `totalProtocolFee[_paymentToken]` is set to zero, allowing them to drain the contract's funds.",
        "code": "function withdrawProtocolFee(address _paymentToken) external payable onlyOwner { uint256 _totalFee = totalProtocolFee[_paymentToken]; require(_totalFee > 0, \"Not Fee\"); totalProtocolFee[_paymentToken] = 0; if (_paymentToken == address(0)) { payable(msg.sender).transfer(_totalFee); } else { IERC20(_paymentToken).transfer(msg.sender, _totalFee); } }",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    },
    {
        "function_name": "withdrawSupportFee",
        "vulnerability": "Lack of Reentrancy Guard",
        "criticism": "The reasoning is correct. Similar to `withdrawProtocolFee`, this function lacks reentrancy protection, allowing an attacker to repeatedly call the function before the state is updated. This could drain the funds meant for supporters. The severity is high due to the potential for significant fund loss. The profitability is high for an attacker who can exploit this vulnerability.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "Similar to `withdrawProtocolFee`, this function lacks reentrancy protection. An attacker could exploit this by repeatedly calling the function before the state is updated, thus draining the funds meant for supporters.",
        "code": "function withdrawSupportFee(address _paymentToken) external payable { uint256 _totalFee = supporterFee[msg.sender][_paymentToken]; require(_totalFee > 0, \"Not Fee\"); supporterFee[msg.sender][_paymentToken] = 0; if (_paymentToken == address(0)) { payable(msg.sender).transfer(_totalFee); } else { IERC20(_paymentToken).transfer(msg.sender, _totalFee); } }",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    },
    {
        "function_name": "batchStakeFT",
        "vulnerability": "Incorrect Ether Transfer Handling",
        "criticism": "The reasoning is incorrect. The function does check if `_remainFee` is greater than zero before transferring it back to the sender. The statement that this can lead to accidental loss of funds is not accurate in the current implementation. The severity and profitability are low because the function correctly handles the remaining Ether transfer.",
        "correctness": 2,
        "severity": 1,
        "profitability": 0,
        "reason": "The function returns any remaining Ether back to the sender without checking if the `_remainFee` is greater than zero. This can lead to accidental loss of funds if not handled properly, especially if the contract's logic is altered in the future.",
        "code": "function batchStakeFT( address[] calldata _poolList, uint256[] calldata _userSellNumList ) external payable { uint256 _remainFee = msg.value; for (uint256 i = 0; i < _poolList.length; ) { uint256 _stakeFTprice = IPool(_poolList[i]).stakeFTprice(); address _paymentToken = IPool(_poolList[i]).paymentToken(); uint256 _totalFee = IPool(_poolList[i]).getCalcSellInfo( _userSellNumList[i], _stakeFTprice ); if (_paymentToken == address(0)) { require(_remainFee >= _totalFee, \"not enogh value\"); _remainFee -= _totalFee; IPool(_poolList[i]).stakeFT{value: _totalFee}( _userSellNumList[i], msg.sender ); } else { IPool(_poolList[i]).stakeFT(_userSellNumList[i], msg.sender); } emit StakeFT( msg.sender, _poolList[i], _userSellNumList[i], _totalFee ); unchecked { ++i; } } if (_remainFee > 0) { payable(msg.sender).transfer(_remainFee); } }",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    }
]