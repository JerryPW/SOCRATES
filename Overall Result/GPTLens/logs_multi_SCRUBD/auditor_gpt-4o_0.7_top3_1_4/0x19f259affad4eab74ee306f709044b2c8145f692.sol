[
    {
        "function_name": "BlacklistStatus",
        "code": "function BlacklistStatus(bool _status) external onlyOwner { blacklistMode = _status; emit BlacklistStatusChange (_status); }",
        "vulnerability": "Blacklist manipulation",
        "reason": "The owner can toggle the blacklist mode on or off at any time, which introduces a centralized risk where the owner can arbitrarily blacklist or unblacklist addresses, potentially leading to denial of service for certain users.",
        "file_name": "0x19f259affad4eab74ee306f709044b2c8145f692.sol"
    },
    {
        "function_name": "ReleaseLP",
        "code": "function ReleaseLP() external onlyOwner { IERC20 liquidityToken = IERC20(_PairAddress); uint amount = liquidityToken.balanceOf(address(this)); liquidityToken.transfer(msg.sender, amount); emit OnReleaseLP(); }",
        "vulnerability": "Liquidity pool manipulation",
        "reason": "The owner can withdraw the entire liquidity pool tokens from the contract at any time, which can severely impact the token's market liquidity and potentially lead to a rug pull situation.",
        "file_name": "0x19f259affad4eab74ee306f709044b2c8145f692.sol"
    },
    {
        "function_name": "manualBurnLPTokens",
        "code": "function manualBurnLPTokens(uint256 percent) external onlyOwner returns (bool){ require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , \"Must wait for cooldown to finish\"); require(percent <= 1000, \"May not nuke more than 10% of tokens in LP\"); lastManualLpBurnTime = block.timestamp; uint256 liquidityPairBalance = this.balanceOf(_PairAddress); uint256 amountToBurn = liquidityPairBalance * percent/10000; if (amountToBurn > 0){ _balances[burnWallet]+=amountToBurn; emit Transfer(_PairAddress,burnWallet,amountToBurn); } IDexPair pair = IDexPair(_PairAddress); pair.sync(); emit ManualNukeLP(); return true; }",
        "vulnerability": "Manual LP token burning",
        "reason": "The function allows the owner to burn up to 10% of the liquidity pool tokens every manualBurnFrequency without any oversight or consensus from the community, which could lead to significant manipulation of token supply and price.",
        "file_name": "0x19f259affad4eab74ee306f709044b2c8145f692.sol"
    }
]