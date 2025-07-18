[
    {
        "function_name": "renounceOwnership",
        "code": "function renounceOwnership() public virtual onlyOwner { emit OwnershipTransferred(_owner, address(0)); _owner = address(0); }",
        "vulnerability": "Ownership Renouncement",
        "reason": "The `renounceOwnership` function allows the current owner to set the owner to the zero address, effectively making the contract ownerless. This can be dangerous because it prevents any future administrative actions that require ownership, such as changing fee settings or updating important parameters, leaving no way to manage the contract.",
        "file_name": "0x09d063d9950cdf02d545ec6fb0166491e3ea4fd2.sol"
    },
    {
        "function_name": "setBots",
        "code": "function setBots(address[] memory bots_) external onlyOwner { for (uint i = 0; i < bots_.length; i++) { bots[bots_[i]] = true; } }",
        "vulnerability": "Centralized Control",
        "reason": "The `setBots` function allows the owner to arbitrarily mark addresses as bots, which could prevent those addresses from participating in transactions. This centralized control can be abused by the owner to block legitimate users, affecting fairness and trust in the contract.",
        "file_name": "0x09d063d9950cdf02d545ec6fb0166491e3ea4fd2.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity); swapTokensForEth(amountToSwap); uint256 totalEthBalance = address(this).balance; uint256 ethForREVIVAL = totalEthBalance.mul(toReflections).div(100); uint256 ethForDev = totalEthBalance.mul(toMarketing).div(100); uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (totalEthBalance > 0){ payable(devWallet).transfer(ethForDev); } try bensRevival.deposit{value: ethForREVIVAL}() {} catch {} if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } }",
        "vulnerability": "Unrestricted Token Swap",
        "reason": "The `swapBack` function swaps tokens and transfers ETH to the dev wallet without any limit on the amount to be swapped. This can lead to large amounts of tokens being swapped and large sums of ETH being transferred, potentially draining the contract's balance significantly if triggered maliciously.",
        "file_name": "0x09d063d9950cdf02d545ec6fb0166491e3ea4fd2.sol"
    }
]