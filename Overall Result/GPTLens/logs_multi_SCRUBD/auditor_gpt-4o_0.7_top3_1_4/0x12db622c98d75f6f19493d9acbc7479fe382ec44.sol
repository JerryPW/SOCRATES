[
    {
        "function_name": "kill",
        "code": "function kill() isCreator public { selfdestruct(owner); }",
        "vulnerability": "Creator can self-destruct the contract",
        "reason": "The kill function allows the creator of the contract to call selfdestruct on the contract, sending all the ether stored in the contract to the owner's address. This is dangerous in a crowdsale context because it allows the creator to terminate the contract at any time, potentially defrauding investors by making the contract unusable and taking their funds.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    },
    {
        "function_name": "sendToken",
        "code": "function sendToken(address _to, uint256 _value) isCreator public { tokenReward.transfer(_to, _value); }",
        "vulnerability": "Creator can transfer an arbitrary amount of tokens",
        "reason": "The sendToken function allows the creator to transfer any amount of tokens to any address. This can be exploited to drain the token supply from the contract, especially if the creator is malicious, leading to loss of funds for the investors.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    },
    {
        "function_name": "setToken",
        "code": "function setToken(address _token) isCreator public { tokenReward = Token(_token); }",
        "vulnerability": "Creator can change the token contract",
        "reason": "The setToken function allows the creator to change the token contract address that the crowdsale interacts with. This can be exploited by the creator to redirect token distributions to a different token contract, potentially one they control, allowing them to manipulate or steal tokens meant for investors.",
        "file_name": "0x12db622c98d75f6f19493d9acbc7479fe382ec44.sol"
    }
]