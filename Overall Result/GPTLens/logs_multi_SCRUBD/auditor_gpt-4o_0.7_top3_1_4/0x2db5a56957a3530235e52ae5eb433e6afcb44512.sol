[
    {
        "function_name": "withdrawProtocolFee",
        "code": "function withdrawProtocolFee(address _paymentToken) external payable onlyOwner {\n    uint256 _totalFee = totalProtocolFee[_paymentToken];\n    require(_totalFee > 0, \"Not Fee\");\n    totalProtocolFee[_paymentToken] = 0;\n    if (_paymentToken == address(0)) {\n        payable(msg.sender).transfer(_totalFee);\n    } else {\n        IERC20(_paymentToken).transfer(msg.sender, _totalFee);\n    }\n}",
        "vulnerability": "Lack of reentrancy protection",
        "reason": "The function `withdrawProtocolFee` transfers funds to the `msg.sender` without any reentrancy protection. An attacker could exploit this by re-entering the function through a fallback function and draining the contract's balance.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    },
    {
        "function_name": "withdrawSupportFee",
        "code": "function withdrawSupportFee(address _paymentToken) external payable {\n    uint256 _totalFee = supporterFee[msg.sender][_paymentToken];\n    require(_totalFee > 0, \"Not Fee\");\n    supporterFee[msg.sender][_paymentToken] = 0;\n    if (_paymentToken == address(0)) {\n        payable(msg.sender).transfer(_totalFee);\n    } else {\n        IERC20(_paymentToken).transfer(msg.sender, _totalFee);\n    }\n}",
        "vulnerability": "Lack of reentrancy protection",
        "reason": "Similar to `withdrawProtocolFee`, the `withdrawSupportFee` function performs a state update before transferring funds. This allows for potential reentrancy attacks if the `msg.sender` is a contract with a fallback function that calls the function again.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    },
    {
        "function_name": "batchSwapFTforNFT",
        "code": "function batchSwapFTforNFT( address[] calldata _poolList, input[] calldata InputArray, address _supporter ) external payable {\n    uint256 _remainFee = msg.value;\n    for (uint256 i = 0; i < _poolList.length; ) {\n        require(InputArray[i].tokenIds.length > 0, \"Not 0\");\n        IPool.PoolInfo memory _poolInfo = IPool(_poolList[i]).getPoolInfo();\n        address _paymentToken = IPool(_poolList[i]).paymentToken();\n        uint256 _totalFee = IPool(_poolList[i]).getCalcBuyInfo( InputArray[i].tokenIds.length, _poolInfo.spotPrice );\n        uint256 _profitAmount;\n        if (_paymentToken == address(0)) {\n            require(_remainFee >= _totalFee, \"not enogh value\");\n            _remainFee -= _totalFee;\n            _profitAmount = IPool(_poolList[i]).swapFTforNFT{ value: _totalFee }(InputArray[i].tokenIds, msg.sender);\n        } else {\n            _profitAmount = IPool(_poolList[i]).swapFTforNFT( InputArray[i].tokenIds, msg.sender );\n        }\n        _updateFee(_supporter, _paymentToken, _profitAmount);\n        emit SwapFTforNFT( msg.sender, _poolList[i], InputArray[i].tokenIds, _totalFee, _supporter );\n        unchecked { ++i; }\n    }\n    if (_remainFee > 0) {\n        payable(msg.sender).transfer(_remainFee);\n    }\n}",
        "vulnerability": "Improper handling of reentrancy",
        "reason": "The function `batchSwapFTforNFT` involves multiple interactions with external contracts and can return excess Ether to the caller (`msg.sender`). If reentrancy occurs, it might lead to incorrect state updates or misuse of funds. Implementing reentrancy protection like a reentrancy guard would mitigate this risk.",
        "file_name": "0x2db5a56957a3530235e52ae5eb433e6afcb44512.sol"
    }
]