[
    {
        "function_name": "destroyBeneficiary",
        "code": "function destroyBeneficiary(address _beneficiary) public onlyOwner { Beneficiary storage beneficiary = beneficiaries[_beneficiary]; uint256 balance = beneficiary.vested.sub(beneficiary.released); token.transfer(owner, balance); totalReleased = totalReleased.add(balance); beneficiary.isBeneficiary = false; beneficiary.released = beneficiary.released.add(balance); for (uint i = 0; i < addresses.length - 1; i++) if (addresses[i] == _beneficiary) { addresses[i] = addresses[addresses.length - 1]; break; } addresses.length -= 1; emit BeneficiaryDestroyed(_beneficiary); }",
        "vulnerability": "Unauthorized fund transfer",
        "reason": "The `destroyBeneficiary` function allows the contract owner to transfer all remaining vested tokens of a beneficiary to themselves without any condition checks on whether the beneficiary is entitled to those tokens. This means the owner can arbitrarily take tokens from any beneficiary, potentially defrauding them.",
        "file_name": "0x1d86a854da490ff74dedc7abe281fb468f8c19ee.sol"
    },
    {
        "function_name": "clearAll",
        "code": "function clearAll() public onlyOwner { token.transfer(owner, token.balanceOf(this)); for (uint i = 0; i < addresses.length; i++) { Beneficiary storage beneficiary = beneficiaries[addresses[i]]; beneficiary.isBeneficiary = false; beneficiary.released = 0; beneficiary.vested = 0; beneficiary.start = 0; beneficiary.cliff = 0; beneficiary.duration = 0; beneficiary.revoked = false; beneficiary.revocable = false; beneficiary.description = \"\"; } addresses.length = 0; }",
        "vulnerability": "Unconditional token transfer to owner",
        "reason": "The `clearAll` function transfers all tokens held by the contract to the owner, with no regard for the beneficiaries. This allows the owner to drain the contract of all funds, effectively stealing tokens that should be vested to beneficiaries.",
        "file_name": "0x1d86a854da490ff74dedc7abe281fb468f8c19ee.sol"
    },
    {
        "function_name": "revoke",
        "code": "function revoke(address _beneficiary) public onlyOwner { Beneficiary storage beneficiary = beneficiaries[_beneficiary]; require(beneficiary.revocable); require(!beneficiary.revoked); uint256 balance = beneficiary.vested.sub(beneficiary.released); uint256 unreleased = releasableAmount(_beneficiary); uint256 refund = balance.sub(unreleased); token.transfer(owner, refund); totalReleased = totalReleased.add(refund); beneficiary.revoked = true; beneficiary.released = beneficiary.released.add(refund); emit Revoked(_beneficiary); }",
        "vulnerability": "Potential double spend on revocation",
        "reason": "The `revoke` function is designed to refund the remaining vested tokens back to the owner upon revocation. However, it calculates the `refund` based on the difference between the full balance and the unreleased amount, potentially allowing the owner to reclaim more tokens than intended if the calculations are incorrect or manipulated.",
        "file_name": "0x1d86a854da490ff74dedc7abe281fb468f8c19ee.sol"
    }
]