[
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Lack of Rate Limiting on unlockTreasure",
        "reason": "The function can be called repeatedly by anyone who knows the secret until the contract's DGX balance is depleted. This lack of rate limiting allows an attacker with the correct secret to drain the contract by calling unlockTreasure multiple times before the isActive flag is set to false at the end of the function. While isActive is supposed to prevent multiple unlocks, if there is any delay or error in state update during a transaction, the attacker may exploit this timing issue.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    },
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Secret Guessing Vulnerability",
        "reason": "If the secret is poorly chosen (e.g., low entropy or predictable), an attacker could potentially guess the secret through a brute-force attack. Given enough attempts, an attacker could deduce the secret and unlock the treasure. This risk is exacerbated if there is no mechanism in place to limit the number of guesses or attempts an attacker can make.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    },
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "Race Condition on isActive Flag",
        "reason": "There exists a potential race condition where multiple transactions could be processed simultaneously, especially if the contract is deployed in an environment that supports parallel transaction processing. If two transactions call unlockTreasure at the same time before the isActive flag is set to false, both could potentially pass all the require checks and proceed with transferring the DGX balance. This could lead to an unintended double payout.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    }
]