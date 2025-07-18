[
    {
        "function_name": "claimTokenBonus",
        "code": "function claimTokenBonus(address _buyer) internal { require( now > endTime ); require( tokenUser[_buyer] > 0 ); uint256 bonusApplied = 0; for (uint i = 0; i < tokenThreshold.length; i++) { if ( soldTokens > tokenThreshold[i] ) { bonusApplied = bonusThreshold[i]; } } require( bonusApplied > 0 ); uint256 addTokenAmount = tokenUser[_buyer].mul( bonusApplied ).div(10**2); tokenUser[_buyer] = 0; tokenSaleContract.claim(_buyer, addTokenAmount); _buyer.transfer(msg.value); }",
        "vulnerability": "Incorrect Ether refund",
        "reason": "In the `claimTokenBonus` function, after the bonus tokens are calculated and transferred, the function unexpectedly attempts to transfer `msg.value` back to `_buyer`. However, `msg.value` should always be zero since this function is not payable and doesn't accept Ether when called directly. An attacker could exploit this by calling the fallback function with Ether, then calling `claimTokenBonus` to drain funds from the contract.",
        "file_name": "0x07c1c8c2bce6290daa554118b7d208041615ce54.sol"
    },
    {
        "function_name": "refundEther",
        "code": "function refundEther(address to) public onlyTokenSaleOwner { to.transfer(etherUser[to]); etherUser[to] = 0; pendingTokenUser[to] = 0; }",
        "vulnerability": "Potential for Ether loss due to re-entrancy",
        "reason": "The `refundEther` function transfers Ether to a user and then sets their `etherUser` balance to zero. If an attacker is able to use a fallback function to re-enter before the balance is set to zero, they could potentially withdraw more Ether than intended. This is a classic re-entrancy vulnerability.",
        "file_name": "0x07c1c8c2bce6290daa554118b7d208041615ce54.sol"
    },
    {
        "function_name": "buyImplementation",
        "code": "function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s) private returns (bool) { bytes32 hash = sha256(\"Eidoo icoengine authorization\", address(0), buyerAddress, buyerId, maxAmount); address signer = ecrecover(hash, v, r, s); if (!isKycSigner[signer]) { revert(); } else { uint256 totalPayed = alreadyPayed[buyerId].add(msg.value); require(totalPayed <= maxAmount); alreadyPayed[buyerId] = totalPayed; emit KycVerified(signer, buyerAddress, buyerId, maxAmount); return releaseTokensTo(buyerAddress); } }",
        "vulnerability": "Replay attack due to hash collision",
        "reason": "The `buyImplementation` function generates a hash using the fixed string \"Eidoo icoengine authorization\" and other parameters. If the same parameters are reused, the hash value will be the same, allowing a potential replay attack. An attacker could reuse the signature to call this function multiple times if the same buyer and parameters are used, potentially allowing unauthorized token purchases.",
        "file_name": "0x07c1c8c2bce6290daa554118b7d208041615ce54.sol"
    }
]