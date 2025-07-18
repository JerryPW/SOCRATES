[
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Secret Exposure Vulnerability",
        "reason": "The function relies on a hashed secret to protect access to the treasure. However, if the hashed secret is discovered or guessed, an attacker can unlock the treasure. There is no mechanism to regenerate or update the secret after being compromised. This exposes the funds to anyone who can determine the secret off-chain.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    },
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Race Condition Vulnerability",
        "reason": "The function checks the 'isActive' flag and then transfers the entire balance to the caller before setting 'isActive' to false. If multiple transactions are submitted simultaneously with the correct secret, it can lead to a race condition where more than one successful call can transfer funds before 'isActive' is set to false.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    },
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Denial of Service via Gas Limit",
        "reason": "The function does not account for the gas limit required to transfer all DGX tokens to the caller. If the contract holds a large number of tokens, the transfer could exceed the gas limit, which would revert the transaction and prevent further execution. This allows an attacker to potentially lock the treasure by ensuring that any attempt to unlock it will always fail due to gas constraints.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    }
]