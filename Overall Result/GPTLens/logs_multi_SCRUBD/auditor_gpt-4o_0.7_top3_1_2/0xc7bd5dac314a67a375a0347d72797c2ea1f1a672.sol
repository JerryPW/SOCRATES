[
    {
        "function_name": "claimGasDrop",
        "code": "function claimGasDrop() public returns(bool) { if(receivers[msg.sender] != true) { if(amountToClaim <= balances[whoSent]) { balances[whoSent] -= amountToClaim; IERC20(currentTokenAddress).transfer(msg.sender, amountToClaim); receivers[msg.sender] = true; totalSent += amountToClaim; } } }",
        "vulnerability": "Reentrancy",
        "reason": "The claimGasDrop function allows a user to claim tokens without updating the state before the external transfer call. This opens up the potential for a reentrancy attack where an attacker can recursively call claimGasDrop before the state change, allowing them to drain the balance.",
        "file_name": "0xc7bd5dac314a67a375a0347d72797c2ea1f1a672.sol"
    },
    {
        "function_name": "deposit",
        "code": "function deposit(uint tokens) public onlyOwner { balances[msg.sender]+= tokens; IERC20(currentTokenAddress).transferFrom(msg.sender, address(this), tokens); whoSent = msg.sender; }",
        "vulnerability": "Incorrect balance update order",
        "reason": "In the deposit function, the balance is updated before the actual transfer of tokens. If the transferFrom call fails, the balance would still be incremented, resulting in an incorrect internal balance state. This could potentially be manipulated by the owner to reflect a higher balance than what is actually transferred.",
        "file_name": "0xc7bd5dac314a67a375a0347d72797c2ea1f1a672.sol"
    },
    {
        "function_name": "setCurrentToken",
        "code": "function setCurrentToken(address currentTokenContract) external onlyOwner { currentTokenAddress = currentTokenContract; currentToken = IERC20(currentTokenContract); dappBalance = currentToken.balanceOf(address(this)); }",
        "vulnerability": "Unrestricted token contract change",
        "reason": "The setCurrentToken function allows the owner to change the token contract address at any time. This means the owner can switch to a malicious token contract that could have unintended or harmful behaviors, affecting all users interacting with the contract.",
        "file_name": "0xc7bd5dac314a67a375a0347d72797c2ea1f1a672.sol"
    }
]