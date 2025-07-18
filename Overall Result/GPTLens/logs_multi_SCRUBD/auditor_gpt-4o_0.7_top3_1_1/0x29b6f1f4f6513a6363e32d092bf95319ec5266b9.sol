[
    {
        "function_name": "setMarketingWallet",
        "code": "function setMarketingWallet(address _address) public { require(msg.sender == marketingWallet, 'only accept by marketing wallet'); marketingWallet = _address; emit NewMarketingWallet(_address); }",
        "vulnerability": "Marketing wallet takeover",
        "reason": "The function allows the current marketing wallet to change the marketing wallet address without any additional checks. If the private key of the marketing wallet is compromised, an attacker could change the marketing wallet address to an address they control, redirecting funds intended for marketing purposes.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    },
    {
        "function_name": "setTreasury",
        "code": "function setTreasury(address _treasury) external onlyOwner { require(_treasury != address(treasury), 'Treasury is already set to that address'); require(_treasury != address(0), 'Treasury can not be the zero address'); treasury = Treasury(_treasury); _isExcludedFromFees[_treasury] = true; emit TreasuryChanged(_treasury); }",
        "vulnerability": "Improper treasury address assignment",
        "reason": "The function allows the owner to set a new treasury address, but it assumes the new address is a contract that implements the Treasury interface. If the owner mistakenly sets an incorrect address that doesn't implement the Treasury functions, it could lead to failed transactions or lost funds during treasury operations.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    },
    {
        "function_name": "claimStuckTokens",
        "code": "function claimStuckTokens(address token) external onlyOwner { require(token != address(this), 'Cannot claim native tokens'); if (token == address(0x0)) { payable(msg.sender).transfer(address(this).balance); return; } IERC20 ERC20token = IERC20(token); uint256 balance = ERC20token.balanceOf(address(this)); ERC20token.transfer(msg.sender, balance); }",
        "vulnerability": "Potential misuse of claimStuckTokens",
        "reason": "The function allows the owner to claim any ERC20 tokens or ETH stuck in the contract. While this can be seen as a feature, it poses a risk if the contract inadvertently receives tokens or ETH that should not be withdrawn or used by the owner. This could be exploited by the owner to misappropriate funds under the guise of recovering 'stuck' tokens.",
        "file_name": "0x29b6f1f4f6513a6363e32d092bf95319ec5266b9.sol"
    }
]