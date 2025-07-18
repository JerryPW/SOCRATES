[
    {
        "function_name": "addWhiteListAddresses",
        "code": "function addWhiteListAddresses(address[] calldata addresses) external { require(hasRole(EDITOR_ROLE, msg.sender), \"Caller is not a lister\"); require(whitelistAccessCount + addresses.length <= 1000, \"Whitelist amount exceed\"); for (uint8 i = 0; i < addresses.length; i++) whitelisted[addresses[i]] = true; whitelistAccessCount += addresses.length; }",
        "vulnerability": "Unrestricted Whitelisting",
        "reason": "The function allows any user with the EDITOR_ROLE to add addresses to the whitelist without any further checks on the addresses being added. This could be exploited by a malicious actor with the EDITOR_ROLE to whitelist arbitrary addresses, potentially allowing unauthorized users to participate in presale events or bypass restrictions.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    },
    {
        "function_name": "swapTokensForETH",
        "code": "function swapTokensForETH(uint256 tokenAmount) private lockTheSwap { address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); _approve(address(this), address(router), tokenAmount); router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); (bool success, ) = treasuryAddress.call{value: (ETHAmount.treasury * address(this).balance)/tokenAmount}(\"\"); require(success, 'ETH_TRANSFER_FAILED'); ETHAmount.treasury = 0; (success, ) = developmentAddress.call{value: (ETHAmount.development * address(this).balance)/tokenAmount}(\"\"); require(success, 'ETH_TRANSFER_FAILED'); ETHAmount.development = 0; }",
        "vulnerability": "Incorrect ETH Distribution",
        "reason": "The function calculates the amount of ETH to transfer to treasuryAddress and developmentAddress based on the current balance of the contract, which might be incorrect due to concurrent swaps or ETH transfers. This can result in incorrect ETH distributions, leading to potential loss of funds for the treasury or development.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    },
    {
        "function_name": "rescueAnyERC20Tokens",
        "code": "function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner { IERC20(_tokenAddr).transfer(_to, _amount); }",
        "vulnerability": "Potential Token Theft",
        "reason": "This function allows the contract owner to transfer any ERC20 tokens held by the contract to any address. If the owner account is compromised, an attacker could use this function to steal all ERC20 tokens from the contract.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    }
]