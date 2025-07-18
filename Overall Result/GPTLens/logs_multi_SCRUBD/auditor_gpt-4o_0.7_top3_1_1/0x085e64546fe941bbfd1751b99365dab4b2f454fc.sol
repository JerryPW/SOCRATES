[
    {
        "function_name": "renounceOwnership",
        "code": "function renounceOwnership() public virtual onlyOwner { emit OwnershipTransferred(_owner, address(0)); _owner = address(0); }",
        "vulnerability": "Permanent Loss of Ownership",
        "reason": "The renounceOwnership function allows the current owner to set the owner address to the zero address, effectively making the contract ownerless. This is a vulnerability because it is irreversible and prevents any further owner-only actions from being executed, which might be crucial for future contract upgrades or emergency interventions.",
        "file_name": "0x085e64546fe941bbfd1751b99365dab4b2f454fc.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _teamAddress); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Potential Token Drain by Team Address",
        "reason": "The manualswap function allows the team address to swap all tokens held by the contract for ETH. This can be exploited by the team to drain all tokens from the contract, especially if the team address is compromised or acts maliciously. There are no safeguards in place to limit the amount or frequency of swaps.",
        "file_name": "0x085e64546fe941bbfd1751b99365dab4b2f454fc.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _teamAddress); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Unrestricted ETH Withdrawal by Team Address",
        "reason": "The manualsend function allows the team address to withdraw all ETH held by the contract to the specified team and marketing addresses. This creates a risk of unrestricted ETH withdrawal by the team, potentially depleting all ETH reserves of the contract if the team address is malicious or compromised.",
        "file_name": "0x085e64546fe941bbfd1751b99365dab4b2f454fc.sol"
    }
]