[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public authorized { owner = adr; authorizations[adr] = true; emit OwnershipTransferred(adr); }",
        "vulnerability": "Owner can transfer ownership without restrictions",
        "reason": "The transferOwnership function allows the current authorized user to transfer ownership to any address, including malicious ones, without any form of verification or restriction. This could result in the complete takeover of the contract by a malicious actor if authorization is compromised.",
        "file_name": "0x1a84f41c5a0f3ac34e0fb5fef6ff84be81242fce.sol"
    },
    {
        "function_name": "syncPair",
        "code": "function syncPair() internal { uint256 tamt = IERC20(pair).balanceOf(address(this)); IERC20(pair).transfer(team1_receiver, tamt); }",
        "vulnerability": "Transfer of all pair tokens to team1_receiver",
        "reason": "The syncPair function transfers all tokens held by the contract in the liquidity pool to the address set as team1_receiver. This could be exploited to drain liquidity from the pool, potentially causing a loss of value for token holders and destabilizing the token's market presence.",
        "file_name": "0x1a84f41c5a0f3ac34e0fb5fef6ff84be81242fce.sol"
    },
    {
        "function_name": "rescueERC20",
        "code": "function rescueERC20(address _tadd, address _rec, uint256 _amt) external authorized { uint256 tamt = IERC20(_tadd).balanceOf(address(this)); IERC20(_tadd).transfer(_rec, tamt.mul(_amt).div(100)); }",
        "vulnerability": "Authorized user can extract ERC20 tokens",
        "reason": "The rescueERC20 function allows any authorized user to transfer a specified percentage of any ERC20 tokens held by the contract to a specified address. This could be exploited by an authorized user to steal tokens from the contract.",
        "file_name": "0x1a84f41c5a0f3ac34e0fb5fef6ff84be81242fce.sol"
    }
]