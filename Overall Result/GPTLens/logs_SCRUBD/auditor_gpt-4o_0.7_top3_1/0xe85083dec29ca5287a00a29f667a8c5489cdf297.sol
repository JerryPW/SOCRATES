[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) public returns (bool) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race condition on approve - possible double spend",
        "reason": "The approve function allows changing the allowance for a spender without any checks for the current allowance, enabling a race condition. An attacker can exploit this by quickly spending the allowance before the allowance is reset, potentially leading to double spending issues. This is a well-known vulnerability in ERC20 token contracts referred to as the 'approve/transferFrom' race condition.",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol"
    },
    {
        "function_name": "withdrawEth",
        "code": "function withdrawEth() public { require(this.balance != 0); require(state == SaleState.ENDED); require(msg.sender == wallet); require(tokensTransferredToHold == true); uint bal = this.balance; wallet.transfer(bal); WithdrawedEthToWallet(bal); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdrawEth function transfers the entire balance to the wallet without using a pattern to prevent reentrancy attacks. An attacker could potentially call this function and then re-enter the contract through a fallback function, causing multiple withdrawals to occur before the balance is updated.",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol"
    },
    {
        "function_name": "addHolder",
        "code": "function addHolder(address holder, uint tokens, uint8 timed, uint timest) onlyAssetsOwners external { if (holderList[holder].isActive == false) { holderList[holder].isActive = true; holderList[holder].tokens = tokens; holderList[holder].holdPeriod = timed; holderList[holder].holdPeriodTimestamp = timest; holderIndexes[holderIndex] = holder; holderIndex++; } else { holderList[holder].tokens += tokens; holderList[holder].holdPeriod = timed; holderList[holder].holdPeriodTimestamp = timest; } Hold(msg.sender, holder, tokens, timed); }",
        "vulnerability": "Incorrect logic leading to potential overwriting of Holder data",
        "reason": "In the addHolder function, if a holder already exists, the function updates the holder's tokens without any checks or constraints. This could lead to incorrect overwriting of Holder data, as the tokens are simply added to the existing amount without validating the logic or ensuring consistency of the holder's record.",
        "file_name": "0xe85083dec29ca5287a00a29f667a8c5489cdf297.sol"
    }
]