[
    {
        "function_name": "buy",
        "code": "function buy() external payable { require(msg.value == price, \"Value != price\"); uint256 hodler_share = hodler == address(pixel) ? 0 : price.mul(110) / 150; bool success; (success, ) = hodler.call{value: hodler_share, gas: 20000}(\"\"); emit Buy(hodler, msg.sender, price, hodler_share); price = price.mul(150) / 100; _transferBase(msg.sender); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `buy` function allows an external call to `hodler` before updating the state variable `price`, leading to potential reentrancy attacks. An attacker could exploit this by recursively calling the `buy` function, manipulating the contract's state to buy at a stale price or drain funds.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    },
    {
        "function_name": "redeem",
        "code": "function redeem(uint256 amount) external { uint256 share = address(this).balance.mul(amount) / pixel.totalSupply(); pixel.safeTransferFrom(msg.sender, address(this), amount); pixel.burn(amount); bool success; (success, ) = msg.sender.call{value: share, gas: 20000}(\"\"); require(success, \"Sending of ETH failed\"); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `redeem` function performs an external call to `msg.sender` before fully updating the contract\u2019s state. This external call can be exploited by attackers using a reentrancy attack to call `redeem` again before the state is updated, potentially draining the contract's ETH balance.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address spender, uint256 amount) public override returns (bool) { allowance[msg.sender][spender] = amount; emit Approval(msg.sender, spender, amount); return true; }",
        "vulnerability": "Race condition / Double spend vulnerability",
        "reason": "The `approve` function does not follow the checks-effects-interactions pattern and directly sets the allowance to a new value without checking the current allowance. This can lead to race conditions where an attacker can exploit the gap between the current allowance being spent and the new allowance being set, potentially leading to double spending.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    }
]