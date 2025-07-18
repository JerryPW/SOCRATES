[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Lack of Authorization Revocation",
        "reason": "When ownership is transferred, the previous owner's authorization is not revoked. This means the previous owner retains privileged access even after transferring ownership, which can lead to unauthorized actions by the former owner.",
        "file_name": "0x07ef026be5f1452f494e7af1b13a3333d5cd2d23.sol"
    },
    {
        "function_name": "setDistributionCriteria",
        "code": "function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external authorized { distributor.setDistributionCriteria(_minPeriod, _minDistribution); }",
        "vulnerability": "Setting Arbitrary Distribution Criteria",
        "reason": "An authorized user can set arbitrary values for minPeriod and minDistribution, potentially disrupting the normal operation of dividend distributions. This can be exploited to configure the contract in a way that prevents dividends from being distributed or to delay their distribution.",
        "file_name": "0x07ef026be5f1452f494e7af1b13a3333d5cd2d23.sol"
    },
    {
        "function_name": "setFees",
        "code": "function setFees(uint256 _liquidityFee, uint256 _buybackFee, uint256 _reflectionFee, uint256 _marketingFee, uint256 _feeDenominator) external authorized { liquidityFee = _liquidityFee; buybackFee = _buybackFee; reflectionFee = _reflectionFee; marketingFee = _marketingFee; totalFee = _liquidityFee.add(_buybackFee).add(_reflectionFee).add(_marketingFee); feeDenominator = _feeDenominator; require(totalFee < feeDenominator/4); }",
        "vulnerability": "Potential Fee Manipulation",
        "reason": "An authorized user can set the fee parameters (liquidityFee, buybackFee, reflectionFee, and marketingFee) to arbitrary values, which can result in extremely high or low fees. This could be exploited to set the fees to zero, benefiting certain transactions, or to excessively high fees, which would siphon tokens from transactions.",
        "file_name": "0x07ef026be5f1452f494e7af1b13a3333d5cd2d23.sol"
    }
]