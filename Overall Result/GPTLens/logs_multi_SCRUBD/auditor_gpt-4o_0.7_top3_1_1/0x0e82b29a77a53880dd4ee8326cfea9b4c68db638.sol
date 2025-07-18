[
    {
        "function_name": "withdraw",
        "code": "function withdraw(address contractAddress) public nonReentrant {\n    require(contractAddressRecord[contractAddress] == true);\n    require(walletAddressRecord[msg.sender] == true);\n    address _customerAddress = msg.sender;\n    uint256 _dividends = myDividends(contractAddress, false);\n    balanceLedger[_customerAddress][contractAddress].payOut += (int256) (_dividends * magnitude);\n    _dividends += balanceLedger[_customerAddress][contractAddress].referralBalance;\n    balanceLedger[_customerAddress][contractAddress].referralBalance = 0;\n    if (contractAddress == address(0)){\n        payable(address(_customerAddress)).transfer(_dividends);\n    } else{\n        ERC20(contractAddress).transfer(_customerAddress,_dividends);\n    }\n    emit onWithdraw(_customerAddress, contractAddress, _dividends);\n}",
        "vulnerability": "Missing checks for ERC20 token transfer success",
        "reason": "The function attempts to transfer ERC20 tokens without verifying if the transfer was successful. This can lead to situations where the function assumes a transfer occurred when it did not, potentially allowing for exploitation by interrupting token transfers without detection.",
        "file_name": "0x0e82b29a77a53880dd4ee8326cfea9b4c68db638.sol"
    },
    {
        "function_name": "tokenOnboard",
        "code": "function tokenOnboard(address contractAddress, uint initialPrice, uint incrementPrice) public nonReentrant onlyOwner returns(bool) {\n    if(contractAddressRecord[contractAddress] == false) {\n        contractAddressRecord[contractAddress] = true;\n        tokenLedger[contractAddress].initialPrice = initialPrice;\n        tokenLedger[contractAddress].incrementPrice = incrementPrice;\n        tokenLedger[contractAddress].supply = 0;\n        tokenLedger[contractAddress].dividend = 0;\n        emit onTokenOnboard(contractAddress, initialPrice, incrementPrice);\n        return true;\n    }\n}",
        "vulnerability": "Lack of validation for onboarded token contracts",
        "reason": "The function allows any address to be onboarded as a token contract without validation. This can be exploited by malicious actors to onboard insecure or malicious contracts, potentially allowing them to manipulate the token system or exploit other weaknesses in the contract.",
        "file_name": "0x0e82b29a77a53880dd4ee8326cfea9b4c68db638.sol"
    },
    {
        "function_name": "sell",
        "code": "function sell(address contractAddress, uint256 _amountOfCollate) public {\n    require(contractAddressRecord[contractAddress] == true);\n    require(walletAddressRecord[msg.sender] == true);\n    address _customerAddress = msg.sender;\n    require(_amountOfCollate <= balanceLedger[_customerAddress][contractAddress].tokenBalance);\n    uint256 _collates = _amountOfCollate;\n    uint256 _tokens = collateralToToken_(contractAddress, _collates);\n    uint256 _dividends = SafeMath.div(_tokens, dividendFee);\n    uint256 _taxedToken = SafeMath.sub(_tokens, _dividends);\n    tokenLedger[contractAddress].supply = SafeMath.sub(tokenLedger[contractAddress].supply, _collates);\n    balanceLedger[_customerAddress][contractAddress].tokenBalance = SafeMath.sub(balanceLedger[_customerAddress][contractAddress].tokenBalance, _collates);\n    int256 _updatedPayouts = (int256) (tokenLedger[contractAddress].dividend * _collates + (_taxedToken * magnitude));\n    balanceLedger[_customerAddress][contractAddress].payOut -= _updatedPayouts;\n    if (tokenLedger[contractAddress].supply > 0) {\n        tokenLedger[contractAddress].dividend = SafeMath.add(tokenLedger[contractAddress].dividend, (_dividends * magnitude) / tokenLedger[contractAddress].supply);\n    }\n    emit onSell(_customerAddress, contractAddress, _taxedToken, _collates);\n}",
        "vulnerability": "Potential integer overflow in token dividend calculation",
        "reason": "The function uses arithmetic operations that could potentially overflow if not properly handled, especially when dealing with large dividend values. This could lead to incorrect calculations and exploit opportunities for manipulating token dividends.",
        "file_name": "0x0e82b29a77a53880dd4ee8326cfea9b4c68db638.sol"
    }
]