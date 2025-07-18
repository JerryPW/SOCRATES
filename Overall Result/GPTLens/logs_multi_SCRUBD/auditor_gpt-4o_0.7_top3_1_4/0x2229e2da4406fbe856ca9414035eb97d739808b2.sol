[
    {
        "function_name": "constructor",
        "code": "constructor () { _balances[address(this)] = _totalSupply; _isExcludedFromFee[owner()] = true; _isExcludedFromFee[marketingAddress] = true; _isExcludedFromFee[address(this)] = true; _isExcludedFromFee[devAddress] = true; taxFees = TaxFees(98,98); emit Transfer(address(0), 0xb70B90C114Fcb1Ba0f4bA65d4029e9e1c2d67164, _totalSupply); }",
        "vulnerability": "High Tax Fees",
        "reason": "The constructor sets both buy and sell tax fees to 98%. This is excessively high and can exploit users who trade the token, as nearly the entire amount will be taken as a fee. This creates a significant financial risk for any participant in the token economy.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    },
    {
        "function_name": "sendEth",
        "code": "function sendEth() external { uint256 ethBalance = address(this).balance; payable(devAddress).transfer(ethBalance); }",
        "vulnerability": "Unrestricted Ether Withdrawal",
        "reason": "The `sendEth` function allows any caller to transfer the entire Ether balance of the contract to the `devAddress`. This is a major vulnerability because it enables any user to drain the contract's Ether balance, leading to potential theft of funds.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    },
    {
        "function_name": "extractERC20Tokens",
        "code": "function extractERC20Tokens(address contractAddress) external { IERC20 erc20Token = IERC20(contractAddress); uint256 balance = erc20Token.balanceOf(address(this)); erc20Token.transfer(devAddress, balance); }",
        "vulnerability": "Unrestricted Token Withdrawal",
        "reason": "The `extractERC20Tokens` function allows any caller to transfer the entire balance of any ERC20 token held by the contract to the `devAddress`. This function lacks access control, permitting unauthorized users to transfer tokens, potentially resulting in loss of all assets held by the contract.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    }
]