[
    {
        "function_name": "applyWithEtherFor",
        "code": "function applyWithEtherFor(address who) public payable returns (uint) { uint fee = governance.proposalFee(); exchange.ethToTokenSwapOutput.value(msg.value)(fee, block.timestamp); uint proposalId = applyFor(who); msg.sender.send(address(this).balance); return proposalId; }",
        "vulnerability": "Reentrancy",
        "reason": "The function applyWithEtherFor contains a vulnerability due to the use of msg.sender.send, which sends Ether back to the sender. This is a potential reentrancy vulnerability since the state change with applyFor occurs after the send. An attacker could exploit this by re-entering the contract in a callback function and manipulating the contract's state or draining funds.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    },
    {
        "function_name": "applyFor",
        "code": "function applyFor(address who) public returns (uint) { uint fee = governance.proposalFee(); uint balance = humanity.balanceOf(address(this)); if (fee > balance) { require(humanity.transferFrom(msg.sender, address(this), fee.sub(balance)), \"HumanityApplicant::applyFor: Transfer failed\"); } bytes memory data = abi.encodeWithSelector(registry.add.selector, who); return governance.proposeWithFeeRecipient(msg.sender, address(registry), data); }",
        "vulnerability": "Unchecked return value from non-standard ERC20",
        "reason": "The function applyFor does not handle the return value of humanity.transferFrom properly. Some ERC20 tokens do not return true/false as expected, leading to potential issues if the token transfer fails but does not revert. This could allow attackers to bypass the payment requirement by using a malicious ERC20 token that always returns false.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    },
    {
        "function_name": "constructor (HumanityApplicant)",
        "code": "constructor(IGovernance _governance, IRegistry _registry, IERC20 _humanity) public { governance = _governance; registry = _registry; humanity = _humanity; humanity.approve(address(governance), uint(-1)); }",
        "vulnerability": "Approval race condition",
        "reason": "The constructor approves the governance contract to spend an unlimited amount of the humanity token. This creates a race condition where, if the governance contract is compromised or malicious, it can drain all tokens from HumanityApplicant by calling transferFrom before any other operation. Furthermore, it does not adhere to the best practice of resetting allowances to zero before setting a new value, exposing it to the race condition attack.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    }
]