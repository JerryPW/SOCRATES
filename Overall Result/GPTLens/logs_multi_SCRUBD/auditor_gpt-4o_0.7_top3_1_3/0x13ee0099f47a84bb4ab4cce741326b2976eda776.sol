[
    {
        "function_name": "setWithdrawAddress",
        "code": "function setWithdrawAddress(address newWithdrawAddress) external onlyWithdrawer { _withdrawAddress = newWithdrawAddress; }",
        "vulnerability": "Insecure permission control",
        "reason": "The setWithdrawAddress function allows the current withdrawer to change the withdraw address to any address they choose. If the withdrawer account is compromised, the attacker can redirect funds to an address under their control. This can lead to the permanent loss of all funds in the contract.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom( address sender, address recipient, uint256 amount ) external override returns (bool) { _transfer(sender, recipient, amount); uint256 currentAllowance = _allowances[sender][msg.sender]; require(currentAllowance >= amount); if (currentAllowance == INFINITY_ALLOWANCE) return true; unchecked { _approve(sender, msg.sender, currentAllowance - amount); } return true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The transferFrom function calls _transfer before updating the allowance. This pattern could potentially allow reentrancy if the recipient is a contract that calls back into this contract before the allowance is updated, leading to double spending of tokens.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    },
    {
        "function_name": "_arrangeFee",
        "code": "function _arrangeFee( address from, uint256 amount, uint256 fee ) private returns (uint256) { uint256 thisFee = (fee * thisShare) / 1000; uint256 stacking = 0; if (extraAddress != address(0)) stacking = (fee * extraShare) / 1000; uint256 burn = 0; if (thisShare + extraShare < 1000) burn = fee - thisFee - stacking; amount -= fee; _balances[from] -= fee; if (thisFee > 0) { _balances[address(this)] += thisFee; emit Transfer(from, address(this), thisFee); } if (stacking > 0) { _balances[extraAddress] += stacking; emit Transfer(from, extraAddress, stacking); } if (burn > 0) { _balances[ADDR_BURN] += burn; emit Transfer(from, ADDR_BURN, burn); } return amount; }",
        "vulnerability": "Incorrect fee calculation",
        "reason": "The _arrangeFee function does not properly check for overflow or underflow conditions when calculating the fee distribution. If the total fee calculated exceeds the balance of the 'from' address, it could result in erroneous balance deductions, potentially causing the contract to behave incorrectly.",
        "file_name": "0x13ee0099f47a84bb4ab4cce741326b2976eda776.sol"
    }
]