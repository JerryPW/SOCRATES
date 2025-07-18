[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint wad) public { require(balanceOf[msg.sender] >= wad, \"not enough\"); balanceOf[msg.sender] -= wad; msg.sender.transfer(wad); emit Withdrawal(msg.sender, wad); }",
        "vulnerability": "Reentrancy",
        "reason": "The withdraw function transfers ether to the caller before updating the balance mapping. This allows for a reentrancy attack where an attacker could repeatedly call withdraw before the balance is updated, allowing them to drain the contract.",
        "file_name": "0x0461c4e4b916bfc9449f853c7a854033b43c3a6c.sol"
    },
    {
        "function_name": "receive",
        "code": "receive() external payable { ( address head, uint256 last, uint256 plays, uint256 loops ) = getData(); uint256 delta = block.timestamp.sub(last); if (delta <= PERIOD) { uint256 cost = costFor(plays, delta); require(msg.value >= cost, \"more (\uffe3\ufe43\uffe3)\"); setData(msg.sender, block.timestamp, plays + 1, loops); mint(head, 1 ether / loops); emit Poof(); msg.sender.call{ value: msg.value - cost }(\"\"); return; } require(msg.value == 0, \"wait\"); uint256 total = address(this).balance; uint256 fee = total.mul(FEE) / BASE; (bool success1,) = FEE_RECIPIENT_1.call{ value: fee}(\"\"); (bool success2,) = FEE_RECIPIENT_2.call{ value: fee}(\"\"); require(success1 && success2, \"Error sending fees\"); emit NotPoof(head, total); setData(address(this), block.timestamp, 0, loops + 1); if (head != address(this)) { uint256 send = address(this).balance.sub(fee); WRAPPED_ETH.deposit.value(send)(); WRAPPED_ETH.transfer(head, send); } }",
        "vulnerability": "Reentrancy",
        "reason": "The receive function in the Poof contract makes a call using call.value() without checking for reentrancy. An attacker could exploit this by calling the contract recursively and draining funds.",
        "file_name": "0x0461c4e4b916bfc9449f853c7a854033b43c3a6c.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address src, address dst, uint wad) public returns (bool) { require(balanceOf[src] >= wad, \"little balance\"); if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) { require(allowance[src][msg.sender] >= wad, \"not allowed\"); allowance[src][msg.sender] -= wad; } balanceOf[src] -= wad; balanceOf[dst] += wad; emit Transfer(src, dst, wad); return true; }",
        "vulnerability": "Integer Underflow",
        "reason": "The transferFrom function in the WETH contract does not use SafeMath for subtraction operations. This could lead to integer underflow when reducing balances or allowances, allowing attackers to manipulate balances.",
        "file_name": "0x0461c4e4b916bfc9449f853c7a854033b43c3a6c.sol"
    }
]