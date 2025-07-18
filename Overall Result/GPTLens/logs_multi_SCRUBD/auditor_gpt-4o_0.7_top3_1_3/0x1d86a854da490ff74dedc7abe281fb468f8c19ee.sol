[
    {
        "function_name": "destroyBeneficiary",
        "code": "function destroyBeneficiary(address _beneficiary) public onlyOwner { Beneficiary storage beneficiary = beneficiaries[_beneficiary]; uint256 balance = beneficiary.vested.sub(beneficiary.released); token.transfer(owner, balance); totalReleased = totalReleased.add(balance); beneficiary.isBeneficiary = false; beneficiary.released = beneficiary.released.add(balance); for (uint i = 0; i < addresses.length - 1; i++) if (addresses[i] == _beneficiary) { addresses[i] = addresses[addresses.length - 1]; break; } addresses.length -= 1; emit BeneficiaryDestroyed(_beneficiary); }",
        "vulnerability": "Lack of checks for beneficiary existence",
        "reason": "The function does not verify if the provided _beneficiary address is a valid and existing beneficiary before proceeding with the token transfer and other operations. This could lead to unintended behavior or errors if a non-existent beneficiary address is passed to the function.",
        "file_name": "0x1d86a854da490ff74dedc7abe281fb468f8c19ee.sol"
    },
    {
        "function_name": "addBeneficiary",
        "code": "function addBeneficiary(address _beneficiary, uint256 _vested, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable, string _description) onlyOwner isNotBeneficiary(_beneficiary) public { require(_beneficiary != address(0)); require(_cliff >= _start); require(token.balanceOf(this) >= totalVested.sub(totalReleased).add(_vested)); beneficiaries[_beneficiary] = Beneficiary({ released : 0, vested : _vested, start : _start, cliff : _cliff, duration : _duration, revoked : false, revocable : _revocable, isBeneficiary : true, description : _description }); totalVested = totalVested.add(_vested); addresses.push(_beneficiary); emit NewBeneficiary(_beneficiary); }",
        "vulnerability": "Incorrect token balance check",
        "reason": "The function checks if the contract's token balance is sufficient to cover the newly vested amount, but it does not account for any tokens that may have already been transferred to beneficiaries. This could lead to a situation where the contract appears to have enough tokens, but in reality, it does not, potentially causing future token transfers to fail.",
        "file_name": "0x1d86a854da490ff74dedc7abe281fb468f8c19ee.sol"
    },
    {
        "function_name": "revoke",
        "code": "function revoke(address _beneficiary) public onlyOwner { Beneficiary storage beneficiary = beneficiaries[_beneficiary]; require(beneficiary.revocable); require(!beneficiary.revoked); uint256 balance = beneficiary.vested.sub(beneficiary.released); uint256 unreleased = releasableAmount(_beneficiary); uint256 refund = balance.sub(unreleased); token.transfer(owner, refund); totalReleased = totalReleased.add(refund); beneficiary.revoked = true; beneficiary.released = beneficiary.released.add(refund); emit Revoked(_beneficiary); }",
        "vulnerability": "Incorrect refund calculation",
        "reason": "The refund calculation subtracts the unreleased amount from the beneficiary's balance, but this could result in an incorrect refund if the vesting schedule or token transfer logic changes. This might lead to incorrect token transfers back to the owner, potentially depriving beneficiaries of their rightful vested amounts.",
        "file_name": "0x1d86a854da490ff74dedc7abe281fb468f8c19ee.sol"
    }
]