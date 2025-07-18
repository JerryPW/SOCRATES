[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) { require(amount > 0, \"Cannot withdraw 0\"); require(_balances[msg.sender].sub(amount) >= minLp || _balances[msg.sender].sub(amount) == 0, \"wrong amount\"); _totalSupply = _totalSupply.sub(amount); _balances[msg.sender] = _balances[msg.sender].sub(amount); uint256 fee = amount.div(feeRate); stakingToken.transfer(0x1111111111111111111111111111111111111111, fee); stakingToken.transfer(msg.sender, amount.sub(fee)); emit Withdrawn(msg.sender, amount); }",
        "vulnerability": "Incorrect fee transfer",
        "reason": "The function transfers the fee to a hardcoded address '0x1111111111111111111111111111111111111111'. This is likely incorrect and should instead transfer to the treasury address or another designated address. This oversight results in the loss of fees, potentially allowing an attacker to exploit the system by repeatedly calling this function to drain funds.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "swapExactETHForTokens",
        "code": "function swapExactETHForTokens(uint amountEth) internal { uniswap.swapExactETHForTokens.value(amountEth)(0, getPathForTokenToEth(address(NDR)), address(this), now + deadline); }",
        "vulnerability": "Incorrect usage of payable keyword",
        "reason": "The swapExactETHForTokens function calls uniswap.swapExactETHForTokens.value(amountEth), but the function itself is not marked as payable. This will cause the transaction to revert. An attacker can exploit this by forcing the function to always fail, potentially causing issues in the smart contract's logic flow.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "redeem",
        "code": "function redeem(uint256 tokenId) public nonReentrant whenNotPaused updateReward(msg.sender) { (,,,,uint256 hashPrice,) = INodeRunnersNFT(address(NFT)).getFighter(tokenId); require(hashPrice > 0, \"can't buy in hash\"); uint256 reward = rewards[msg.sender]; require(reward >= hashPrice, \"not enough hash\"); rewards[msg.sender] = rewards[msg.sender].sub(hashPrice); INodeRunnersNFT(NFT).mint(msg.sender, tokenId, 1); emit RewardPaid(msg.sender, reward); }",
        "vulnerability": "Lack of checks on tokenId",
        "reason": "The redeem function lacks checks to ensure the tokenId exists or is valid within the context of the NFT contract. An attacker could potentially pass arbitrary tokenId values, resulting in unexpected behavior or unauthorized minting of NFTs. This could lead to dilution of NFT value or unauthorized access to restricted NFTs.",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    }
]