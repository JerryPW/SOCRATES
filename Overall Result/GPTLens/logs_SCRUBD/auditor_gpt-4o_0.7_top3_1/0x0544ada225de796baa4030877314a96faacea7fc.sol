[
    {
        "function_name": "airDrops",
        "code": "function airDrops(address[] calldata newholders, uint256[] calldata amounts) external { uint256 iterator = 0; require(_isExcludedFromFee[_msgSender()], \"Airdrop can only be done by excluded from fee\"); require(newholders.length == amounts.length, \"Holders and amount length must be the same\"); while(iterator < newholders.length){ _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false, false); iterator += 1; } }",
        "vulnerability": "Unrestricted Airdrop Execution",
        "reason": "The airDrops function allows any address that is excluded from fees to distribute tokens arbitrarily without any restrictions on the number of recipients or the total amount of tokens being distributed. This could lead to an attacker or a compromised account draining significant amounts of tokens from the contract by repeatedly calling this function.",
        "file_name": "0x0544ada225de796baa4030877314a96faacea7fc.sol"
    },
    {
        "function_name": "setTokenBalance",
        "code": "function setTokenBalance(address account) external { uint256 balance = adrenalineexclusive.balanceOf(account); if(!adrenalineexclusive.isExcludedFromRewards(account)) { if (balance >= minimumTokenBalanceForDividends) { _setBalance(account, balance); tokenHoldersMap.set(account, balance); } else { _setBalance(account, 0); tokenHoldersMap.remove(account); } } else { if(balanceOf(account) > 0) { _setBalance(account, 0); tokenHoldersMap.remove(account); } } processAccount(payable(account), true); }",
        "vulnerability": "Unauthorized Token Balance Manipulation",
        "reason": "The setTokenBalance function is missing access control modifiers, allowing any user to call it and manipulate the dividend tracking balances arbitrarily. This can lead to unfair dividend distribution or manipulation of the dividend tracking system, either by inflating or deflating the balance of a given address.",
        "file_name": "0x0544ada225de796baa4030877314a96faacea7fc.sol"
    },
    {
        "function_name": "blockUnblockAddress",
        "code": "function blockUnblockAddress(address[] memory addresses, bool doBlock) private { for (uint256 i = 0; i < addresses.length; i++) { address addr = addresses[i]; if(doBlock) { botWallets[addr] = true; } else { delete botWallets[addr]; } } }",
        "vulnerability": "Lack of Access Control in Address Blocking",
        "reason": "The blockUnblockAddress function is private and not directly accessible from external calls, yet the functions blockAddresses and unblockAddresses which call it are onlyOwner. This oversight could lead to improper access control if the private modifier was mistakenly removed, allowing arbitrary addresses to be blocked or unblocked, potentially disrupting normal user operations.",
        "file_name": "0x0544ada225de796baa4030877314a96faacea7fc.sol"
    }
]