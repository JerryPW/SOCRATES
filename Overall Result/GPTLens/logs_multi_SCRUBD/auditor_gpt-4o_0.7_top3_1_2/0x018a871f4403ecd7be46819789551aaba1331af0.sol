[
    {
        "function_name": "renounceOwnership",
        "code": "function renounceOwnership() public virtual onlyOwner { emit OwnershipTransferred(_owner, address(0)); _owner = address(0); }",
        "vulnerability": "Ownership Renouncement",
        "reason": "The function allows the current owner to renounce ownership, which sets the owner to the zero address. Once ownership is renounced, no privileged functions can be accessed by anyone, including the original owner. This creates a potential risk where the contract might become unmanageable if critical functions require owner permissions for upgrades or emergency interventions.",
        "file_name": "0x018a871f4403ecd7be46819789551aaba1331af0.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Restricted Access to Function",
        "reason": "This function can only be called by a specific address (_feeAddrWallet1). If this address is compromised or lost, the ability to execute token swaps from the contract balance could be permanently lost. Additionally, if this address is ever changed or needs to be updated, the code does not provide flexibility for that adjustment.",
        "file_name": "0x018a871f4403ecd7be46819789551aaba1331af0.sol"
    },
    {
        "function_name": "sendETHToFee",
        "code": "function sendETHToFee(uint256 amount) private { _feeAddrWallet2.transfer(amount/10*2); _feeAddrWallet1.transfer(amount/10*8); }",
        "vulnerability": "Hardcoded Fee Distribution",
        "reason": "The function hardcodes the distribution of ETH to two specific wallets. If these addresses ever need to be changed, the smart contract would need to be redeployed. This lack of flexibility could lead to operational issues if wallet addresses are compromised or need to be updated for any reason.",
        "file_name": "0x018a871f4403ecd7be46819789551aaba1331af0.sol"
    }
]