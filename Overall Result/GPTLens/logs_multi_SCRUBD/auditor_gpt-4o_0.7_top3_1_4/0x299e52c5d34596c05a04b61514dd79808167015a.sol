[
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "No replay protection",
        "reason": "The unlockTreasure function can be called multiple times before it is set to inactive if the secret is leaked or guessed. This means that if the secret becomes known, an attacker could call the function multiple times during the same transaction block, potentially receiving multiple transfers of DGX before the contract is set to inactive.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    },
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Potential race condition",
        "reason": "The function sets isActive to false only after transferring the DGX balance. In a situation where multiple transactions are included in the same block, it is possible that multiple calls to unlockTreasure could succeed before the contract's state is updated to inactive, allowing multiple transfers of DGX to occur.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    },
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Secret exposure risk",
        "reason": "The function relies on a hashed secret for security, but if the secret is exposed or guessed, the entire balance of the contract can be drained immediately. There is no mechanism to change the secret or to limit the number of attempts to guess the secret, making brute-force or exposure attacks highly threatening.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    }
]