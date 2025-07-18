[
    {
        "function_name": "buy",
        "code": "function buy() external payable { require(msg.value == price, \"Value != price\"); uint256 hodler_share = hodler == address(pixel) ? 0 : price.mul(110) / 150; bool success; (success, ) = hodler.call{value: hodler_share, gas: 20000}(\"\"); emit Buy(hodler, msg.sender, price, hodler_share); price = price.mul(150) / 100; _transferBase(msg.sender); }",
        "vulnerability": "Reentrancy",
        "reason": "The `buy` function performs an external call to the `hodler` address with a fixed amount of gas before updating the contract state. This makes the contract vulnerable to reentrancy attacks where the `hodler` can reenter the `buy` function through a fallback function, causing multiple transfers of the token without updating the price.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    },
    {
        "function_name": "_burn",
        "code": "function _burn(address user, uint256 amount) internal { require(balanceOf[user] >= amount, \"Burn too much\"); totalSupply -= amount; balanceOf[user] -= amount; emit Transfer(user, address(0), amount); }",
        "vulnerability": "Unchecked math operations",
        "reason": "The `_burn` function does not check for underflows when subtracting the `amount` from `balanceOf[user]` and `totalSupply`. If an attacker can manipulate the `balanceOf` or `totalSupply` to be lower than `amount`, this could lead to an integer underflow and allow burning more tokens than intended.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    },
    {
        "function_name": "redeem",
        "code": "function redeem(uint256 amount) external { uint256 share = address(this).balance.mul(amount) / pixel.totalSupply(); pixel.safeTransferFrom(msg.sender, address(this), amount); pixel.burn(amount); bool success; (success, ) = msg.sender.call{value: share, gas: 20000}(\"\"); require(success, \"Sending of ETH failed\"); }",
        "vulnerability": "Reentrancy",
        "reason": "The `redeem` function is vulnerable to reentrancy because it transfers ETH to an external address before updating the state. If the `msg.sender` is a contract, it can reenter the `redeem` function and manipulate state variables or execute further withdrawals.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    }
]