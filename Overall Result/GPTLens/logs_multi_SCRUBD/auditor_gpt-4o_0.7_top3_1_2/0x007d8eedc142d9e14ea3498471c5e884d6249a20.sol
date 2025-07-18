[
    {
        "function_name": "changeFees",
        "code": "function changeFees(uint256 _buy, uint256 _sell) external { require(_msgSender() == _deployer); require(_buy <= 100 && _sell <= 100,\"cannot set fees above 10%\"); fee1 = _buy; fee2 = _sell; }",
        "vulnerability": "Improper fee limit check allows up to 10% instead of 1%",
        "reason": "The function's require statement is intended to prevent setting fees above 10%, but the comment suggests the intention was to cap fees at 1%. This discrepancy can lead to high transaction fees, allowing the deployer to exploit users.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    },
    {
        "function_name": "editPercentages",
        "code": "function editPercentages(uint256 _pc1, uint256 _pc2, uint256 _pc3) external { require(_msgSender() == _deployer); require(_pc1 + _pc2 + _pc3 == 100,\"math faggot\"); pc1 = _pc1; pc2 = _pc2; pc3 = _pc3; }",
        "vulnerability": "Inappropriate language and potential centralization risk",
        "reason": "The function uses inappropriate language in the require statement's error message, which is unprofessional and can affect the contract's credibility. Additionally, allowing the deployer to change percentage allocations introduces a centralization risk, as they can redirect funds arbitrarily.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    },
    {
        "function_name": "removeLimits",
        "code": "function removeLimits() external { require(_msgSender() == _deployer); _maxTxAmount = _tTotal; _maxWalletAmount = _tTotal; }",
        "vulnerability": "Unlimited transaction and wallet limits by deployer",
        "reason": "This function allows the deployer to remove limits on transaction and wallet sizes, enabling them to conduct large transactions or accumulate large amounts of tokens, which could lead to market manipulation or a rug pull.",
        "file_name": "0x007d8eedc142d9e14ea3498471c5e884d6249a20.sol"
    }
]