[
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "lack of reentrancy protection",
        "reason": "The unlockTreasure function transfers tokens to the user and then sets isActive to false. This sequence allows for a reentrancy attack if the DGX token's transfer function interacts with a malicious contract. The attacker can repeatedly call unlockTreasure before isActive is set to false, draining the contract's balance.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    },
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "single attempt unlocking",
        "reason": "The unlockTreasure function sets isActive to false after one successful call, meaning the treasure can only be unlocked once. If the hashed secret is accidentally leaked or discovered by an attacker before the intended recipient can unlock it, the attacker can permanently drain the contract, making it impossible for the intended user to claim the treasure.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    },
    {
        "function_name": "unlockTreasure",
        "code": "function unlockTreasure(bytes32 _secret) public { require(isActive, \"treasure inactive\"); require(keccak256(abi.encodePacked(_secret)) == hashedSecret, \"incorrect secret\"); uint256 _dgxBalance = IERC20(DGX_TOKEN_ADDRESS).balanceOf(address(this)); require(IERC20(DGX_TOKEN_ADDRESS).transfer(msg.sender, _dgxBalance), \"could not transfer DGX\"); isActive = false; }",
        "vulnerability": "unverified DGX token address",
        "reason": "The constructor accepts an arbitrary DGX_TOKEN_ADDRESS without verifying its authenticity. An attacker could deploy a malicious contract that implements the IERC20 interface and specify its address as DGX_TOKEN_ADDRESS to exploit the transfer function, allowing arbitrary code execution during the token transfer process.",
        "file_name": "0x299e52c5d34596c05a04b61514dd79808167015a.sol"
    }
]