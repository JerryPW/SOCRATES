[
    {
        "function_name": "transferForeignToken",
        "code": "function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) { require(_token != address(0), \"_token address cannot be 0\"); require(_token != address(this), \"Can't withdraw native tokens\"); uint256 _contractBalance = IERC20(_token).balanceOf(address(this)); _sent = IERC20(_token).transfer(_to, _contractBalance); emit TransferForeignToken(_token, _contractBalance); }",
        "vulnerability": "Lack of access control",
        "reason": "The function allows the owner to transfer any ERC20 tokens that are sent to the contract to any address. This could be exploited by a malicious owner to transfer all tokens to themselves or another address without the consent of the token holders. There are no checks to restrict the amount or the conditions under which tokens can be transferred.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { require(!tradingActive, \"Can only withdraw if trading hasn't started\"); bool success; (success,) = address(msg.sender).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Potential misuse by owner",
        "reason": "This function allows the owner to withdraw all Ether from the contract under the condition that trading has not started. If this function is misused, it could lead to significant loss of funds for the users who have deposited Ether into the contract before trading starts. Although restricted by the `tradingActive` condition, there is no safeguard against the owner manipulating the trading status.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    },
    {
        "function_name": "addOnBlackList",
        "code": "function addOnBlackList(address account) public onlyOwner { require(!stopBlkListing, \"You have disabled this function\"); blackListAdd[account] = true; }",
        "vulnerability": "Arbitrary blacklisting",
        "reason": "The function allows the owner to arbitrarily add any address to a blacklist, which could prevent that address from participating in transactions. This could be exploited by a malicious owner to target specific users or competitors, effectively freezing their ability to transact with the token. Although there is a `stopBlkListing` flag to disable this function, it remains a centralization risk.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    }
]