[
    {
        "function_name": "withdrawBalance",
        "code": "function withdrawBalance() external {\n    address nftAddress = address(nonFungibleContract);\n    require( msg.sender == owner || msg.sender == nftAddress );\n    bool res = nftAddress.send(this.balance);\n}",
        "vulnerability": "Improper use of send",
        "reason": "The function uses the send method to transfer Ether, which only forwards 2300 gas and does not throw an error if the transfer fails. This could lead to situations where Ether is not transferred, yet the transaction is considered successful.",
        "file_name": "0x06012c8cf97bead5deae237070f9587f8e7a266d.sol"
    },
    {
        "function_name": "giveBirth",
        "code": "function giveBirth(uint256 _matronId) external whenNotPaused returns(uint256) {\n    Kitty storage matron = kitties[_matronId];\n    require(matron.birthTime != 0);\n    require(_isReadyToGiveBirth(matron));\n    uint256 sireId = matron.siringWithId;\n    Kitty storage sire = kitties[sireId];\n    uint16 parentGen = matron.generation;\n    if (sire.generation > matron.generation) {\n        parentGen = sire.generation;\n    }\n    uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);\n    address owner = kittyIndexToOwner[_matronId];\n    uint256 kittenId = _createKitty(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner);\n    delete matron.siringWithId;\n    pregnantKitties--;\n    msg.sender.send(autoBirthFee);\n    return kittenId;\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The giveBirth function makes an external call to msg.sender.send(autoBirthFee) before updating the state variable pregnantKitties. This creates a reentrancy vulnerability where an attacker could call back into the contract before the state is updated, potentially allowing manipulation of contract state.",
        "file_name": "0x06012c8cf97bead5deae237070f9587f8e7a266d.sol"
    },
    {
        "function_name": "setSecondsPerBlock",
        "code": "function setSecondsPerBlock(uint256 secs) external onlyCLevel {\n    require(secs < cooldowns[0]);\n    secondsPerBlock = secs;\n}",
        "vulnerability": "Potential denial of service",
        "reason": "The function allows C-level executives to set the secondsPerBlock to an arbitrary value, as long as it is less than the first cooldown value. This could potentially be set to a very low number, which could disrupt the expected behavior of the contract by significantly shortening the cooldown periods, leading to unexpected contract operations and potential denial of service.",
        "file_name": "0x06012c8cf97bead5deae237070f9587f8e7a266d.sol"
    }
]