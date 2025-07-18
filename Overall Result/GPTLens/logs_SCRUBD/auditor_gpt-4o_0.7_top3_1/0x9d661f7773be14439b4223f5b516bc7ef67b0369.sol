[
    {
        "function_name": "applyFor",
        "code": "function applyFor(address who) public returns (uint) { uint fee = governance.proposalFee(); uint balance = humanity.balanceOf(address(this)); if (fee > balance) { require(humanity.transferFrom(msg.sender, address(this), fee.sub(balance)), \"HumanityApplicant::applyFor: Transfer failed\"); } bytes memory data = abi.encodeWithSelector(registry.add.selector, who); return governance.proposeWithFeeRecipient(msg.sender, address(registry), data); }",
        "vulnerability": "Unchecked External Call",
        "reason": "The function makes an external call to the 'governance.proposeWithFeeRecipient' function without validating the return value, which can lead to unexpected behaviors if the call fails or if the external contract behaves maliciously.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    },
    {
        "function_name": "applyWithEtherFor",
        "code": "function applyWithEtherFor(address who) public payable returns (uint) { uint fee = governance.proposalFee(); exchange.ethToTokenSwapOutput.value(msg.value)(fee, block.timestamp); uint proposalId = applyFor(who); msg.sender.send(address(this).balance); return proposalId; }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The use of 'msg.sender.send' to transfer Ether is unsafe because it only forwards 2300 gas, which may cause the transfer to fail. This can result in loss of Ether if the transfer fails, and the caller might not receive any change back, leading to potential loss of funds.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    },
    {
        "function_name": "applyWithEtherFor",
        "code": "function applyWithEtherFor(address who) public payable returns (uint) { uint fee = governance.proposalFee(); exchange.ethToTokenSwapOutput.value(msg.value)(fee, block.timestamp); uint proposalId = applyFor(who); msg.sender.send(address(this).balance); return proposalId; }",
        "vulnerability": "Reentrancy",
        "reason": "The function makes an external call to 'exchange.ethToTokenSwapOutput' and 'applyFor', and then transfers Ether back to the caller. This sequence can be exploited for reentrancy attacks if the external contracts are compromised or if they make malicious calls, allowing attackers to drain funds by re-entering the contract before state changes are finalized.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    }
]