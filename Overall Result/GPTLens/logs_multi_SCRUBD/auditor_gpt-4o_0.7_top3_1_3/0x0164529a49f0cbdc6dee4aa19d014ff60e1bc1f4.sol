[
    {
        "function_name": "swapTokensForEth",
        "code": "function swapTokensForEth(uint256 tokenAmount) private {\n    address[] memory path = new address[](2);\n    path[0] = address(this);\n    path[1] = uniswapV2Router.WETH();\n    _approve(address(this), address(uniswapV2Router), tokenAmount);\n    uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n        tokenAmount,\n        0,\n        path,\n        address(this),\n        block.timestamp\n    );\n    uint256 ethBalance = address(this).balance;\n    uint256 halfShare = ethBalance.div(2);\n    payable(feeOne).transfer(halfShare);\n    payable(feeTwo).transfer(halfShare);\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function transfers ETH to external addresses `feeOne` and `feeTwo` after the swap operation. If either of these addresses is a contract with a fallback function or a receive function that performs further interactions with this contract, it may re-enter the `swapTokensForEth` function. The contract does not use reentrancy guards in this function, making it potentially vulnerable to reentrancy attacks.",
        "file_name": "0x0164529a49f0cbdc6dee4aa19d014ff60e1bc1f4.sol"
    },
    {
        "function_name": "disableBotProtectionPermanently",
        "code": "function disableBotProtectionPermanently() external onlyOwner {\n    require(isBotProtectionEnabled,\"Bot sniping has already been disabled\");\n    snipeBalances();\n    isBotProtectionEnabled = false;\n}",
        "vulnerability": "Permanent disabling of bot protection",
        "reason": "Once `disableBotProtectionPermanently` is executed by the owner, it permanently disables bot protection, and this cannot be reverted. This function does not have a mechanism to re-enable bot protection, leaving the contract open to potential bot-related abuses, such as automated front-running or sandwich attacks, especially on decentralized exchanges.",
        "file_name": "0x0164529a49f0cbdc6dee4aa19d014ff60e1bc1f4.sol"
    },
    {
        "function_name": "blockUnblockAddress",
        "code": "function blockUnblockAddress(address[] memory addresses, bool doBlock) private {\n    for (uint256 i = 0; i < addresses.length; i++) {\n        address addr = addresses[i];\n        if(doBlock) {\n            botWallets[addr] = true;\n        } else {\n            delete botWallets[addr];\n        }\n    }\n}",
        "vulnerability": "Centralized control to block/unblock addresses",
        "reason": "This function allows the owner to arbitrarily block or unblock addresses, which can potentially be misused to selectively restrict or allow trading for certain addresses. This introduces a risk of censorship or unfair treatment of users, and can impact the perceived decentralization and trust in the contract.",
        "file_name": "0x0164529a49f0cbdc6dee4aa19d014ff60e1bc1f4.sol"
    }
]