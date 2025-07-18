[
    {
        "function_name": "presaleMint",
        "code": "function presaleMint(uint256 number, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v, _r, _s) public payable nonReentrant{ require(!paused, \"Sale is paused!\"); require(saleState == State.PreSale1 || saleState == State.PreSale2, \"PreSale in not open yet!\"); if(saleState == State.PreSale1){ require(mintedAmountPreSale1 + number <= amountForPreSale1, \"Not enough NFTs for PreSale1 left to mint..\"); }else{ require(mintedAmountPreSale2 + number <= amountForPreSale2, \"Not enough NFTs for PreSale2 left to mint..\"); } require(totalSupply() + number <= maxTotalTokens - (maxReservedMints - _reservedMints), \"Not enough NFTs left to mint..\"); require(mintsPerAddressPreSale[msg.sender] + number <= maxMintPreSalePerWallet, \"Maximum Mints per Address exceeded!\"); require(msg.value >= mintCost() * number, \"Not sufficient Ether to mint this amount of NFTs\"); _safeMint(msg.sender, number); mintsPerAddressPreSale[msg.sender] += number; if(saleState == State.PreSale1){ mintedAmountPreSale1 += number; }else { mintedAmountPreSale2 += number; } ethFund += msg.value; }",
        "vulnerability": "Lack of validation on number of mints",
        "reason": "The function does not validate if the 'number' parameter is greater than zero. An attacker could potentially cause a logic issue or unexpected behavior by passing zero, which might not have a direct financial benefit but could be used to manipulate the state.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "claimRoyaltyReward",
        "code": "function claimRoyaltyReward() public nonReentrant{ uint256 holdAmount = balanceOf(msg.sender); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(msg.sender, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); royaltyDebt[id] = accEthPerShare.div(PRECISION_FACTOR); } _withdraw(payable(msg.sender), pendingReward); }",
        "vulnerability": "Integer underflow in royalty calculation",
        "reason": "The calculation of pendingReward does not handle the case where accEthPerShare.div(PRECISION_FACTOR) is less than royaltyDebt[id]. This could potentially lead to an underflow, allowing attackers to receive more funds than entitled.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "publicSaleMint",
        "code": "function publicSaleMint(uint256 number) public payable nonReentrant{ require(!paused, \"Sale is paused!\"); require(saleState == State.PublicSale, \"Public Sale in not open yet!\"); require(mintedAmountPublicSale + number <= amountForPublicSale, \"Not enough NFTs for PublicSale left to mint..\"); require(totalSupply() + number <= maxTotalTokens - (maxReservedMints - _reservedMints), \"Not enough NFTs left to mint..\"); require(mintsPerAddressPublicSale[msg.sender] + number <= maxMintPublicSalePerWallet, \"Maximum Mints per Address exceeded!\"); require(msg.value >= mintCost() * number, \"Not sufficient Ether to mint this amount of NFTs\"); _safeMint(msg.sender, number); mintsPerAddressPublicSale[msg.sender] += number; mintedAmountPublicSale += number; ethFund += msg.value; }",
        "vulnerability": "Lack of validation on number of mints",
        "reason": "Similar to presaleMint, this function does not validate if the 'number' parameter is greater than zero. Passing zero could lead to logical errors or state inconsistencies, potentially causing unexpected behavior.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    }
]