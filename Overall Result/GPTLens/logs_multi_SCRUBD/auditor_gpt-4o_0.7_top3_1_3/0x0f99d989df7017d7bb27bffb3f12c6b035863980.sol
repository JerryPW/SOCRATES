[
    {
        "function_name": "transferForeignToken",
        "code": "function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) { require(_token != address(0), \"_token address cannot be 0\"); require(_token != address(this), \"Can't withdraw native tokens\"); uint256 _contractBalance = IERC20(_token).balanceOf(address(this)); _sent = IERC20(_token).transfer(_to, _contractBalance); emit TransferForeignToken(_token, _contractBalance); }",
        "vulnerability": "Potential asset loss due to unrestricted token transfer",
        "reason": "This function allows the contract owner to transfer all tokens of any ERC20 token held by the contract to an arbitrary address. This could result in accidental or malicious transfer of tokens, leading to loss of assets for users who have deposited tokens into the contract. Additionally, there are no checks on the recipient address or the amount being transferred, increasing the risk of misuse.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    },
    {
        "function_name": "withdrawStuckETH",
        "code": "function withdrawStuckETH() external onlyOwner { require(!tradingActive, \"Can only withdraw if trading hasn't started\"); bool success; (success,) = address(msg.sender).call{value: address(this).balance}(\"\"); }",
        "vulnerability": "Risk of ETH loss before trading",
        "reason": "The function allows the contract owner to withdraw all ETH from the contract before trading is activated. This can be exploited if the owner withdraws ETH that users have mistakenly sent to the contract, causing loss of funds for the users. It is also risky because it can impact the liquidity that might be needed for the initial trading setup.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    },
    {
        "function_name": "addOnBlackList",
        "code": "function addOnBlackList(address account) public onlyOwner { require(!stopBlkListing, \"You have disabled this function\"); blackListAdd[account] = true; }",
        "vulnerability": "Centralized control over blacklisting",
        "reason": "This function allows the owner to add any address to a blacklist, effectively preventing that address from interacting with the contract. While blacklisting can be a useful feature for preventing malicious activity, the absence of any accountability or decentralized governance means that this power can be misused. It poses a risk of censorship or unfair restriction of users by the contract owner.",
        "file_name": "0x0f99d989df7017d7bb27bffb3f12c6b035863980.sol"
    }
]