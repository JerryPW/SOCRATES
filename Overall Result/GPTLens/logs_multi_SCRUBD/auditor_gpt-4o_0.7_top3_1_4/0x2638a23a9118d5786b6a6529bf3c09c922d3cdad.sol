[
    {
        "function_name": "REL",
        "code": "function REL() public onlyOwner { require(block.timestamp >= _liquidityUnlockTime, \"Not yet unlocked\"); IUniswapV2ERC20 liquidityToken = IUniswapV2ERC20(_liquidityTokenAddress); uint256 amount = liquidityToken.balanceOf(address(this)); liquidityToken.transfer(Development, amount); }",
        "vulnerability": "Liquidity Draining",
        "reason": "The REL function allows the owner to transfer all the liquidity tokens held by the contract to the Development address once the liquidity unlock time has passed. This can be misused by the contract owner to drain all liquidity from the pool, which can severely impact the token's price and liquidity. The holder's funds can be locked in the liquidity pool without any way to withdraw them back.",
        "file_name": "0x2638a23a9118d5786b6a6529bf3c09c922d3cdad.sol"
    },
    {
        "function_name": "TeamCollectRemainingETH",
        "code": "function TeamCollectRemainingETH() public onlyOwner{ require(block.timestamp >= _liquidityUnlockTime, \"Not yet unlocked\"); _liquidityUnlockTime=block.timestamp+DefaultLiquidityLockTime; (bool sent,) =Development.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Potential ETH Drain",
        "reason": "The TeamCollectRemainingETH function allows the owner to collect all the ETH held in the contract once the liquidity unlock time has passed. This creates a risk where the owner can drain all ETH from the contract, leaving none for other purposes like paying rewards to users. This could be exploited by the owner, especially if combined with other functions that lock liquidity or prevent user withdrawals.",
        "file_name": "0x2638a23a9118d5786b6a6529bf3c09c922d3cdad.sol"
    },
    {
        "function_name": "addAddressToBlacklist",
        "code": "function addAddressToBlacklist(address blacklistedAddress) external onlyOwner { _isBlacklisted.add(blacklistedAddress); }",
        "vulnerability": "Centralized Control",
        "reason": "The addAddressToBlacklist function allows the owner to blacklist any address, effectively preventing it from participating in token transactions. This centralized control can be abused by the owner to arbitrarily restrict specific users from using the token, potentially causing unfair loss to users. This undermines the decentralized nature of blockchain by giving the owner too much control over user participation.",
        "file_name": "0x2638a23a9118d5786b6a6529bf3c09c922d3cdad.sol"
    }
]