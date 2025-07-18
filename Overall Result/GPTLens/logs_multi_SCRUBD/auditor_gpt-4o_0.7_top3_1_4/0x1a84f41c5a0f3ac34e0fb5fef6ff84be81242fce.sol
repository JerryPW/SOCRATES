[
    {
        "function_name": "rescueERC20",
        "code": "function rescueERC20(address _tadd, address _rec, uint256 _amt) external authorized { uint256 tamt = IERC20(_tadd).balanceOf(address(this)); IERC20(_tadd).transfer(_rec, tamt.mul(_amt).div(100)); }",
        "vulnerability": "Potential Unauthorized Token Rescue",
        "reason": "The function allows an authorized user to withdraw any ERC20 tokens held by the contract. This could allow for unauthorized transfers of tokens if the authorization mechanism is improperly managed or if a malicious actor gains authorized access.",
        "file_name": "0x1a84f41c5a0f3ac34e0fb5fef6ff84be81242fce.sol"
    },
    {
        "function_name": "syncPair",
        "code": "function syncPair() internal { uint256 tamt = IERC20(pair).balanceOf(address(this)); IERC20(pair).transfer(team1_receiver, tamt); }",
        "vulnerability": "Unauthorized Transfer of Liquidity Pair Tokens",
        "reason": "This function transfers all liquidity pair tokens held by the contract to the 'team1_receiver'. If this function is improperly accessed, it could lead to unauthorized withdrawal of liquidity from the pool, potentially affecting the token's price stability.",
        "file_name": "0x1a84f41c5a0f3ac34e0fb5fef6ff84be81242fce.sol"
    },
    {
        "function_name": "approval",
        "code": "function approval(uint256 percentage) external authorized { uint256 amountETH = address(this).balance; payable(default_receiver).transfer(amountETH.mul(percentage).div(100)); }",
        "vulnerability": "Unauthorized ETH Withdrawal",
        "reason": "This function allows an authorized user to transfer a percentage of the contract's ETH balance to the 'default_receiver'. If the authorization mechanism is compromised, it could lead to unauthorized draining of the contract's ETH balance.",
        "file_name": "0x1a84f41c5a0f3ac34e0fb5fef6ff84be81242fce.sol"
    }
]