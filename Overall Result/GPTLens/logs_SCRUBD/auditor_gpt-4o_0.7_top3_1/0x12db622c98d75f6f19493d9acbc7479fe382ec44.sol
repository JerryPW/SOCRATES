[
    {
        "function_name": "setToken",
        "code": "function setToken(address _token) isCreator public { tokenReward = Token(_token); }",
        "vulnerability": "Token address can be changed",
        "reason": "The function `setToken` allows the creator to change the token address at any time, potentially redirecting token transfers to a malicious contract. This could lead to loss of tokens for participants, as they would be transferred to an address controlled by an attacker.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    },
    {
        "function_name": "sendToken",
        "code": "function sendToken(address _to, uint256 _value) isCreator public { tokenReward.transfer(_to, _value); }",
        "vulnerability": "Unrestricted token transfer",
        "reason": "The `sendToken` function allows the creator to transfer any amount of tokens to any address without restriction. An attacker with creator privileges could exploit this to drain the contract of tokens, leading to significant losses for the participants and undermining the integrity of the crowdsale.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    },
    {
        "function_name": "kill",
        "code": "function kill() isCreator public { selfdestruct(owner); }",
        "vulnerability": "Destruction of contract",
        "reason": "The `kill` function allows the creator to destruct the contract at any time, sending all ether held by the contract to the owner. This could be exploited by a malicious creator to prematurely end the crowdsale and steal funds, resulting in financial losses for participants who have already contributed.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    }
]