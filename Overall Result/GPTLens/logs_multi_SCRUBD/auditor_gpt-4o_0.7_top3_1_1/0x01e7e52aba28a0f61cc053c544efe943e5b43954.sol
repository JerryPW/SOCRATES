[
    {
        "function_name": "sendETHToFee",
        "code": "function sendETHToFee(uint256 amount) private { _teamAddress.transfer(amount.mul(4).div(10)); _marketingFunds.transfer(amount.mul(6).div(10)); }",
        "vulnerability": "Unrestricted ETH transfer",
        "reason": "The function sendETHToFee allows unrestricted transfer of ETH to _teamAddress and _marketingFunds. If an attacker gains control over these addresses, they could drain the contract's ETH balance. Moreover, there are no checks on the contract's balance before the transfer, potentially causing a revert if the contract balance is insufficient.",
        "file_name": "0x01e7e52aba28a0f61cc053c544efe943e5b43954.sol"
    },
    {
        "function_name": "setBots",
        "code": "function setBots(address[] memory bots_) public onlyOwner { for (uint256 i = 0; i < bots_.length; i++) { bots[bots_[i]] = true; } }",
        "vulnerability": "Centralized control over bot configuration",
        "reason": "The setBots function allows the contract owner to arbitrarily mark any address as a bot, which could be used maliciously to restrict access or freeze assets of legitimate users. This centralized control poses a risk if the owner's account is compromised or if the owner acts maliciously.",
        "file_name": "0x01e7e52aba28a0f61cc053c544efe943e5b43954.sol"
    },
    {
        "function_name": "manualswap",
        "code": "function manualswap() external { require(_msgSender() == _teamAddress); uint256 contractBalance = balanceOf(address(this)); swapTokensForEth(contractBalance); }",
        "vulnerability": "Potential abuse by team address",
        "reason": "The manualswap function allows the _teamAddress to swap the entire token balance of the contract for ETH at any time. This could be abused to drain the contract's token reserves, especially if the _teamAddress is compromised or acts maliciously. This function lacks proper access control and auditing mechanisms to ensure it is used appropriately.",
        "file_name": "0x01e7e52aba28a0f61cc053c544efe943e5b43954.sol"
    }
]