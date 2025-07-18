[
    {
        "function_name": "renounceOwnership",
        "code": "function renounceOwnership() public virtual onlyOwner { emit OwnershipTransferred(_owner, address(0)); _owner = address(0); }",
        "vulnerability": "Irreversible Ownership Renouncement",
        "reason": "The renounceOwnership function allows the owner to set the owner to the zero address permanently. This action is irreversible and can lead to a situation where contract functions requiring the onlyOwner modifier cannot be executed anymore, potentially locking critical contract functionality.",
        "file_name": "0x11566f832f90155701384e42f0adcdc889767bbc.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _teamAddress); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Potentially Unrestricted Access",
        "reason": "The manualswap function allows the _teamAddress to swap the entire token balance of the contract for ETH. If the _teamAddress is compromised or mismanaged, this could lead to draining of tokens without any broader community oversight or control mechanisms.",
        "file_name": "0x11566f832f90155701384e42f0adcdc889767bbc.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _teamAddress); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Centralized Control of Funds",
        "reason": "The manualsend function allows the _teamAddress to transfer the entire ETH balance of the contract to the team and marketing addresses. This creates a central point of failure, where if the _teamAddress is compromised, it can lead to a total loss of funds designated for the team and marketing.",
        "file_name": "0x11566f832f90155701384e42f0adcdc889767bbc.sol"
    }
]