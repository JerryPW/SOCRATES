[
    {
        "function_name": "sendEth",
        "code": "function sendEth() external { uint256 ethBalance = address(this).balance; payable(devAddress).transfer(ethBalance); }",
        "vulnerability": "Unrestricted Ether Withdrawal",
        "reason": "The sendEth function allows any external caller to withdraw the entire Ether balance of the contract to the devAddress. This function lacks any form of access control, meaning any user can call it and potentially disrupt the contract's operations by draining its Ether balance.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    },
    {
        "function_name": "extractERC20Tokens",
        "code": "function extractERC20Tokens(address contractAddress) external { IERC20 erc20Token = IERC20(contractAddress); uint256 balance = erc20Token.balanceOf(address(this)); erc20Token.transfer(devAddress, balance); }",
        "vulnerability": "Unrestricted Token Withdrawal",
        "reason": "The extractERC20Tokens function allows any external caller to transfer the entire balance of any ERC20 tokens held by the contract to the devAddress. This function lacks access control, enabling any user to call it and potentially empty the contract of any ERC20 tokens it holds.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    },
    {
        "function_name": "_tokenTransfer",
        "code": "function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFees, bool isSell) private { uint256 taxAmount = takeFees ? amount.mul(taxFees.buyFee).div(100) : 0; if(takeFees && isSell) { taxAmount = amount.mul(taxFees.sellFee).div(100); } uint256 transferAmount = amount.sub(taxAmount); _balances[sender] = _balances[sender].sub(amount); _balances[recipient] = _balances[recipient].add(transferAmount); _balances[address(this)] = _balances[address(this)].add(taxAmount); emit Transfer(sender, recipient, amount); }",
        "vulnerability": "Transfer Event Mismatch",
        "reason": "The _tokenTransfer function emits a Transfer event with the full amount, rather than the actual transfer amount after fees are deducted. This can mislead users and tools that rely on the Transfer event to track token movements, as the event does not accurately reflect the net amount received by the recipient.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    }
]