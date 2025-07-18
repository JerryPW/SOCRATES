[
    {
        "function_name": "presaleMint",
        "code": "function presaleMint(uint256 number, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v, _r, _s) public payable nonReentrant{ require(!paused, \"Sale is paused!\"); require(saleState == State.PreSale1 || saleState == State.PreSale2, \"PreSale in not open yet!\"); if(saleState == State.PreSale1){ require(mintedAmountPreSale1 + number <= amountForPreSale1, \"Not enough NFTs for PreSale1 left to mint..\"); }else{ require(mintedAmountPreSale2 + number <= amountForPreSale2, \"Not enough NFTs for PreSale2 left to mint..\"); } require(totalSupply() + number <= maxTotalTokens - (maxReservedMints - _reservedMints), \"Not enough NFTs left to mint..\"); require(mintsPerAddressPreSale[msg.sender] + number <= maxMintPreSalePerWallet, \"Maximum Mints per Address exceeded!\"); require(msg.value >= mintCost() * number, \"Not sufficient Ether to mint this amount of NFTs\"); _safeMint(msg.sender, number); mintsPerAddressPreSale[msg.sender] += number; if(saleState == State.PreSale1){ mintedAmountPreSale1 += number; }else { mintedAmountPreSale2 += number; } ethFund += msg.value; }",
        "vulnerability": "Signature Replay Attack",
        "reason": "The function 'presaleMint' uses a signature verification mechanism to validate access. However, it does not prevent signature replay attacks, as the same signature can be reused by an attacker to mint multiple NFTs, provided they have a valid signature once. This could lead to unauthorized minting of NFTs.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "pendingRoyaltyReward",
        "code": "function pendingRoyaltyReward(address account) public view returns (uint256){ uint256 holdAmount = balanceOf(account); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(account, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); } return pendingReward; }",
        "vulnerability": "Integer Underflow",
        "reason": "The 'pendingRoyaltyReward' function calculates pending rewards using subtraction without ensuring that 'royaltyDebt[id]' is less than or equal to 'accEthPerShare.div(PRECISION_FACTOR)'. If 'royaltyDebt[id]' is larger, this could cause an integer underflow, resulting in incorrect pending reward calculations and potential financial losses.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "claimRoyaltyReward",
        "code": "function claimRoyaltyReward() public nonReentrant{ uint256 holdAmount = balanceOf(msg.sender); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(msg.sender, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); royaltyDebt[id] = accEthPerShare.div(PRECISION_FACTOR); } _withdraw(payable(msg.sender), pendingReward); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "Although the function is protected by a 'nonReentrant' modifier, the calculation and update of 'royaltyDebt' are performed before the external call '_withdraw'. If a future modification or external call logic bypasses the 'nonReentrant' modifier, it could lead to potential reentrancy attacks by manipulating royalty calculations.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    }
]