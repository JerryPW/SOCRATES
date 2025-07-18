[
    {
        "function_name": "claimFarmedToken",
        "code": "function claimFarmedToken( address addr, address tkn, uint8 slot ) private { if (slot == 1) { require(isAuthorized[addr], \"You cant retrieve it\"); } require(!_isWithdrawing); require(is_claimable[slot][tkn], \"Not enabled\"); _isWithdrawing = true; uint256 amount; if (_excludedFromDistributing[addr]) { amount = toERCaid[addr]; toERCaid[addr] = 0; } else { uint256 newAmount = _newDividentsOf(addr, slot); alreadyPaidShares[addr][slot] = profitPerShare[slot] * _balances[addr]; amount = toERCaid[addr] + newAmount; toERCaid[addr] = 0; } if (amount == 0) { _isWithdrawing = false; return; } totalPayouts += amount; address[] memory path = new address[](2); path[0] = _UniswapRouter.WETH(); path[1] = tkn; _UniswapRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: amount }(0, path, addr, block.timestamp); emit OnWithdrawFarmedToken(amount, addr); _isWithdrawing = false; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function does not utilize the 'safe' modifier which should have been used to prevent reentrancy attacks. The state change '_isWithdrawing = true;' is set before the external call to '_UniswapRouter.swapExactETHForTokensSupportingFeeOnTransferTokens' which can lead to a reentrancy attack where an attacker could repeatedly call this function to drain funds.",
        "file_name": "0x0719feee345bf34877d0a1f2c1c40fcdf0f1c3e8.sol"
    },
    {
        "function_name": "ControlRemoveRemainingETH",
        "code": "function ControlRemoveRemainingETH() public onlyAuth { (bool sent, ) = owner.call{value: (address(this).balance)}(\"\"); require(sent); }",
        "vulnerability": "Unsafe use of call() without proper checks",
        "reason": "The use of 'call' without proper error handling can lead to vulnerabilities if the call fails. The function only checks if 'sent' is true, but doesn't properly handle cases where the call fails. This can result in the function not behaving as intended and the contract's balance being stuck.",
        "file_name": "0x0719feee345bf34877d0a1f2c1c40fcdf0f1c3e8.sol"
    },
    {
        "function_name": "airdropAddressesNative",
        "code": "function airdropAddressesNative(address[] memory addys) public payable onlyAuth { uint256 qty = msg.value; uint256 single_drop = qty / addys.length; bool sent; for (uint256 i; i <= (addys.length - 1); i++) { sent = payable(addys[i]).send(single_drop); require(sent); sent = false; } }",
        "vulnerability": "Gas limit risk with send()",
        "reason": "Using 'send' to transfer Ether imposes a gas limit of 2300. If the recipient is a contract that requires more than 2300 gas to execute its fallback function, the Ether transfer will fail. This can prevent the airdrop from completing successfully.",
        "file_name": "0x0719feee345bf34877d0a1f2c1c40fcdf0f1c3e8.sol"
    }
]