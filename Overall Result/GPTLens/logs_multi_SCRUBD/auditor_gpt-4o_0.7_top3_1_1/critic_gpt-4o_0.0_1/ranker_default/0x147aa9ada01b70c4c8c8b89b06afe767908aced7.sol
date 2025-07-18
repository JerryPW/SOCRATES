[
    {
        "function_name": "presaleMint",
        "vulnerability": "Signature Replay Attack",
        "criticism": "The reasoning is correct. The function does not prevent signature replay attacks, which could lead to unauthorized minting of NFTs. However, the severity is moderate because it depends on the attacker obtaining a valid signature in the first place. The profitability is high because an attacker could potentially mint multiple NFTs without paying for them.",
        "correctness": 8,
        "severity": 5,
        "profitability": 7,
        "reason": "The function 'presaleMint' uses a signature verification mechanism to validate access. However, it does not prevent signature replay attacks, as the same signature can be reused by an attacker to mint multiple NFTs, provided they have a valid signature once. This could lead to unauthorized minting of NFTs.",
        "code": "function presaleMint(uint256 number, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v, _r, _s) public payable nonReentrant{ require(!paused, \"Sale is paused!\"); require(saleState == State.PreSale1 || saleState == State.PreSale2, \"PreSale in not open yet!\"); if(saleState == State.PreSale1){ require(mintedAmountPreSale1 + number <= amountForPreSale1, \"Not enough NFTs for PreSale1 left to mint..\"); }else{ require(mintedAmountPreSale2 + number <= amountForPreSale2, \"Not enough NFTs for PreSale2 left to mint..\"); } require(totalSupply() + number <= maxTotalTokens - (maxReservedMints - _reservedMints), \"Not enough NFTs left to mint..\"); require(mintsPerAddressPreSale[msg.sender] + number <= maxMintPreSalePerWallet, \"Maximum Mints per Address exceeded!\"); require(msg.value >= mintCost() * number, \"Not sufficient Ether to mint this amount of NFTs\"); _safeMint(msg.sender, number); mintsPerAddressPreSale[msg.sender] += number; if(saleState == State.PreSale1){ mintedAmountPreSale1 += number; }else { mintedAmountPreSale2 += number; } ethFund += msg.value; }",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol",
        "final_score": 7.0
    },
    {
        "function_name": "pendingRoyaltyReward",
        "vulnerability": "Integer Underflow",
        "criticism": "The reasoning is correct. The function does not ensure that 'royaltyDebt[id]' is less than or equal to 'accEthPerShare.div(PRECISION_FACTOR)', which could lead to an integer underflow. However, the severity and profitability are low because it would require specific conditions (i.e., 'royaltyDebt[id]' being larger than 'accEthPerShare.div(PRECISION_FACTOR)') to exploit this vulnerability, and it would not directly benefit an attacker.",
        "correctness": 7,
        "severity": 2,
        "profitability": 1,
        "reason": "The 'pendingRoyaltyReward' function calculates pending rewards using subtraction without ensuring that 'royaltyDebt[id]' is less than or equal to 'accEthPerShare.div(PRECISION_FACTOR)'. If 'royaltyDebt[id]' is larger, this could cause an integer underflow, resulting in incorrect pending reward calculations and potential financial losses.",
        "code": "function pendingRoyaltyReward(address account) public view returns (uint256){ uint256 holdAmount = balanceOf(account); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(account, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); } return pendingReward; }",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol",
        "final_score": 4.25
    },
    {
        "function_name": "claimRoyaltyReward",
        "vulnerability": "Reentrancy Attack",
        "criticism": "The reasoning is partially correct. While the function does perform calculations and updates before the external call, it is protected by a 'nonReentrant' modifier, which prevents reentrancy attacks. Therefore, the risk of a reentrancy attack is low unless the 'nonReentrant' modifier is bypassed. The severity and profitability are also low because it would require a significant amount of effort to exploit this vulnerability, and it would not directly benefit an attacker.",
        "correctness": 4,
        "severity": 2,
        "profitability": 1,
        "reason": "Although the function is protected by a 'nonReentrant' modifier, the calculation and update of 'royaltyDebt' are performed before the external call '_withdraw'. If a future modification or external call logic bypasses the 'nonReentrant' modifier, it could lead to potential reentrancy attacks by manipulating royalty calculations.",
        "code": "function claimRoyaltyReward() public nonReentrant{ uint256 holdAmount = balanceOf(msg.sender); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(msg.sender, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); royaltyDebt[id] = accEthPerShare.div(PRECISION_FACTOR); } _withdraw(payable(msg.sender), pendingReward); }",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol",
        "final_score": 2.75
    }
]