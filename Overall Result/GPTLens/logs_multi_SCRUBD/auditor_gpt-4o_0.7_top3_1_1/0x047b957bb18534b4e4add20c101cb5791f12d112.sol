[
    {
        "function_name": "unlock",
        "code": "function unlock() public virtual { require(_previousOwner == msg.sender, \"You don't have permission to unlock\"); require(block.timestamp > _lockTime , \"Contract is locked until 7 days\"); emit OwnershipTransferred(_owner, _previousOwner); _owner = _previousOwner; }",
        "vulnerability": "Ownership lock bypass",
        "reason": "After the contract lock period is over, the previous owner can regain ownership by calling the unlock function. This is exploitable if the previous owner has malicious intent and could allow them to regain control over the contract without the consent of the current owner. This function does not have a time limit for how long after the lock period the previous owner can regain ownership, potentially allowing unauthorized regain of control long after the initial lock.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    },
    {
        "function_name": "swapAndLiquify",
        "code": "function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap { uint256 liquidityTokenShare = contractTokenBalance.mul(_liquidityFee).div(_liquidityFee.add(_marketingFee).add(_devFee)); uint256 marketingTokenShare = contractTokenBalance.mul(_marketingFee).div(_liquidityFee.add(_marketingFee).add(_devFee)); uint256 teamTokenShare = contractTokenBalance.sub((liquidityTokenShare).add(marketingTokenShare)); uint256 half = liquidityTokenShare.div(2); uint256 otherHalf = liquidityTokenShare.sub(half); uint256 initialBalance = address(this).balance; swapTokensForEth(half); uint256 newBalance = address(this).balance.sub(initialBalance); addLiquidity(otherHalf, newBalance); swapTokensForWallets(marketingTokenShare, marketingWallet); swapTokensForWallets(teamTokenShare, devWallet); emit SwapAndLiquify(half, newBalance, otherHalf); }",
        "vulnerability": "Unprotected liquidity manipulation",
        "reason": "The swapAndLiquify function can be called whenever the contract's token balance exceeds a threshold, and it swaps a portion of tokens for ETH and adds liquidity. This operation is sensitive to the current state of the market, and if not properly protected, an attacker could manipulate the price of tokens or ETH by causing frequent swaps or manipulating the liquidity pool, leading to potential financial losses. There is no mechanism to prevent a series of rapid swaps that could cause slippage or other trading issues.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), \"Ownable: new owner is the zero address\"); emit OwnershipTransferred(_owner, newOwner); _owner = newOwner; }",
        "vulnerability": "Lack of transfer ownership confirmation",
        "reason": "The transferOwnership function immediately assigns ownership to a new address without any confirmation or acceptance from the new owner. This could lead to accidental or malicious transfers of ownership to unintended addresses, potentially leading to loss of control over the contract. A confirmation or acceptance step by the new owner would mitigate this risk.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    }
]