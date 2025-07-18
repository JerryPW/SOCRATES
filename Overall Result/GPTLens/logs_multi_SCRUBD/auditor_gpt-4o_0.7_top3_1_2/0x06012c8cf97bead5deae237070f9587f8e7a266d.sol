[
    {
        "function_name": "withdrawBalance",
        "code": "function withdrawBalance() external { address nftAddress = address(nonFungibleContract); require( msg.sender == owner || msg.sender == nftAddress ); bool res = nftAddress.send(this.balance); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses 'send' to transfer balance, which only forwards 2300 gas units and can fail if the recipient contract requires more gas. Additionally, if an external contract is the nonFungibleContract, it can re-enter this contract if there are any state changes or further interactions after the send. This can lead to potential reentrancy attacks where the balance could be drained.",
        "file_name": "0x06012c8cf97bead5deae237070f9587f8e7a266d.sol"
    },
    {
        "function_name": "giveBirth",
        "code": "function giveBirth(uint256 _matronId) external whenNotPaused returns(uint256) { Kitty storage matron = kitties[_matronId]; require(matron.birthTime != 0); require(_isReadyToGiveBirth(matron)); uint256 sireId = matron.siringWithId; Kitty storage sire = kitties[sireId]; uint16 parentGen = matron.generation; if (sire.generation > matron.generation) { parentGen = sire.generation; } uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1); address owner = kittyIndexToOwner[_matronId]; uint256 kittenId = _createKitty(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner); delete matron.siringWithId; pregnantKitties--; msg.sender.send(autoBirthFee); return kittenId; }",
        "vulnerability": "Improper Ether transfer handling",
        "reason": "The function attempts to send Ether back to msg.sender using the 'send' method, which only forwards 2300 gas and can fail if the recipient requires more gas. This could lead to locked funds if the transfer fails, as there is no mechanism to handle such failures within the function, resulting in the loss of the autoBirthFee.",
        "file_name": "0x06012c8cf97bead5deae237070f9587f8e7a266d.sol"
    },
    {
        "function_name": "setSecondsPerBlock",
        "code": "function setSecondsPerBlock(uint256 secs) external onlyCLevel { require(secs < cooldowns[0]); secondsPerBlock = secs; }",
        "vulnerability": "Block timestamp manipulation",
        "reason": "The function allows setting secondsPerBlock to an arbitrary value less than cooldowns[0] by a C-level executive. This can manipulate the perceived block time, impacting the cooldown calculations for breeding Kitties and potentially allowing for faster-than-intended breeding cycles, disrupting game balance and fairness.",
        "file_name": "0x06012c8cf97bead5deae237070f9587f8e7a266d.sol"
    }
]