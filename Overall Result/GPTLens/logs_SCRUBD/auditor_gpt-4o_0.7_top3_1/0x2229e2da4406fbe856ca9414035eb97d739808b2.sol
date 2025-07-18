[
    {
        "function_name": "constructor",
        "code": "constructor () { _balances[address(this)] = _totalSupply; _isExcludedFromFee[owner()] = true; _isExcludedFromFee[marketingAddress] = true; _isExcludedFromFee[address(this)] = true; _isExcludedFromFee[devAddress] = true; taxFees = TaxFees(98,98); emit Transfer(address(0), 0xb70B90C114Fcb1Ba0f4bA65d4029e9e1c2d67164, _totalSupply); }",
        "vulnerability": "High Buy/Sell Tax Fee",
        "reason": "The constructor sets both the buy and sell tax fees to 98%. This is an extremely high fee, which means that any transaction involving buying or selling the token will result in the user losing 98% of their tokens. This can be considered a malicious behavior, as it effectively prevents any meaningful token trading and can be a way to trap users' funds.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    },
    {
        "function_name": "sendEth",
        "code": "function sendEth() external { uint256 ethBalance = address(this).balance; payable(devAddress).transfer(ethBalance); }",
        "vulnerability": "Unauthorized Ether Transfer",
        "reason": "The sendEth function allows any caller to transfer the entire Ether balance of the contract to the developer's address. This creates a vulnerability where anyone can deplete the contract's Ether balance, making it a critical issue as it does not restrict access to only the contract owner or another authorized party.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    },
    {
        "function_name": "manualSwap",
        "code": "function manualSwap() external { uint256 contractTokenBalance = balanceOf(address(this)); if (contractTokenBalance > 0) { if (!inSwapAndLiquify) { swap(contractTokenBalance); } } }",
        "vulnerability": "Unrestricted Token Swap",
        "reason": "The manualSwap function can be called by anyone to swap the entire balance of tokens held by the contract. This is a severe vulnerability because it allows any user to trigger a swap, potentially affecting the token's market dynamics and causing unwanted effects on the liquidity pool. It should be restricted to the contract owner or an authorized entity.",
        "file_name": "0x2229e2da4406fbe856ca9414035eb97d739808b2.sol"
    }
]