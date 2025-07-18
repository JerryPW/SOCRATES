[
    {
        "function_name": "applyWithEtherFor",
        "code": "function applyWithEtherFor(address who) public payable returns (uint) { uint fee = governance.proposalFee(); exchange.ethToTokenSwapOutput.value(msg.value)(fee, block.timestamp); uint proposalId = applyFor(who); msg.sender.send(address(this).balance); return proposalId; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of `msg.sender.send` allows for potential reentrancy attacks. An attacker can create a contract with a fallback function that repeatedly calls `applyWithEtherFor` before the balance is updated, potentially draining the contract.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    },
    {
        "function_name": "applyFor",
        "code": "function applyFor(address who) public returns (uint) { uint fee = governance.proposalFee(); uint balance = humanity.balanceOf(address(this)); if (fee > balance) { require(humanity.transferFrom(msg.sender, address(this), fee.sub(balance)), \"HumanityApplicant::applyFor: Transfer failed\"); } bytes memory data = abi.encodeWithSelector(registry.add.selector, who); return governance.proposeWithFeeRecipient(msg.sender, address(registry), data); }",
        "vulnerability": "Insufficient balance check",
        "reason": "The contract assumes that the `transferFrom` function call will always succeed in transferring the required fee. If `transferFrom` fails due to insufficient allowance or balance, the function will revert, but the error message may not provide detailed information about the cause, making troubleshooting difficult.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    },
    {
        "function_name": "constructor",
        "code": "constructor(IGovernance _governance, IRegistry _registry, IERC20 _humanity) public { governance = _governance; registry = _registry; humanity = _humanity; humanity.approve(address(governance), uint(-1)); }",
        "vulnerability": "Infinite approval vulnerability",
        "reason": "The constructor approves the maximum possible token amount for the governance contract, which can lead to potential abuse if the governance contract is compromised. An attacker with control over the governance contract can transfer any amount of humanity tokens from this contract.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    }
]