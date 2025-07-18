[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom( address sender, address recipient, uint256 amount ) public override returns (bool) { _transfer(sender, recipient, amount); _approve( sender, _msgSender(), _allowances[sender][_msgSender()].sub( amount, 'ERC20: transfer amount exceeds allowance' ) ); return true; }",
        "vulnerability": "Allowance Double-Spend Race Condition",
        "reason": "The transferFrom function does not implement checks-effects-interactions pattern. It performs a transfer and then updates the allowance, creating a race condition where the spender can potentially call transferFrom multiple times before the allowance is updated, thus spending more tokens than allowed.",
        "file_name": "0x16a76a81bb2c2b16ca7b0a2ea4f093bcdf47ae7b.sol"
    },
    {
        "function_name": "sendETHToTeam",
        "code": "function sendETHToTeam(uint256 amount) private { _MCCWalletAddress.call{ value: amount.div(2) }(''); _marketingWalletAddress.call{ value: amount.div(2) }(''); }",
        "vulnerability": "Unprotected Ether Transfer",
        "reason": "The sendETHToTeam function uses low-level call to transfer Ether to the MCC and marketing wallet addresses without checking the success of these transfers. This can lead to loss of Ether if the call fails or if the destination address is a contract that reverts on receiving Ether.",
        "file_name": "0x16a76a81bb2c2b16ca7b0a2ea4f093bcdf47ae7b.sol"
    },
    {
        "function_name": "Airdrop",
        "code": "function Airdrop(AirdropReceiver[] memory recipients) external onlyOwner { for (uint256 _i = 0; _i < recipients.length; _i++) { AirdropReceiver memory _user = recipients[_i]; transferFrom(msg.sender, _user.addy, _user.amount); } }",
        "vulnerability": "Potential Gas Limit Issue",
        "reason": "The Airdrop function could potentially run out of gas if a very large array of recipients is passed. Each transferFrom call consumes gas, and with no limit set on the number of recipients, this could lead to failed transactions due to exceeding the block gas limit.",
        "file_name": "0x16a76a81bb2c2b16ca7b0a2ea4f093bcdf47ae7b.sol"
    }
]