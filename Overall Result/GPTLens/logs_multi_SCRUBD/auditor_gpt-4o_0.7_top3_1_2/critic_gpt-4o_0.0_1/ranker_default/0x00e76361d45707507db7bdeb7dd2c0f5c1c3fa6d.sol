[
    {
        "function_name": "manualswap",
        "vulnerability": "Potential abuse of manual swap function",
        "criticism": "The reasoning is correct in identifying that the 'manualswap' function can be abused if '_feeAddrWallet1' is compromised. The function allows the designated address to swap all tokens held by the contract for ETH, which could negatively impact token holders if misused. The severity is moderate because it depends on the security of the '_feeAddrWallet1' address. The profitability is moderate as well, as an attacker with control over '_feeAddrWallet1' could potentially profit by draining the contract's tokens.",
        "correctness": 8,
        "severity": 5,
        "profitability": 5,
        "reason": "The 'manualswap' function can only be called by the address '_feeAddrWallet1', allowing it to swap all tokens held by the contract for ETH. If '_feeAddrWallet1' is compromised or misused, it could drain all tokens in the contract, affecting token holders negatively.",
        "code": "function manualswap() external { require(_msgSender() == _feeAddrWallet1); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol",
        "final_score": 6.5
    },
    {
        "function_name": "manualsend",
        "vulnerability": "Potential abuse of manual send function",
        "criticism": "The reasoning is accurate in highlighting the risk associated with the 'manualsend' function. Similar to 'manualswap', this function allows '_feeAddrWallet1' to transfer all ETH held by the contract, which could be exploited if the address is compromised. The severity is moderate due to the reliance on the security of '_feeAddrWallet1'. The profitability is moderate, as an attacker could withdraw all ETH from the contract if they gain control over the address.",
        "correctness": 8,
        "severity": 5,
        "profitability": 5,
        "reason": "Similar to 'manualswap', the 'manualsend' function allows '_feeAddrWallet1' to transfer all ETH balance held by the contract to designated fee addresses. This could be exploited if the controlling address is compromised, leading to unauthorized withdrawal of funds.",
        "code": "function manualsend() external { require(_msgSender() == _feeAddrWallet1); uint256 contractETHBalance = address(this).balance; sendETHToFee(contractETHBalance); }",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol",
        "final_score": 6.5
    },
    {
        "function_name": "removeStrictTxLimit",
        "vulnerability": "Unlimited transaction size by owner",
        "criticism": "The reasoning correctly identifies that the 'removeStrictTxLimit' function allows the owner to set the maximum transaction amount to the total supply, effectively removing any transaction limit. This could be exploited by the owner to perform large transfers, potentially affecting the market or token price. The severity is moderate because it depends on the owner's intentions. The profitability is low for external attackers, as only the owner can exploit this function.",
        "correctness": 8,
        "severity": 5,
        "profitability": 2,
        "reason": "The 'removeStrictTxLimit' function allows the owner to set the maximum transaction amount to the total supply, effectively removing any transaction limit. This could be exploited by the owner to perform large transfers, potentially manipulating the market or executing large trades that could adversely affect the token's price.",
        "code": "function removeStrictTxLimit() public onlyOwner { _maxTxAmount = 1e12 * 10**9; }",
        "file_name": "0x00e76361d45707507db7bdeb7dd2c0f5c1c3fa6d.sol",
        "final_score": 5.75
    }
]