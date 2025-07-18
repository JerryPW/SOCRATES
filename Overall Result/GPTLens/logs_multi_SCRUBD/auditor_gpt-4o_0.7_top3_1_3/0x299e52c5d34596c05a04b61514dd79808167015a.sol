[
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Secret Brute-forcing",
        "reason": "The contract uses a simple hash comparison to validate the secret, which can be brute-forced by an attacker with sufficient resources. Given that the secret is a single value with no additional obfuscation, an attacker could repeatedly call unlockTreasure with different guesses, especially if the secret has low entropy, until they find the correct secret and drain the contract's DGX balance.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    },
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Lack of Access Control",
        "reason": "There is no restriction on who can call the unlockTreasure function. This means that anyone who knows the secret can call it and transfer all DGX tokens to themselves. Without proper access control mechanisms, such as owner-only access or multi-signature requirements, any user who guesses the secret can exploit this to steal all funds.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    },
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Race Condition",
        "reason": "The isActive flag is set to false only after transferring the DGX balance. This introduces a race condition where multiple transactions could be mined in the same block before isActive is set to false, potentially allowing multiple users to successfully execute the unlockTreasure function in parallel and claim DGX tokens multiple times.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    }
]