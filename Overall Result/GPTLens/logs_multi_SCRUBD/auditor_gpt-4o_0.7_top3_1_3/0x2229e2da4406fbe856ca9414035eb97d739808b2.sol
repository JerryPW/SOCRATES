[
    {
        "function_name": "constructor",
        "code": "constructor () { _balances[address(this)] = _totalSupply; _isExcludedFromFee[owner()] = true; _isExcludedFromFee[marketingAddress] = true; _isExcludedFromFee[address(this)] = true; _isExcludedFromFee[devAddress] = true; taxFees = TaxFees(98,98); emit Transfer(address(0), 0xb70B90C114Fcb1Ba0f4bA65d4029e9e1c2d67164, _totalSupply); }",
        "vulnerability": "Excessive fees vulnerability",
        "reason": "The constructor sets both buy and sell fees to 98%, which is excessively high and could result in users losing most of their tokens during transactions. This configuration can be exploited to drain user funds upon every transaction, as nearly all transferred tokens are collected as fees.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    },
    {
        "function_name": "sendEth",
        "code": "function sendEth() external { uint256 ethBalance = address(this).balance; payable(devAddress).transfer(ethBalance); }",
        "vulnerability": "Unrestricted ETH withdrawal",
        "reason": "The sendEth function allows anyone to withdraw all ETH from the contract to the devAddress without any access control. This means any user can trigger this function, transferring all the ETH balance of the contract to the developer's address, posing a risk of unauthorized fund withdrawal.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    },
    {
        "function_name": "extractERC20Tokens",
        "code": "function extractERC20Tokens(address contractAddress) external { IERC20 erc20Token = IERC20(contractAddress); uint256 balance = erc20Token.balanceOf(address(this)); erc20Token.transfer(devAddress, balance); }",
        "vulnerability": "Unrestricted ERC20 withdrawal",
        "reason": "The extractERC20Tokens function allows any user to transfer all ERC20 tokens held by the contract to the devAddress, without any access restrictions. This can lead to unauthorized transfers of any ERC20 tokens sent to the contract, as there is no ownership check or permission control.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    }
]