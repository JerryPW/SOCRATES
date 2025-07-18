[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) { require(amount > 0, \"Cannot withdraw 0\"); require(_balances[msg.sender].sub(amount) >= minLp || _balances[msg.sender].sub(amount) == 0, \"wrong amount\"); _totalSupply = _totalSupply.sub(amount); _balances[msg.sender] = _balances[msg.sender].sub(amount); uint256 fee = amount.div(feeRate); stakingToken.transfer(0x1111111111111111111111111111111111111111, fee); stakingToken.transfer(msg.sender, amount.sub(fee)); emit Withdrawn(msg.sender, amount); }",
        "vulnerability": "Burning tokens to a fixed address",
        "reason": "The withdrawal function sends the fee to a fixed address (0x1111111111111111111111111111111111111111) instead of the treasury or a zero address. This results in permanent loss of the fee amount, which is not beneficial for the system since the tokens cannot be recovered or used.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "swapExactETHForTokens",
        "code": "function swapExactETHForTokens(uint amountEth) internal { uniswap.swapExactETHForTokens.value(amountEth)(0, getPathForTokenToEth(address(NDR)), address(this), now + deadline); }",
        "vulnerability": "Potential for Reentrancy",
        "reason": "The function involves transferring ETH which can lead to reentrancy issues if the uniswap contract is compromised or if there's a fallback function in the token contract that can reenter into the system. While the function is internal and potentially less exposed, it can still introduce risk if used incorrectly elsewhere in the contract.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "buy",
        "code": "function buy(uint256 tokenId) public nonReentrant whenNotPaused payable { (,,,uint256 rarity,,uint256 series) = INodeRunnersNFT(address(NFT)).getFighter(tokenId); uint256 price; if (series == 1) { price = getPriceHero(rarity); } else if (series == 2) { price = getPriceSupport(rarity); } else { revert(\"wrong id\"); } require(msg.value >= price, \"wrong value\"); uint fee = msg.value / interest; treasury.transfer(fee); uint amountEth = (msg.value - fee) / 2; uint amountToken = getAmountsOut(amountEth, address(NDR)); swapExactETHForTokens(amountEth); amountToken = amountToken - (amountToken / divider); amountEth = amountEth - (amountEth / divider); addLiquidityETH(amountToken, amountEth * 99 / 100); INodeRunnersNFT(NFT).mint(msg.sender, tokenId, 1); }",
        "vulnerability": "Ether Handling and Reentrancy Risks",
        "reason": "This function handles ETH directly and involves multiple internal calls that can be recursively exploited if an attacker has a malicious fallback function. If the attacker can manipulate the state before the function completes, they can potentially withdraw more funds than intended or cause other unintended behaviors.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    }
]