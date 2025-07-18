[
    {
        "function_name": "change_owner",
        "code": "function change_owner(address new_owner) public onlyAuth { owner = new_owner; }",
        "vulnerability": "Authorization Bypass through Incorrect Access Control",
        "reason": "The `change_owner` function is protected by the `onlyAuth` modifier, allowing any authorized address to change the contract's owner. If an attacker gains authorization, they could take control of the contract by changing the owner, leading to a complete compromise.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer( address sender, address recipient, uint256 amount ) private { require(sender != address(0), \"Transfer from zero\"); if (isBotlist) { require( !_botlist[sender] && !_botlist[recipient], \"Botlisted!\" ); } bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient) || is_auth[sender] || is_auth[recipient]); bool isContractTransfer = (sender == address(this) || recipient == address(this)); bool isLiquidityTransfer = ((sender == _UniswapPairAddress && recipient == UniswapRouter) || (recipient == _UniswapPairAddress && sender == UniswapRouter)); if ( isContractTransfer || isLiquidityTransfer || isExcluded ) { _whitelistTransfer(sender, recipient, amount); } else { if (!tradingEnabled) { if (sender != owner && recipient != owner) { if (antiSnipe) { emit Transfer(sender, recipient, 0); return; } else { require(tradingEnabled, \"trading not yet enabled\"); } } } bool isBuy = sender == _UniswapPairAddress || sender == UniswapRouter; bool isSell = recipient == _UniswapPairAddress || recipient == UniswapRouter; _normalTransfer(sender, recipient, amount, isBuy, isSell); } }",
        "vulnerability": "Trading Lock Bypass",
        "reason": "The `_transfer` function allows certain transfers even when trading is not enabled, particularly for addresses that are excluded or authorized. An attacker can gain authorization and bypass the trading lock, allowing them to make trades when others cannot, potentially manipulating the market.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    },
    {
        "function_name": "WithdrawProjectETH",
        "code": "function WithdrawProjectETH() public onlyAuth { uint256 amount = projectBalance; projectBalance = 0; address sender = msg.sender; (bool sent, ) = sender.call{value: (amount)}(\"\"); require(sent, \"withdraw failed\"); }",
        "vulnerability": "Funds Draining by Authorized Users",
        "reason": "The `WithdrawProjectETH` function allows any authorized user to withdraw all project funds. If an attacker gains authorization, they could drain the entire balance allocated for the project, leading to a loss of funds intended for development or marketing purposes.",
        "file_name": "0x128ad1ad707c3b36e6f2ac9739f9df7516fdb592.sol"
    }
]