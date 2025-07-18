[
    {
        "function_name": "swapTokensForETH",
        "code": "function swapTokensForETH(uint256 tokenAmount) private lockTheSwap { address[] memory path = new address[](2); path[0] = address(this); path[1] = router.WETH(); _approve(address(this), address(router), tokenAmount); router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); (bool success, ) = treasuryAddress.call{value: (ETHAmount.treasury * address(this).balance)/tokenAmount}(\"\"); require(success, 'ETH_TRANSFER_FAILED'); ETHAmount.treasury = 0; (success, ) = developmentAddress.call{value: (ETHAmount.development * address(this).balance)/tokenAmount}(\"\"); require(success, 'ETH_TRANSFER_FAILED'); ETHAmount.development = 0; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `swapTokensForETH` uses low-level call functions to transfer ETH to the `treasuryAddress` and `developmentAddress`. If either of these addresses is a contract that contains a fallback function, this can lead to a reentrancy attack, as the control is transferred back to the calling contract before the state variable `ETHAmount` is updated. The use of the `lockTheSwap` modifier attempts to mitigate reentrancy, but the lack of updating the state before the transfer can still pose a risk.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    },
    {
        "function_name": "rescueAnyERC20Tokens",
        "code": "function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner { IERC20(_tokenAddr).transfer(_to, _amount); }",
        "vulnerability": "Improper access control",
        "reason": "The `rescueAnyERC20Tokens` function allows the owner to transfer any ERC20 tokens held by the contract to another address. This is a centralization risk and can be exploited if the owner's private key is compromised, leading to a complete loss of any tokens stored in the contract.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    },
    {
        "function_name": "addWhiteListAddresses",
        "code": "function addWhiteListAddresses(address[] calldata addresses) external { require(hasRole(EDITOR_ROLE, msg.sender), \"Caller is not a lister\"); require(whitelistAccessCount + addresses.length <= 1000, \"Whitelist amount exceed\"); for (uint8 i = 0; i < addresses.length; i++) whitelisted[addresses[i]] = true; whitelistAccessCount += addresses.length; }",
        "vulnerability": "Role-based access control bypass risk",
        "reason": "The `addWhiteListAddresses` function allows the caller with the `EDITOR_ROLE` to add addresses to the whitelist. If an attacker gains access to an account with this role, they can whitelist arbitrary addresses to perform actions during presale or trading restrictions. The risk is compounded if the `EDITOR_ROLE` is not tightly controlled or if the account is compromised.",
        "file_name": "0x081d8a340d384cffca0c2dafbf45020d760d7576.sol"
    }
]