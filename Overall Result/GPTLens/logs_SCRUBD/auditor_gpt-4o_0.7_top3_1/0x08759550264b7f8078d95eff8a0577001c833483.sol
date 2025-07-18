[
    {
        "function_name": "redeem",
        "code": "function redeem(uint256 amount) external { uint256 share = address(this).balance.mul(amount) / pixel.totalSupply(); pixel.safeTransferFrom(msg.sender, address(this), amount); pixel.burn(amount); bool success; (success, ) = msg.sender.call{value: share, gas: 20000}(\"\"); require(success, \"Sending of ETH failed\"); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The redeem function transfers ETH to the msg.sender before updating the contract state regarding the Pixel tokens. This can allow a reentrancy attack where the attacker repeatedly calls redeem to drain the contract's ETH balance.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    },
    {
        "function_name": "buy",
        "code": "function buy() external payable { require(msg.value == price, \"Value != price\"); uint256 hodler_share = hodler == address(pixel) ? 0 : price.mul(110) / 150; bool success; (success, ) = hodler.call{value: hodler_share, gas: 20000}(\"\"); emit Buy(hodler, msg.sender, price, hodler_share); price = price.mul(150) / 100; _transferBase(msg.sender); }",
        "vulnerability": "Potential loss of ETH",
        "reason": "The buy function sends ETH to the current hodler without ensuring that the transaction succeeds. This could lead to loss of ETH if the hodler is a smart contract that rejects the transfer or runs out of gas. Additionally, it can lead to inconsistencies since the price is updated even if the transfer fails.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    },
    {
        "function_name": "_burn",
        "code": "function _burn(address user, uint256 amount) internal { require(balanceOf[user] >= amount, \"Burn too much\"); totalSupply -= amount; balanceOf[user] -= amount; emit Transfer(user, address(0), amount); }",
        "vulnerability": "Integer underflow",
        "reason": "The _burn function reduces the balance and totalSupply without sufficient checks. If the totalSupply is reduced too much, it can cause underflow in the totalSupply. Similarly, if the user's balance is reduced too much, it can cause underflow in the user's balance.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    }
]