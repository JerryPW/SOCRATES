[
    {
        "function_name": "applyWithEtherFor",
        "code": "function applyWithEtherFor(address who) public payable returns (uint) { uint fee = governance.proposalFee(); exchange.ethToTokenSwapOutput.value(msg.value)(fee, block.timestamp); uint proposalId = applyFor(who); msg.sender.send(address(this).balance); return proposalId; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function uses 'send', which forwards 2300 gas to the recipient, allowing a fallback function to call back into the contract. This can be exploited if an attacker deploys a contract with a fallback function to repeatedly call 'applyWithEtherFor' and drain the contract's funds before the state is updated.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    },
    {
        "function_name": "applyFor",
        "code": "function applyFor(address who) public returns (uint) { uint fee = governance.proposalFee(); uint balance = humanity.balanceOf(address(this)); if (fee > balance) { require(humanity.transferFrom(msg.sender, address(this), fee.sub(balance)), \"HumanityApplicant::applyFor: Transfer failed\"); } bytes memory data = abi.encodeWithSelector(registry.add.selector, who); return governance.proposeWithFeeRecipient(msg.sender, address(registry), data); }",
        "vulnerability": "ERC20 approve race condition",
        "reason": "The contract uses 'approve' with 'uint(-1)' in the constructor, which sets an infinite allowance of tokens. This is dangerous because it allows race conditions where an attacker can spend tokens repeatedly before the allowance is changed or cleared, leading to potential token theft.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () external payable {}",
        "vulnerability": "Potential ether trap",
        "reason": "The fallback function is payable but does not provide any mechanism to withdraw the received Ether beyond the 'send' in 'applyWithEtherFor'. If Ether is sent to this contract by mistake, it could permanently lock the Ether in the contract unless explicitly handled elsewhere, which is not present in any visible code.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    }
]