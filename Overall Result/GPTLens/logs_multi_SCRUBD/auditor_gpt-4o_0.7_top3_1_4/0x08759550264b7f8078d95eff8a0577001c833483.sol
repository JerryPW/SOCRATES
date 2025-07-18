[
    {
        "function_name": "buy",
        "code": "function buy() external payable { require(msg.value == price, \"Value != price\"); uint256 hodler_share = hodler == address(pixel) ? 0 : price.mul(110) / 150; bool success; (success, ) = hodler.call{value: hodler_share, gas: 20000}(\"\"); emit Buy(hodler, msg.sender, price, hodler_share); price = price.mul(150) / 100; _transferBase(msg.sender); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `buy` allows sending ETH to an arbitrary `hodler` address using a low-level call, which can be exploited for reentrancy attacks. The price update and transfer of ownership happen after the external call, leaving the contract state vulnerable to reentrancy if the `hodler` is a smart contract with a fallback function that can call `buy` again.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    },
    {
        "function_name": "_burn",
        "code": "function _burn(address user, uint256 amount) internal { require(balanceOf[user] >= amount, \"Burn too much\"); totalSupply -= amount; balanceOf[user] -= amount; emit Transfer(user, address(0), amount); }",
        "vulnerability": "Unchecked subtraction",
        "reason": "The function `_burn` reduces the `balanceOf[user]` and `totalSupply` without checking for potential underflows. Although the `require` statement ensures that `balanceOf[user]` is sufficient before proceeding, it does not prevent the `totalSupply` from underflowing in a scenario where the `totalSupply` does not correctly reflect the sum of all balances due to prior errors or manipulations in the contract.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    },
    {
        "function_name": "redeem",
        "code": "function redeem(uint256 amount) external { uint256 share = address(this).balance.mul(amount) / pixel.totalSupply(); pixel.safeTransferFrom(msg.sender, address(this), amount); pixel.burn(amount); bool success; (success, ) = msg.sender.call{value: share, gas: 20000}(\"\"); require(success, \"Sending of ETH failed\"); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `redeem` sends ETH to `msg.sender` using a low-level call after transferring and burning tokens. This sequence allows for a reentrancy attack if `msg.sender` is a contract with a fallback function that can interact with the contract, particularly if there are other functions that can be called before the state is fully updated or locked.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    }
]