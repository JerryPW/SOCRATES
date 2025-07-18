[
    {
        "function_name": "unlock",
        "code": "function unlock() public virtual { require(_previousOwner == msg.sender, \"You don't have permission to unlock\"); require(block.timestamp > _lockTime , \"Contract is locked until 7 days\"); emit OwnershipTransferred(_owner, _previousOwner); _owner = _previousOwner; }",
        "vulnerability": "Potential lock bypass",
        "reason": "The unlock function allows the previous owner to regain ownership after a lock period without verifying the lock period's correctness. An attacker could exploit incorrect lock duration settings or time manipulation vulnerabilities to regain control prematurely.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), \"Ownable: new owner is the zero address\"); emit OwnershipTransferred(_owner, newOwner); _owner = newOwner; }",
        "vulnerability": "Ownership transfer to address(0)",
        "reason": "The transferOwnership function lacks a mechanism to prevent transferring ownership to an address that may later be controlled by an attacker. Although it checks for zero address, it doesn't prevent assigning ownership to potentially malicious contracts.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    },
    {
        "function_name": "swapTokensForWallets",
        "code": "function swapTokensForWallets(uint256 tokenAmount, address _to) private { address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) { _approve(address(this), address(uniswapV2Router), ~uint256(0)); } uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, _to, block.timestamp ); }",
        "vulnerability": "Unbounded approval",
        "reason": "The swapTokensForWallets function sets an unbounded approval of tokens to the Uniswap router if the current allowance is insufficient. This could lead to a situation where a malicious actor could transfer more tokens than intended by exploiting the unlimited allowance.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    }
]