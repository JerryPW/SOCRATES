[
    {
        "function_name": "withdrawERC20",
        "code": "function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner { require(_amountToWithdraw > 0); IERC20 tokenContract = IERC20(_tokenContract); require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, \"WithdrawV2: Contract does not own enough tokens\"); tokenContract.transfer(erc20Payable, _amountToWithdraw); _withdrawAllSurcharges(); }",
        "vulnerability": "ERC20 arbitrary withdrawal",
        "reason": "The function allows any team member or owner to withdraw any ERC20 tokens from the contract without any constraints on the token type or withdrawal limits. This could lead to a malicious team member draining all ERC20 tokens from the contract.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    },
    {
        "function_name": "setRamppAddress",
        "code": "function setRamppAddress(address _newAddress) public isRampp { require(_newAddress != RAMPPADDRESS, \"WithdrawableV2: New Rampp address must be different\"); RAMPPADDRESS = _newAddress; payableAddresses[0] = _newAddress; }",
        "vulnerability": "Unauthorized change of critical address",
        "reason": "The function allows the designated RAMPP account to change its own address in the contract. If the RAMPP account is compromised, the attacker could redirect funds to a different address and manipulate the contract's behavior.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    },
    {
        "function_name": "_widthdraw",
        "code": "function _widthdraw(address _address, uint256 _amount) private { (bool success, ) = _address.call{value: _amount}(\"\"); require(success, \"Transfer failed.\"); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Although the contract uses ReentrancyGuard in some places, this private function directly sends Ether using a low-level call without a reentrancy guard, potentially allowing reentrancy attacks if used improperly in the future.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    }
]