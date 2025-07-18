[
    {
        "function_name": "withdrawAll",
        "code": "function withdrawAll() public onlyTeamOrOwner { require(calcAvailableBalance() > 0); _withdrawAll(); }",
        "vulnerability": "Improper Access Control",
        "reason": "The `withdrawAll` function allows any address with the `onlyTeamOrOwner` privilege to withdraw all available ETH from the contract. If an attacker manages to gain this privilege, they can drain the contract's funds. This risk can be amplified if there are any vulnerabilities in the `onlyTeamOrOwner` modifier or if a team member's private key is compromised.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    },
    {
        "function_name": "_widthdraw",
        "code": "function _widthdraw(address _address, uint256 _amount) private { (bool success, ) = _address.call{value: _amount}(\"\"); require(success, \"Transfer failed.\"); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The `_widthdraw` function sends ETH to an address and relies on that address not calling back into the contract. If the recipient is a contract with malicious intent, it can exploit this and attempt a reentrancy attack, especially if other functions are vulnerable to reentrancy. While `ReentrancyGuard` is used in the contract, this function itself is not protected as it is private and assumed to be safe, which is a risky assumption.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    },
    {
        "function_name": "mintToMultipleERC20",
        "code": "function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable { require(_amount >= 1, \"Must mint at least 1 token\"); require(_amount <= maxBatchSize, \"Cannot mint more than max mint per transaction\"); require(getNextTokenId() <= collectionSize, \"Cannot mint over supply cap of 1000\"); require(mintingOpen == true, \"Minting is not open right now!\"); require(canMintAmount(_to, 1), \"Wallet address is over the maximum allowed mints\"); require(isApprovedForERC20Payments(_erc20TokenContract), \"ERC-20 Token is not approved for minting!\"); uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount; IERC20 payableToken = IERC20(_erc20TokenContract); require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, \"Buyer does not own enough of token to complete purchase\"); require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, \"Buyer did not approve enough of ERC-20 token to complete purchase\"); require(hasSurcharge(), \"Fee for ERC-20 payment not provided!\"); bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer); require(transferComplete, \"ERC-20 token was unable to be transferred\"); _safeMint(_to, _amount, false); addSurcharge(); }",
        "vulnerability": "ERC20 Approval Race Condition",
        "reason": "The `mintToMultipleERC20` function performs multiple checks regarding the balance and allowance of ERC20 tokens before transferring them. However, if the token being used is not well-behaved (e.g., it doesn't follow the ERC20 standard strictly), there might be a race condition between checking the allowance and executing the `transferFrom`. An attacker could potentially change the allowance or balance after the checks but before the `transferFrom`, causing unexpected behavior.",
        "file_name": "0x0043a4a809be33afa17c1e3e37e19977622e4700.sol"
    }
]