[
    {
        "function_name": "manualSnipeBot",
        "code": "function manualSnipeBot() external { catchBalances(); }",
        "vulnerability": "Potential misuse by anyone",
        "reason": "The `manualSnipeBot` function calls `catchBalances`, which can reallocate balances of caught bots to the contract itself. This function is publicly accessible, allowing anyone to trigger it, potentially causing unintended balance reallocation and impacting users' funds. It should be restricted to owner or specific roles.",
        "file_name": "0x072668a75ba5a0740582d44c8d55a85aadb0644a.sol"
    },
    {
        "function_name": "recoverEthInContract",
        "code": "function recoverEthInContract() external { uint256 ethBalance = address(this).balance; payable(deployer).transfer(ethBalance); }",
        "vulnerability": "No access control on ETH recovery",
        "reason": "The `recoverEthInContract` function can be called by anyone to transfer all ETH in the contract to the deployer address. This lacks access control, leading to potential misuse where any user can drain ETH from the contract to the deployer without restrictions.",
        "file_name": "0x072668a75ba5a0740582d44c8d55a85aadb0644a.sol"
    },
    {
        "function_name": "recoverERC20Tokens",
        "code": "function recoverERC20Tokens(address contractAddress) external { IERC20 erc20Token = IERC20(contractAddress); uint256 balance = erc20Token.balanceOf(address(this)); erc20Token.transfer(deployer, balance); }",
        "vulnerability": "No access control on ERC20 token recovery",
        "reason": "The `recoverERC20Tokens` function allows anyone to transfer all ERC20 tokens from the contract to the deployer address. Without proper access control, this function can be exploited to drain tokens from the contract, causing loss of funds.",
        "file_name": "0x072668a75ba5a0740582d44c8d55a85aadb0644a.sol"
    }
]