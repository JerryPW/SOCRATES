[
    {
        "function_name": "manualSwap",
        "code": "function manualSwap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Potential Denial of Service",
        "reason": "The manualSwap function allows only _feeAddrWallet1 to call it, which means that if _feeAddrWallet1 is compromised or loses its private key, it could prevent the rightful owner from executing the swapTokensForEth function, effectively causing a denial of service for token swaps.",
        "file_name": "0x0208a9ffc97a6e96f050087ae1c9f7a2bdd3f5b0.sol"
    },
    {
        "function_name": "manualSend",
        "code": "function manualSend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Potential Denial of Service",
        "reason": "Similar to manualSwap, the manualSend function is restricted to _feeAddrWallet1. If this address is compromised, it can prevent the distribution of ETH to fee wallets, leading to a potential denial of service for fee distribution.",
        "file_name": "0x0208a9ffc97a6e96f050087ae1c9f7a2bdd3f5b0.sol"
    },
    {
        "function_name": "renounceOwnership",
        "code": "function renounceOwnership() public virtual onlyOwner { emit OwnershipTransferred(_owner, address(0)); _owner = address(0); }",
        "vulnerability": "Loss of Control",
        "reason": "The renounceOwnership function allows the owner to relinquish ownership without transferring it to another address. This leaves the contract without an owner, making it impossible to perform any owner-restricted actions in the future, such as changing parameters or recovering from an attack.",
        "file_name": "0x0208a9ffc97a6e96f050087ae1c9f7a2bdd3f5b0.sol"
    }
]