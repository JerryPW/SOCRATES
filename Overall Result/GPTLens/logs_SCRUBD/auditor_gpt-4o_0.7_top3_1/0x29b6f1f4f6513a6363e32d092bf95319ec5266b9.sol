[
    {
        "function_name": "setMarketingWallet",
        "code": "function setMarketingWallet(address _address) public { require(msg.sender == marketingWallet, 'only accept by marketing wallet'); marketingWallet = _address; emit NewMarketingWallet(_address); }",
        "vulnerability": "Unauthorized wallet change",
        "reason": "The function allows the current marketing wallet to set a new marketing wallet without any additional security checks. If the private key of the current marketing wallet is compromised, the attacker can change the marketing wallet address to their own address, redirecting all future funds.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    },
    {
        "function_name": "setTreasury",
        "code": "function setTreasury(address _treasury) external onlyOwner { require(_treasury != address(treasury), 'Treasury is already set to that address'); require(_treasury != address(0), 'Treasury can not be the zero address'); treasury = Treasury(_treasury); _isExcludedFromFees[_treasury] = true; emit TreasuryChanged(_treasury); }",
        "vulnerability": "Treasury address change to non-contract",
        "reason": "The function allows the owner to set a new treasury address without verifying that the address is a contract. This could allow the owner to set the treasury to a standard wallet address, enabling them to bypass contract logic and potentially withdraw funds directly.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    },
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address token) external onlyOwner { require(token != address(this), 'Cannot claim native tokens'); if (token == address(0x0)) { payable(msg.sender).transfer(address(this).balance); return; } IERC20 ERC20token = IERC20(token); uint256 balance = ERC20token.balanceOf(address(this)); ERC20token.transfer(msg.sender, balance); }",
        "vulnerability": "Token draining by owner",
        "reason": "The function allows the owner to transfer any ERC20 token from the contract to themselves, excluding the native token. This could be exploited by the owner to drain any third-party tokens sent to the contract, without any restriction or checks.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    }
]