[
    {
        "function_name": "fogRollingIn",
        "code": "function fogRollingIn(uint256 _fogDensity) public { require(_fogDensity <= balanceOf(address(this)), \"ERC20TransferLiquidityLock::lockLiquidity: lock amount higher than lockable balance\"); require(_fogDensity != 0, \"ERC20TransferLiquidityLock::lockLiquidity: lock amount cannot be 0\"); uint256 fogToLockAmount = calculateVisabilityFee( _fogDensity, feeDecimals, fogLockPercentage ); fogLockSwap(fogToLockAmount); uint256 fogRemainder = _fogDensity.sub(fogToLockAmount); uint256 fogRewardsAmount = calculateVisabilityFee( fogRemainder, feeDecimals, fogRewardPercentage ); divideRewards(fogRewardsAmount); uint256 tokenRemainder = fogRemainder.sub(fogRewardsAmount); uint256 tokenBuyAmount = calculateVisabilityFee( tokenRemainder, feeDecimals, tokenLockPercentage ); buyAndLockToken(tokenBuyAmount); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function fogRollingIn allows for complex operations involving external calls such as swapFogTokensForEth and addLiquidity, which can lead to reentrancy attacks. An attacker could potentially exploit this by calling the function repeatedly before the state is updated, potentially draining funds or causing inconsistencies in the contract's logic.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    },
    {
        "function_name": "withdrawForeignTokens",
        "code": "function withdrawForeignTokens(address _tokenContract, address _to) onlySigner public returns (bool) { require(_tokenContract != address(this), \"cannot withdraw Fog\"); require(_tokenContract != address(uniswapV2Pair), \"cannot withdraw FOG LP\"); ERC20 token = ERC20(_tokenContract); uint256 amount = token.balanceOf(address(this)); return token.transfer(_to, amount); }",
        "vulnerability": "Privilege Escalation",
        "reason": "The function withdrawForeignTokens allows any signer to withdraw any ERC20 tokens held by the contract, except its own token and FOG LP tokens. This is a severe vulnerability as it allows potential insiders or compromised signers to steal tokens held in the contract, which could include valuable assets deposited by users.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    },
    {
        "function_name": "setUniswapV2Router",
        "code": "function setUniswapV2Router(address _uniswapV2Router) public onlySigner { require(uniswapV2Router == address(0), \"FogToken::setUniswapV2Router: already set\"); uniswapV2Router = _uniswapV2Router; }",
        "vulnerability": "Mutable Critical Contract Address",
        "reason": "The function setUniswapV2Router allows a signer to set the Uniswap V2 router address once. If this address is set to a malicious contract, it can lead to the loss of funds whenever the swap functionalities dependent on this address are invoked. Although it can only be set once, it poses a risk if the initial setting is compromised or incorrect.",
        "file_name": "0x35d7bbe9012b5a93ecdc5eef53ab9d143542abc7.sol"
    }
]