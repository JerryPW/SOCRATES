[
    {
        "function_name": "presaleMint",
        "vulnerability": "Lack of validation on number of mints",
        "criticism": "The reasoning is correct in identifying that the function does not check if the 'number' parameter is greater than zero. However, the impact of this oversight is minimal. Passing zero does not lead to a financial loss or gain, nor does it significantly affect the contract's state. The severity is low because it does not cause a critical failure or exploit. The profitability is also low as there is no direct financial benefit to an attacker.",
        "correctness": 8,
        "severity": 1,
        "profitability": 0,
        "reason": "The function does not validate if the 'number' parameter is greater than zero. An attacker could potentially cause a logic issue or unexpected behavior by passing zero, which might not have a direct financial benefit but could be used to manipulate the state.",
        "code": "function presaleMint(uint256 number, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v, _r, _s) public payable nonReentrant{ require(!paused, \"Sale is paused!\"); require(saleState == State.PreSale1 || saleState == State.PreSale2, \"PreSale in not open yet!\"); if(saleState == State.PreSale1){ require(mintedAmountPreSale1 + number <= amountForPreSale1, \"Not enough NFTs for PreSale1 left to mint..\"); }else{ require(mintedAmountPreSale2 + number <= amountForPreSale2, \"Not enough NFTs for PreSale2 left to mint..\"); } require(totalSupply() + number <= maxTotalTokens - (maxReservedMints - _reservedMints), \"Not enough NFTs left to mint..\"); require(mintsPerAddressPreSale[msg.sender] + number <= maxMintPreSalePerWallet, \"Maximum Mints per Address exceeded!\"); require(msg.value >= mintCost() * number, \"Not sufficient Ether to mint this amount of NFTs\"); _safeMint(msg.sender, number); mintsPerAddressPreSale[msg.sender] += number; if(saleState == State.PreSale1){ mintedAmountPreSale1 += number; }else { mintedAmountPreSale2 += number; } ethFund += msg.value; }",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "claimRoyaltyReward",
        "vulnerability": "Integer underflow in royalty calculation",
        "criticism": "The reasoning correctly identifies a potential underflow issue in the calculation of pendingReward. If accEthPerShare.div(PRECISION_FACTOR) is less than royaltyDebt[id], it could indeed lead to an underflow, resulting in incorrect reward calculations. This could allow an attacker to receive more funds than they are entitled to. The severity is moderate because it affects the financial integrity of the contract. The profitability is moderate as well, as an attacker could potentially exploit this to gain additional funds.",
        "correctness": 9,
        "severity": 5,
        "profitability": 5,
        "reason": "The calculation of pendingReward does not handle the case where accEthPerShare.div(PRECISION_FACTOR) is less than royaltyDebt[id]. This could potentially lead to an underflow, allowing attackers to receive more funds than entitled.",
        "code": "function claimRoyaltyReward() public nonReentrant{ uint256 holdAmount = balanceOf(msg.sender); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(msg.sender, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); royaltyDebt[id] = accEthPerShare.div(PRECISION_FACTOR); } _withdraw(payable(msg.sender), pendingReward); }",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "publicSaleMint",
        "vulnerability": "Lack of validation on number of mints",
        "criticism": "Similar to presaleMint, the reasoning is correct in identifying the lack of validation for the 'number' parameter being greater than zero. However, the impact is minimal as passing zero does not lead to significant issues or financial exploitation. The severity is low because it does not cause a critical failure or exploit. The profitability is also low as there is no direct financial benefit to an attacker.",
        "correctness": 8,
        "severity": 1,
        "profitability": 0,
        "reason": "Similar to presaleMint, this function does not validate if the 'number' parameter is greater than zero. Passing zero could lead to logical errors or state inconsistencies, potentially causing unexpected behavior.",
        "code": "function publicSaleMint(uint256 number) public payable nonReentrant{ require(!paused, \"Sale is paused!\"); require(saleState == State.PublicSale, \"Public Sale in not open yet!\"); require(mintedAmountPublicSale + number <= amountForPublicSale, \"Not enough NFTs for PublicSale left to mint..\"); require(totalSupply() + number <= maxTotalTokens - (maxReservedMints - _reservedMints), \"Not enough NFTs left to mint..\"); require(mintsPerAddressPublicSale[msg.sender] + number <= maxMintPublicSalePerWallet, \"Maximum Mints per Address exceeded!\"); require(msg.value >= mintCost() * number, \"Not sufficient Ether to mint this amount of NFTs\"); _safeMint(msg.sender, number); mintsPerAddressPublicSale[msg.sender] += number; mintedAmountPublicSale += number; ethFund += msg.value; }",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    }
]