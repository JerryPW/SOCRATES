[
    {
        "function_name": "redeem",
        "code": "function redeem(uint256 amount) external { uint256 share = address(this).balance.mul(amount) / pixel.totalSupply(); pixel.safeTransferFrom(msg.sender, address(this), amount); pixel.burn(amount); bool success; (success, ) = msg.sender.call{value: share, gas: 20000}(\"\"); require(success, \"Sending of ETH failed\"); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "In the redeem function, the contract sends Ether to the caller before updating the state (burning the Pixel tokens). This could allow an attacker to exploit the function using a reentrancy attack, repeatedly calling redeem before the balance is updated, and draining the contract's funds.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    },
    {
        "function_name": "buy",
        "code": "function buy() external payable { require(msg.value == price, \"Value != price\"); uint256 hodler_share = hodler == address(pixel) ? 0 : price.mul(110) / 150; bool success; (success, ) = hodler.call{value: hodler_share, gas: 20000}(\"\"); emit Buy(hodler, msg.sender, price, hodler_share); price = price.mul(150) / 100; _transferBase(msg.sender); }",
        "vulnerability": "Potential Denial of Service",
        "reason": "The buy function uses a low gas limit (20000) for the call to hodler. If the hodler is a contract with a fallback function that requires more than 20000 gas, the transaction will fail. This can prevent the buy function from being executed, leading to a denial of service for legitimate users.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address spender, uint256 amount) public override returns (bool) { allowance[msg.sender][spender] = amount; emit Approval(msg.sender, spender, amount); return true; }",
        "vulnerability": "Race Condition in Approve",
        "reason": "The approve function does not mitigate the race condition issue where the spender can perform a transaction (e.g., transferFrom) just before the owner changes the allowance. This could lead to the spender using both the old and new allowances, effectively allowing double spending.",
        "file_name": "0x08759550264b7f8078d95eff8a0577001c833483.sol"
    }
]