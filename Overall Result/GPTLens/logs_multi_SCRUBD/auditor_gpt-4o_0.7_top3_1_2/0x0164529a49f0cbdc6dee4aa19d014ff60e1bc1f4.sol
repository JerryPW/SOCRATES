[
    {
        "function_name": "manualSnipeBots",
        "code": "function manualSnipeBots() external { snipeBalances(); }",
        "vulnerability": "Potential Denial of Service via manual bot sniping",
        "reason": "The `manualSnipeBots` function calls `snipeBalances`, which can cause a Denial of Service (DoS) if an attacker repeatedly calls it. It could drain gas without a mechanism to limit or throttle its usage.",
        "file_name": "0x0164529a49f0cbdc6dee4aa19d014ff60e1bc1f4.sol"
    },
    {
        "function_name": "swapTokensForEth",
        "code": "function swapTokensForEth(uint256 tokenAmount) private { address[] memory path = new address[](2); path[0] = address(this); path[1] = uniswapV2Router.WETH(); _approve(address(this), address(uniswapV2Router), tokenAmount); uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens( tokenAmount, 0, path, address(this), block.timestamp ); uint256 ethBalance = address(this).balance; uint256 halfShare = ethBalance.div(2); payable(feeOne).transfer(halfShare); payable(feeTwo).transfer(halfShare); }",
        "vulnerability": "Reentrancy in swapTokensForEth",
        "reason": "The function `swapTokensForEth` transfers ETH after the token swap without securing the function against reentrancy. An attacker could potentially exploit this by manipulating ETH transfers in a reentrant call.",
        "file_name": "0x0164529a49f0cbdc6dee4aa19d014ff60e1bc1f4.sol"
    },
    {
        "function_name": "sendEth",
        "code": "function sendEth() external devOnly { uint256 ethBalance = address(this).balance; payable(deployer).transfer(ethBalance); }",
        "vulnerability": "Potential misuse of sendEth",
        "reason": "The `sendEth` function allows the deployer to withdraw all ETH from the contract. This could be exploited by malicious parties if the deployer account is compromised or intentionally malicious, leading to unauthorized fund withdrawal.",
        "file_name": "0x0164529a49f0cbdc6dee4aa19d014ff60e1bc1f4.sol"
    }
]