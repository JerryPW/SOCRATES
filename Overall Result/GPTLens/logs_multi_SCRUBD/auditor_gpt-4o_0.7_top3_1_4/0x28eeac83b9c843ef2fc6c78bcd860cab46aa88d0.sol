[
    {
        "function_name": "setDistributionCriteria",
        "code": "function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external authorized { distributor.setDistributionCriteria(_minPeriod, _minDistribution); }",
        "vulnerability": "Unauthorized modification of distribution criteria",
        "reason": "The function allows any authorized user to modify key parameters that control dividend distribution frequency and amount. If an attacker gains authorized access, they can set these parameters to inappropriate values, disrupting the expected dividend distribution process and potentially hindering dividend claims by other shareholders.",
        "file_name": "0x28eeac83b9c843ef2fc6c78bcd860cab46aa88d0.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Ownership transfer without checks",
        "reason": "The transferOwnership function allows the owner to transfer ownership to any address without any checks or restrictions. This could lead to accidental or malicious transfer of ownership to an incorrect or malicious address, potentially resulting in a complete loss of control over the contract.",
        "file_name": "0x28eeac83b9c843ef2fc6c78bcd860cab46aa88d0.sol"
    },
    {
        "function_name": "setBuybackMultiplierSettings",
        "code": "function setBuybackMultiplierSettings(uint256 numerator, uint256 denominator, uint256 length) external authorized { require(numerator / denominator <= 2 && numerator > denominator); buybackMultiplierNumerator = numerator; buybackMultiplierDenominator = denominator; buybackMultiplierLength = length; }",
        "vulnerability": "Potential for excessive buyback multiplier",
        "reason": "The function allows an authorized user to set buyback multiplier settings without sufficient upper limits on the numerator and length. An attacker with authorized access can set excessively high values, which can result in unintended or excessive buybacks, draining contract funds or manipulating market prices.",
        "file_name": "0x28eeac83b9c843ef2fc6c78bcd860cab46aa88d0.sol"
    }
]