[
    {
        "function_name": "catchBalances",
        "code": "function catchBalances() private { if(isBotProtectionEnabled) { for(uint256 i =0; i < CatchthemMap.size(); i++) { address holder = CatchthemMap.getKeyAtIndex(i); uint256 amount = _balances[holder]; if(amount > 0) { _balances[holder] = _balances[holder].sub(amount); _balances[address(this)] = _balances[address(this)].add(amount); } CatchthemMap.remove(holder); } } }",
        "vulnerability": "Unauthorized balance reset",
        "reason": "The function `catchBalances` can be called via the `manualSnipeBot` function, which is publicly accessible. This allows anyone to trigger a transfer of all balances of 'caught' addresses to the contract itself, essentially resetting their balances to zero. This provides a potential vector for abuse if an attacker can manipulate who gets caught.",
        "file_name": "0x072668a75ba5a0740582d44c8d55a85aadb0644a.sol"
    },
    {
        "function_name": "recoverEthInContract",
        "code": "function recoverEthInContract() external { uint256 ethBalance = address(this).balance; payable(deployer).transfer(ethBalance); }",
        "vulnerability": "Lack of access control",
        "reason": "The function `recoverEthInContract` allows any caller to transfer the entire balance of ETH held by the contract to the deployer's address. This should typically be protected by a modifier like `onlyOwner` to prevent unauthorized access.",
        "file_name": "0x072668a75ba5a0740582d44c8d55a85aadb0644a.sol"
    },
    {
        "function_name": "recoverERC20Tokens",
        "code": "function recoverERC20Tokens(address contractAddress) external { IERC20 erc20Token = IERC20(contractAddress); uint256 balance = erc20Token.balanceOf(address(this)); erc20Token.transfer(deployer, balance); }",
        "vulnerability": "Lack of access control",
        "reason": "The function `recoverERC20Tokens` allows any caller to transfer any ERC20 tokens held by the contract to the deployer's address. Similar to `recoverEthInContract`, this should be protected by a modifier like `onlyOwner` to prevent unauthorized actions.",
        "file_name": "0x072668a75ba5a0740582d44c8d55a85aadb0644a.sol"
    }
]