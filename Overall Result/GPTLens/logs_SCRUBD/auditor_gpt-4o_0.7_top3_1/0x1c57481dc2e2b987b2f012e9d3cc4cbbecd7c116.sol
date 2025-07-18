[
    {
        "function_name": "extractTokensIfStuck",
        "code": "function extractTokensIfStuck(address _token, uint256 _amount) public onlyOwner { IERC20(_token).transfer(msg.sender, _amount); }",
        "vulnerability": "Potential loss of user funds",
        "reason": "This function allows the owner to transfer any tokens from the contract balance to themselves without any condition checks. If any user deposits tokens into the contract, these tokens can be drained by the owner using this function, leading to potential loss of user funds.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    },
    {
        "function_name": "extractETHIfStuck",
        "code": "function extractETHIfStuck() public onlyOwner { owner().transfer(address(this).balance); }",
        "vulnerability": "Potential loss of user funds",
        "reason": "Similar to the extractTokensIfStuck function, this function allows the owner to extract all ETH from the contract balance. If users interact with this contract and ETH gets stuck due to some operation, the owner can drain the ETH, resulting in potential loss of user funds.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    },
    {
        "function_name": "approveToken",
        "code": "function approveToken() public { IERC20(token).safeApprove(compound, uint(-1)); IERC20(token).safeApprove(dydx, uint(-1)); IERC20(token).safeApprove(getAaveCore(), uint(-1)); IERC20(token).safeApprove(fulcrum, uint(-1)); }",
        "vulnerability": "Unlimited token approval",
        "reason": "The function approves an unlimited amount of tokens to various protocol contracts. This practice can be dangerous if any of those protocols are compromised, as it would allow the attacker to transfer all approved tokens from this contract. It is a best practice to use minimal necessary approval to mitigate risk.",
        "file_name": "0x1c57481dc2e2b987b2f012e9d3cc4cbbecd7c116.sol"
    }
]