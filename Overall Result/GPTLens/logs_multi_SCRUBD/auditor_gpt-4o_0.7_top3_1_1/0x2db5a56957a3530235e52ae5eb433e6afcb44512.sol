[
    {
        "function_name": "withdrawProtocolFee",
        "code": "function withdrawProtocolFee(address _paymentToken) external payable onlyOwner { uint256 _totalFee = totalProtocolFee[_paymentToken]; require(_totalFee > 0, \"Not Fee\"); totalProtocolFee[_paymentToken] = 0; if (_paymentToken == address(0)) { payable(msg.sender).transfer(_totalFee); } else { IERC20(_paymentToken).transfer(msg.sender, _totalFee); } }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The function updates the `totalProtocolFee` mapping after transferring the tokens. This allows for a reentrancy attack where an attacker could call the function recursively before the state is updated, potentially withdrawing more tokens than intended.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    },
    {
        "function_name": "batchSwapFTforNFT",
        "code": "function batchSwapFTforNFT( address[] calldata _poolList, input[] calldata InputArray, address _supporter ) external payable { uint256 _remainFee = msg.value; for (uint256 i = 0; i < _poolList.length; ) { require(InputArray[i].tokenIds.length > 0, \"Not 0\"); IPool.PoolInfo memory _poolInfo = IPool(_poolList[i]).getPoolInfo(); address _paymentToken = IPool(_poolList[i]).paymentToken(); uint256 _totalFee = IPool(_poolList[i]).getCalcBuyInfo( InputArray[i].tokenIds.length, _poolInfo.spotPrice ); uint256 _profitAmount; if (_paymentToken == address(0)) { require(_remainFee >= _totalFee, \"not enogh value\"); _remainFee -= _totalFee; _profitAmount = IPool(_poolList[i]).swapFTforNFT{ value: _totalFee }(InputArray[i].tokenIds, msg.sender); } else { _profitAmount = IPool(_poolList[i]).swapFTforNFT( InputArray[i].tokenIds, msg.sender ); } _updateFee(_supporter, _paymentToken, _profitAmount); emit SwapFTforNFT( msg.sender, _poolList[i], InputArray[i].tokenIds, _totalFee, _supporter ); unchecked { ++i; } } if (_remainFee > 0) { payable(msg.sender).transfer(_remainFee); } }",
        "vulnerability": "Unchecked External Calls",
        "reason": "The function makes external calls to potentially untrusted contracts via `IPool(_poolList[i]).swapFTforNFT`. If any of these external calls fail, the function does not handle the failure properly, which may lead to inconsistent behavior or unexpected loss of funds.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    },
    {
        "function_name": "setPoolRouter",
        "code": "function setPoolRouter(address _pool, address _newRouter) external onlyOwner { IPool(_pool).setRouter(_newRouter); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The function allows the owner to set a new router for a pool without any checks on the new router's validity. An owner could set a malicious router contract that could exploit the pool's assets.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    }
]