[
    {
        "function_name": "withdrawERC20",
        "code": "function withdrawERC20(IERC20 token) external onlyOwner { uint256 balance = token.balanceOf(address(this)); bool sent = token.transfer(msg.sender, balance); require(sent, \"Failed to send token\"); }",
        "vulnerability": "ERC20 token draining by owner",
        "reason": "The `withdrawERC20` function allows the contract owner to transfer any ERC20 token from the contract to their own address. This could be exploited by the owner to drain tokens that might have been sent to the contract by mistake, or to maliciously remove tokens without the consent of token holders.",
        "file_name": "0x2fd4f0569896b4009ffad793ac6308bfd79b4c35.sol"
    },
    {
        "function_name": "withdrawETH",
        "code": "function withdrawETH() external onlyOwner { uint256 balance = address(this).balance; _sendViaCall(payable(msg.sender), balance); }",
        "vulnerability": "Ether draining by owner",
        "reason": "The `withdrawETH` function allows the owner to withdraw all Ether held by the contract to their own address. This centralizes control and poses a risk that the owner can drain all Ether from the contract, potentially defrauding users who have sent Ether to the contract for legitimate purposes.",
        "file_name": "0x2fd4f0569896b4009ffad793ac6308bfd79b4c35.sol"
    },
    {
        "function_name": "manualSendToken",
        "code": "function manualSendToken() external onlyOwner{ IERC20(address(this)).transfer(msg.sender, balanceOf(address(this))); }",
        "vulnerability": "Token balance withdrawal by owner",
        "reason": "The `manualSendToken` function allows the owner to transfer all of the contract's own token balance to themselves. This can be exploited to remove liquidity or defraud investors who believe their tokens are safely locked within the contract.",
        "file_name": "0x2fd4f0569896b4009ffad793ac6308bfd79b4c35.sol"
    }
]