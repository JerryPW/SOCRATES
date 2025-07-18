[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Lack of two-step ownership transfer",
        "reason": "The transferOwnership function allows immediate transfer of contract ownership to a new address without any confirmation step. This poses a security risk if the owner's account is compromised or if the owner accidentally transfers ownership to the wrong address.",
        "file_name": "0x19b423e5131d8e4996a18e69d0cb99674ba34c21.sol"
    },
    {
        "function_name": "setFees",
        "code": "function setFees( uint256 _liquidityFee, uint256 _buybackFee, uint256 _reflectionFee, uint256 _marketingFee, uint256 _feeDenominator ) public authorized { _setFees( _liquidityFee, _buybackFee, _reflectionFee, _marketingFee, _feeDenominator ); }",
        "vulnerability": "Fee adjustment by authorized accounts",
        "reason": "The setFees function allows any authorized account to modify the fees, which could be exploited by a malicious or compromised authorized account to set exorbitantly high fees, leading to potential fund drainage from transactions.",
        "file_name": "0x19b423e5131d8e4996a18e69d0cb99674ba34c21.sol"
    },
    {
        "function_name": "setDistributorSettings",
        "code": "function setDistributorSettings(uint256 gas) external authorized { require(gas < 750000, \"Gas must be lower than 750000\"); distributorGas = gas; }",
        "vulnerability": "Gas limit mismanagement",
        "reason": "The setDistributorSettings function allows an authorized user to set the gas limit for the distributor process. If set too low, it could prevent the distributor from processing, leading to a denial of service for dividend distribution.",
        "file_name": "0x19b423e5131d8e4996a18e69d0cb99674ba34c21.sol"
    }
]