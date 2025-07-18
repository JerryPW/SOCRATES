[
    {
        "function_name": "sendEthToDev",
        "code": "function sendEthToDev(uint256 amount) private { address payable _buyBackAddress = payable(0x72C935abeB07a955F9d9B881A784cECbcC3997Fb); address payable _marketingAddress = payable(0x87AC09056fd909DDB7E1398Bb4DcF0b0B7d473C0); address payable _oppAddress = payable(0x76bC307F0B562C417025E0A3290b3496Dc6Bae1F); address payable _teamFeeAddress = payable(0xB701e71805cEeEBD5caFF976945AFa855Dc56a3A); _buyBackAddress.transfer(amount.div(3)); _marketingAddress.transfer(amount.div(3)); uint256 oppFeeAndTeamFee = amount.div(3); uint256 teamFee = oppFeeAndTeamFee.div(4); uint256 oppFee = oppFeeAndTeamFee.sub(teamFee); _oppAddress.transfer(oppFee); _teamFeeAddress.transfer(teamFee); }",
        "vulnerability": "Hardcoded addresses for fund transfers",
        "reason": "The function uses hardcoded addresses for transferring funds which makes it difficult to update or change the addresses in case of changes in the organization or team members. This can also lead to loss of funds if any of the addresses become invalid or compromised.",
        "file_name": "0x119f4c9de5539fd053aed5091db4ba59f83330d7.sol"
    },
    {
        "function_name": "swapAndSendToDev",
        "code": "function swapAndSendToDev(uint256 tokens) private { uint256 tokenBalance = tokens; uint256 initialBalance = address(this).balance; swapTokensForEth(tokenBalance); uint256 newBalance = address(this).balance.sub(initialBalance); sendEthToDev(newBalance); emit SwapAndSendToDev(tokens, newBalance); }",
        "vulnerability": "Lack of slippage protection in swaps",
        "reason": "The function performs token swaps without accounting for slippage. This can lead to significant loss of funds if the market conditions change unfavorably between the time the transaction is initiated and when it is processed.",
        "file_name": "0x119f4c9de5539fd053aed5091db4ba59f83330d7.sol"
    },
    {
        "function_name": "processAccount",
        "code": "function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) { uint256 amount = _withdrawDividendOfUser(account); if (amount > 0) { lastClaimTimes[account] = block.timestamp; emit Claim(account, amount, automatic); return true; } return false; }",
        "vulnerability": "Centralization risk due to owner-only access",
        "reason": "This function can only be executed by the contract owner, which poses a centralization risk. If the owner's key is compromised, an attacker could drain all dividends from the contract.",
        "file_name": "0x119f4c9de5539fd053aed5091db4ba59f83330d7.sol"
    }
]