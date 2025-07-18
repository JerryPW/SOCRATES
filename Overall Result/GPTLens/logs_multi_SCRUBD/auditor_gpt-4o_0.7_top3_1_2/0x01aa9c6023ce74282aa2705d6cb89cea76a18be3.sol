[
    {
        "function_name": "renounceOwnership",
        "code": "function renounceOwnership() public virtual onlyOwner { emit OwnershipTransferred(_owner, address(0)); _owner = address(0); }",
        "vulnerability": "Permanent loss of ownership",
        "reason": "The `renounceOwnership` function allows the current owner to set the owner to the zero address, effectively making the contract ownerless. This prevents any further calls to functions that are protected by the `onlyOwner` modifier, which could be critical for contract maintenance and updates, potentially leading to loss of control over the contract.",
        "file_name": "0x01aa9c6023ce74282aa2705d6cb89cea76a18be3.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Privileged access control",
        "reason": "The `manualswap` function can only be called by `_feeAddrWallet1`, which could be a single point of failure. If the private key associated with `_feeAddrWallet1` is compromised, an attacker could exploit this function to swap all tokens held by the contract for ETH, potentially draining the contract\u2019s resources.",
        "file_name": "0x01aa9c6023ce74282aa2705d6cb89cea76a18be3.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Privileged access control",
        "reason": "Similar to `manualswap`, the `manualsend` function can only be executed by `_feeAddrWallet1`. If `_feeAddrWallet1` is compromised, an attacker can send the entire ETH balance of the contract to the designated fee addresses, leading to a potential loss of funds.",
        "file_name": "0x01aa9c6023ce74282aa2705d6cb89cea76a18be3.sol"
    }
]