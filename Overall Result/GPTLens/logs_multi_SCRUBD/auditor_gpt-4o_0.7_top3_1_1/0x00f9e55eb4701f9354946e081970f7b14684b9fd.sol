[
    {
        "function_name": "_transfer",
        "code": "function _transfer( address sender, address recipient, uint256 amount ) internal override virtual { require(!paused(), \"ERC20: token transfer while paused\"); require(!isBlacklisted(msg.sender), \"ERC20: sender blacklisted\"); require(!isBlacklisted(recipient), \"ERC20: recipient blacklisted\"); require(!isBlacklisted(tx.origin), \"ERC20: sender blacklisted\"); if(taxStatus) { amount = handleTax(sender, recipient, amount); } super._transfer(sender, recipient, amount); }",
        "vulnerability": "Reentrancy vulnerability due to external call",
        "reason": "The function `handleTax` performs an external call via `swapExactTokensForETH` and `addLiquidityETH`. If an attacker is blacklisted, they could potentially exploit reentrancy if the external call triggers a callback to a function that modifies the state, such as blacklisting. The check for blacklisting is before the external call, leaving room for manipulation.",
        "file_name": "0x00f9e55eb4701f9354946e081970f7b14684b9fd.sol"
    },
    {
        "function_name": "setMaxWallet",
        "code": "function setMaxWallet (uint256 amount) external onlyOwner { require (amount > 10000, \"NO rug pull\"); maxWallet = amount * 10**18; }",
        "vulnerability": "Potential rug pull via maxWallet adjustment",
        "reason": "The `setMaxWallet` function allows the owner to change the `maxWallet` limit without any upper bound constraint other than being greater than 10,000 tokens. This means the owner can set an unreasonably high maxWallet limit, allowing them to execute a rug pull by dumping a large number of tokens into the market.",
        "file_name": "0x00f9e55eb4701f9354946e081970f7b14684b9fd.sol"
    },
    {
        "function_name": "triggerTax",
        "code": "function triggerTax() public onlyOwner { handleTax(address(0), address(uniswapV2Pair), 0); }",
        "vulnerability": "Potential DoS due to excessive gas consumption",
        "reason": "The `triggerTax` function can be called repeatedly by the owner, potentially causing excessive gas consumption. This might block important operations in the contract or delay other transactions, leading to a denial of service. Since it depends on external conditions and the `handleTax` function logic, it can be manipulated to consume more gas than normal.",
        "file_name": "0x00f9e55eb4701f9354946e081970f7b14684b9fd.sol"
    }
]