[
    {
        "function_name": "unlock",
        "code": "function unlock() public virtual { require(_previousOwner == msg.sender, \"You don't have permission to unlock\"); require(block.timestamp > _lockTime , \"Contract is locked until 7 days\"); emit OwnershipTransferred(_owner, _previousOwner); _owner = _previousOwner; }",
        "vulnerability": "Time-based lock circumvention",
        "reason": "The unlock function allows the _previousOwner to regain ownership after the lock time has elapsed. However, the check `require(block.timestamp > _lockTime, ...)` can be risky if the block timestamp is manipulated by miners, allowing potential circumvention of the lock timing if the miner is colluding with the attacker.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    },
    {
        "function_name": "swapTokensForWallets",
        "code": "function swapTokensForWallets(uint256 tokenAmount, address _to) private { address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) { _approve(address(this), address(uniswapV2Router), ~uint256(0)); } uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, _to, block.timestamp ); }",
        "vulnerability": "Infinite allowance",
        "reason": "The function sets an infinite allowance with `_approve(address(this), address(uniswapV2Router), ~uint256(0))` when allowance is insufficient. This could be exploited if the uniswapV2Router contract is compromised or has vulnerabilities, as it would allow potentially unlimited token transfers from the contract without further approval.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), \"Ownable: new owner is the zero address\"); emit OwnershipTransferred(_owner, newOwner); _owner = newOwner; }",
        "vulnerability": "Ownership transfer to zero address",
        "reason": "While the function prevents transferring ownership to the zero address, it does not prevent transferring ownership to a contract that cannot handle ownership, potentially locking the contract's functionality if the new owner is a contract without the necessary functionality to manage ownership.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    }
]