[
    {
        "function_name": "receive",
        "code": "receive() external payable { m_IncomingEth[msg.sender] += msg.value; }",
        "vulnerability": "Potential for Unauthorized Ether Reception",
        "reason": "The receive() function allows any address to send Ether to the contract, which is then recorded in the m_IncomingEth mapping. However, there is no access control or validation of msg.sender, allowing any address to potentially manipulate the state related to incoming Ether without restrictions. This might compromise the integrity of Ether tracking within the contract.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    },
    {
        "function_name": "teamWithdraw",
        "code": "function teamWithdraw() external { require(m_TeamMember[_msgSender()]); require(m_TeamBalance[_msgSender()] > 0); payable(_msgSender()).transfer(m_TeamBalance[_msgSender()]); m_TeamBalance[_msgSender()] = 0; }",
        "vulnerability": "Potential Reentrancy Attack",
        "reason": "The teamWithdraw function transfers Ether to a team member and then sets their balance to zero. Since the external call (transfer) happens before the balance is set to zero, this opens up the potential for a reentrancy attack if the recipient's address is a contract that has a fallback function capable of making recursive calls.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    },
    {
        "function_name": "_swapTokensForETH",
        "code": "function _swapTokensForETH(uint256 _amount) private lockTheSwap { address[] memory _path = new address[](2); _path[0] = address(this); _path[1] = m_UniswapV2Router.WETH(); _approve(address(this), address(m_UniswapV2Router), _amount); m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( _amount, 0, _path, address(this), block.timestamp ); }",
        "vulnerability": "No Slippage Control in Token Swap",
        "reason": "The _swapTokensForETH function uses swapExactTokensForETHSupportingFeeOnTransferTokens with a minimum amount of 0, meaning there is no slippage protection. This could result in significant losses during the token swap if the market conditions change, or if there is a front-running attack that manipulates the price.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    }
]