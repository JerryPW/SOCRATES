[
    {
        "function_name": "validate",
        "code": "function validate(address _from, address _to, uint256 _amount) public returns (bool allowed) { return true; }",
        "vulnerability": "Ineffective compliance check",
        "reason": "The validate function in the ComplianceService contract returns true for any input, effectively rendering it useless for compliance checks. This allows for any transfer to be considered compliant, which could potentially enable illegal transactions that the compliance service is supposed to prevent.",
        "file_name": "0x2cc6ca9c3023a6a876fd54a03f68281c7aad0e8b.sol"
    },
    {
        "function_name": "constructor",
        "code": "constructor() public { uint256 totalSupply = 1350000000 ether; deposited[this] = totalSupply.mul(50).div(100); deposited[walletCommunityReserve] = totalSupply.mul(20).div(100); deposited[walletCompanyReserve] = totalSupply.mul(14).div(100); deposited[walletTeamAdvisors] = totalSupply.mul(15).div(100); deposited[walletBountyProgram] = totalSupply.mul(1).div(100); }",
        "vulnerability": "Mismanagement of initial funds",
        "reason": "The constructor of the Escrow contract allocates 50% of the total supply to itself and other portions to hardcoded addresses without any checks or balances. This could lead to a significant risk of fund mismanagement or loss if the hardcoded addresses are incorrect or the constructor is called inappropriately.",
        "file_name": "0x2cc6ca9c3023a6a876fd54a03f68281c7aad0e8b.sol"
    },
    {
        "function_name": "close",
        "code": "function close() onlyICOContract public returns (bool) { if (state != State.Active) { error('close: state != State.Active'); return false; } state = State.Closed; walletFounder1.transfer(address(this).balance.mul(33).div(100)); walletFounder2.transfer(address(this).balance.mul(50).div(100)); walletFounder3.transfer(address(this).balance); emit Closed(); return true; }",
        "vulnerability": "Imprecise fund allocation",
        "reason": "The close function in the RefundVault contract transfers percentages of the contract's balance to founder wallets using multiplication and division, which can lead to rounding errors and imprecise fund allocation. This can result in unexpected distribution of funds, potentially leaving some funds locked in the contract.",
        "file_name": "0x2cc6ca9c3023a6a876fd54a03f68281c7aad0e8b.sol"
    }
]