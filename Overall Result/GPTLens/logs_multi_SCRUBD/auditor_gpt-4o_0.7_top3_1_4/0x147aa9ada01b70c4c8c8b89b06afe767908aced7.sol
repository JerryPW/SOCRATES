[
    {
        "function_name": "presaleMint",
        "code": "function presaleMint(uint256 number, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v, _r, _s) public payable nonReentrant{ require(!paused, \"Sale is paused!\"); require(saleState == State.PreSale1 || saleState == State.PreSale2, \"PreSale in not open yet!\"); if(saleState == State.PreSale1){ require(mintedAmountPreSale1 + number <= amountForPreSale1, \"Not enough NFTs for PreSale1 left to mint..\"); }else{ require(mintedAmountPreSale2 + number <= amountForPreSale2, \"Not enough NFTs for PreSale2 left to mint..\"); } require(totalSupply() + number <= maxTotalTokens - (maxReservedMints - _reservedMints), \"Not enough NFTs left to mint..\"); require(mintsPerAddressPreSale[msg.sender] + number <= maxMintPreSalePerWallet, \"Maximum Mints per Address exceeded!\"); require(msg.value >= mintCost() * number, \"Not sufficient Ether to mint this amount of NFTs\"); _safeMint(msg.sender, number); mintsPerAddressPreSale[msg.sender] += number; if(saleState == State.PreSale1){ mintedAmountPreSale1 += number; }else { mintedAmountPreSale2 += number; } ethFund += msg.value; }",
        "vulnerability": "Signature Replay Attack",
        "reason": "The function uses a signature verification to enforce access control but does not include any mechanism to prevent replay attacks. An attacker can reuse a valid signature multiple times to mint more tokens than allowed.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "claimRoyaltyReward",
        "code": "function claimRoyaltyReward() public nonReentrant{ uint256 holdAmount = balanceOf(msg.sender); uint256 pendingReward = 0; for (uint256 i = 0; i < holdAmount; i++) { uint256 id = tokenOfOwnerByIndex(msg.sender, i); pendingReward += (accEthPerShare.div(PRECISION_FACTOR)).sub(royaltyDebt[id]); royaltyDebt[id] = accEthPerShare.div(PRECISION_FACTOR); } _withdraw(payable(msg.sender), pendingReward); }",
        "vulnerability": "Arithmetic Underflow/Overflow in Reward Calculation",
        "reason": "The calculation of pendingReward involves division and subtraction operations that can lead to incorrect results if not properly checked for underflows or overflows. This could allow an attacker to claim incorrect amounts of royalty rewards.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    },
    {
        "function_name": "withdrawFund",
        "code": "function withdrawFund() public onlyOwner { require(ethFund > 0, 'No Funds to withdraw, Balance is 0'); _withdraw(payable(0xd7DDfE7233D872d3600549b570b3631604aA5ffF), ethFund); ethFund = 0; }",
        "vulnerability": "Centralized Fund Withdrawal",
        "reason": "The function allows only the owner to withdraw all accumulated ether, introducing a centralization risk. If the owner's private key is compromised, an attacker can drain the contract's funds.",
        "file_name": "0x147aa9ada01b70c4c8c8b89b06afe767908aced7.sol"
    }
]