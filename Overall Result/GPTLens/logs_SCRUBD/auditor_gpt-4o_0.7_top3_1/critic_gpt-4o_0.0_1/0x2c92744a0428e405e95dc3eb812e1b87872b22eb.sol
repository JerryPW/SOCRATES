[
    {
        "function_name": "withdraw",
        "vulnerability": "Incorrect fee transfer",
        "criticism": "The reasoning is correct in identifying that the fee is transferred to a hardcoded address '0x1111111111111111111111111111111111111111', which is likely incorrect. This address is often used as a placeholder or a burn address, meaning the fees are effectively lost. However, the claim that an attacker could exploit this to drain funds is incorrect, as the funds are not being redirected to an attacker's address but are instead being burned. The severity is moderate due to the loss of fees, and the profitability is low since an attacker cannot directly profit from this.",
        "correctness": 6,
        "severity": 5,
        "profitability": 1,
        "reason": "The function transfers the fee to a hardcoded address '0x1111111111111111111111111111111111111111'. This is likely incorrect and should instead transfer to the treasury address or another designated address. This oversight results in the loss of fees, potentially allowing an attacker to exploit the system by repeatedly calling this function to drain funds.",
        "code": "function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) { require(amount > 0, \"Cannot withdraw 0\"); require(_balances[msg.sender].sub(amount) >= minLp || _balances[msg.sender].sub(amount) == 0, \"wrong amount\"); _totalSupply = _totalSupply.sub(amount); _balances[msg.sender] = _balances[msg.sender].sub(amount); uint256 fee = amount.div(feeRate); stakingToken.transfer(0x1111111111111111111111111111111111111111, fee); stakingToken.transfer(msg.sender, amount.sub(fee)); emit Withdrawn(msg.sender, amount); }",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "swapExactETHForTokens",
        "vulnerability": "Incorrect usage of payable keyword",
        "criticism": "The reasoning is correct that the function is missing the payable keyword, which is necessary for functions that receive Ether. This will indeed cause the transaction to revert, but the claim that an attacker can exploit this to cause issues in the contract's logic flow is overstated. The function will simply fail to execute, and no funds will be lost or misdirected. The severity is moderate because it prevents the function from working as intended, but the profitability is low since an attacker cannot gain from this.",
        "correctness": 8,
        "severity": 4,
        "profitability": 0,
        "reason": "The swapExactETHForTokens function calls uniswap.swapExactETHForTokens.value(amountEth), but the function itself is not marked as payable. This will cause the transaction to revert. An attacker can exploit this by forcing the function to always fail, potentially causing issues in the smart contract's logic flow.",
        "code": "function swapExactETHForTokens(uint amountEth) internal { uniswap.swapExactETHForTokens.value(amountEth)(0, getPathForTokenToEth(address(NDR)), address(this), now + deadline); }",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    },
    {
        "function_name": "redeem",
        "vulnerability": "Lack of checks on tokenId",
        "criticism": "The reasoning is correct in identifying that there are no checks to ensure the tokenId is valid. This could indeed lead to unauthorized minting of NFTs if the INodeRunnersNFT contract does not handle invalid tokenIds properly. The severity is high because it could lead to significant issues such as dilution of NFT value or unauthorized access. The profitability is also high, as an attacker could potentially mint valuable NFTs without proper authorization.",
        "correctness": 9,
        "severity": 8,
        "profitability": 7,
        "reason": "The redeem function lacks checks to ensure the tokenId exists or is valid within the context of the NFT contract. An attacker could potentially pass arbitrary tokenId values, resulting in unexpected behavior or unauthorized minting of NFTs. This could lead to dilution of NFT value or unauthorized access to restricted NFTs.",
        "code": "function redeem(uint256 tokenId) public nonReentrant whenNotPaused updateReward(msg.sender) { (,,,,uint256 hashPrice,) = INodeRunnersNFT(address(NFT)).getFighter(tokenId); require(hashPrice > 0, \"can't buy in hash\"); uint256 reward = rewards[msg.sender]; require(reward >= hashPrice, \"not enough hash\"); rewards[msg.sender] = rewards[msg.sender].sub(hashPrice); INodeRunnersNFT(NFT).mint(msg.sender, tokenId, 1); emit RewardPaid(msg.sender, reward); }",
        "file_name": "0x2c92744a0428e405e95dc3eb812e1b87872b22eb.sol"
    }
]