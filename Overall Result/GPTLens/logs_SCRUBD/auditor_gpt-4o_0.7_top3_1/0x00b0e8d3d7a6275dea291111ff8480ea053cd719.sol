[
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Privilege Escalation",
        "reason": "The function manualswap allows the _feeAddrWallet1 address to swap all tokens in the contract for ETH. If the private key for _feeAddrWallet1 is compromised, an attacker could drain tokens from the contract by executing this function.",
        "file_name": "0x00b0e8d3d7a6275dea291111ff8480ea053cd719.sol"
    },
    {
        "function_name": "manualsend",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "vulnerability": "Privilege Escalation",
        "reason": "The function manualsend allows the _feeAddrWallet1 address to send all ETH in the contract to fee addresses. If _feeAddrWallet1's private key is compromised, an attacker could drain all ETH in the contract.",
        "file_name": "0x00b0e8d3d7a6275dea291111ff8480ea053cd719.sol"
    },
    {
        "function_name": "setBots",
        "code": "function setBots(address[] memory bots_) public onlyOwner { for (uint i = 0; i < bots_.length; i++) { bots[bots_[i]] = true; } }",
        "vulnerability": "Denial of Service via Bot Blocking",
        "reason": "The function setBots allows the owner to block addresses by marking them as bots. This can be misused to prevent legitimate users from interacting with the contract, leading to a denial of service for those users.",
        "file_name": "0x00b0e8d3d7a6275dea291111ff8480ea053cd719.sol"
    }
]