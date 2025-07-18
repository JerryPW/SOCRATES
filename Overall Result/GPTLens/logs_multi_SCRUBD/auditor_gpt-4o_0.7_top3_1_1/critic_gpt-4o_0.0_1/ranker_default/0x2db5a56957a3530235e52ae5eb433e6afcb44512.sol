[
    {
        "function_name": "setPoolRouter",
        "vulnerability": "Lack of Access Control",
        "criticism": "The reasoning is correct in identifying that the function allows the owner to set a new router for a pool without any checks on the new router's validity. This could indeed allow the owner to set a malicious router contract that could exploit the pool's assets. The severity is high because it could lead to a complete loss of assets if a malicious router is set. The profitability is also high because the owner, or anyone who gains control over the owner's account, could exploit this to steal assets from the pool.",
        "correctness": 9,
        "severity": 8,
        "profitability": 7,
        "reason": "The function allows the owner to set a new router for a pool without any checks on the new router's validity. An owner could set a malicious router contract that could exploit the pool's assets.",
        "code": "function setPoolRouter(address _pool, address _newRouter) external onlyOwner { IPool(_pool).setRouter(_newRouter); }",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol",
        "final_score": 8.25
    },
    {
        "function_name": "batchSwapFTforNFT",
        "vulnerability": "Unchecked External Calls",
        "criticism": "The reasoning is correct in identifying that the function makes external calls to potentially untrusted contracts via `IPool(_poolList[i]).swapFTforNFT`. However, the function does not handle failures of these external calls, which could lead to inconsistent behavior or unexpected loss of funds. The severity is moderate because the function could fail silently, leading to potential loss of funds or unexpected behavior. The profitability is low because an attacker cannot directly profit from this vulnerability, but it could lead to a denial of service or other issues.",
        "correctness": 8,
        "severity": 5,
        "profitability": 1,
        "reason": "The function makes external calls to potentially untrusted contracts via `IPool(_poolList[i]).swapFTforNFT`. If any of these external calls fail, the function does not handle the failure properly, which may lead to inconsistent behavior or unexpected loss of funds.",
        "code": "function batchSwapFTforNFT( address[] calldata _poolList, input[] calldata InputArray, address _supporter ) external payable { uint256 _remainFee = msg.value; for (uint256 i = 0; i < _poolList.length; ) { require(InputArray[i].tokenIds.length > 0, \"Not 0\"); IPool.PoolInfo memory _poolInfo = IPool(_poolList[i]).getPoolInfo(); address _paymentToken = IPool(_poolList[i]).paymentToken(); uint256 _totalFee = IPool(_poolList[i]).getCalcBuyInfo( InputArray[i].tokenIds.length, _poolInfo.spotPrice ); uint256 _profitAmount; if (_paymentToken == address(0)) { require(_remainFee >= _totalFee, \"not enogh value\"); _remainFee -= _totalFee; _profitAmount = IPool(_poolList[i]).swapFTforNFT{ value: _totalFee }(InputArray[i].tokenIds, msg.sender); } else { _profitAmount = IPool(_poolList[i]).swapFTforNFT( InputArray[i].tokenIds, msg.sender ); } _updateFee(_supporter, _paymentToken, _profitAmount); emit SwapFTforNFT( msg.sender, _poolList[i], InputArray[i].tokenIds, _totalFee, _supporter ); unchecked { ++i; } } if (_remainFee > 0) { payable(msg.sender).transfer(_remainFee); } }",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol",
        "final_score": 5.5
    },
    {
        "function_name": "withdrawProtocolFee",
        "vulnerability": "Reentrancy Attack",
        "criticism": "The reasoning is partially correct. The function does indeed update the `totalProtocolFee` mapping after transferring the tokens, which is a common pattern that can lead to reentrancy vulnerabilities. However, the function is protected by the `onlyOwner` modifier, which limits the potential for exploitation to the contract owner. This reduces the severity and profitability of the vulnerability, as an external attacker cannot exploit it unless they gain control over the owner's account. Additionally, the use of `msg.sender` in the transfer function could be a point of concern if the owner is compromised. Overall, the vulnerability is present but mitigated by the access control.",
        "correctness": 6,
        "severity": 3,
        "profitability": 2,
        "reason": "The function updates the `totalProtocolFee` mapping after transferring the tokens. This allows for a reentrancy attack where an attacker could call the function recursively before the state is updated, potentially withdrawing more tokens than intended.",
        "code": "function withdrawProtocolFee(address _paymentToken) external payable onlyOwner { uint256 _totalFee = totalProtocolFee[_paymentToken]; require(_totalFee > 0, \"Not Fee\"); totalProtocolFee[_paymentToken] = 0; if (_paymentToken == address(0)) { payable(msg.sender).transfer(_totalFee); } else { IERC20(_paymentToken).transfer(msg.sender, _totalFee); } }",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol",
        "final_score": 4.25
    }
]