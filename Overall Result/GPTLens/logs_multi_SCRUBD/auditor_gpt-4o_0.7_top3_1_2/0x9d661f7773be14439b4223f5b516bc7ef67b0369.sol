[
    {
        "function_name": "constructor",
        "code": "constructor(IGovernance _governance, IRegistry _registry, IERC20 _humanity) public { governance = _governance; registry = _registry; humanity = _humanity; humanity.approve(address(governance), uint(-1)); }",
        "vulnerability": "Unlimited approval vulnerability",
        "reason": "The constructor of the HumanityApplicant contract approves the governance contract to spend an unlimited amount of humanity tokens from the contract's balance. This is risky because if the governance contract is compromised, the attacker can drain all humanity tokens from this contract.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    },
    {
        "function_name": "applyFor",
        "code": "function applyFor(address who) public returns (uint) { uint fee = governance.proposalFee(); uint balance = humanity.balanceOf(address(this)); if (fee > balance) { require(humanity.transferFrom(msg.sender, address(this), fee.sub(balance)), \"HumanityApplicant::applyFor: Transfer failed\"); } bytes memory data = abi.encodeWithSelector(registry.add.selector, who); return governance.proposeWithFeeRecipient(msg.sender, address(registry), data); }",
        "vulnerability": "Lack of input validation",
        "reason": "The applyFor function does not validate the 'who' address before proceeding. This could lead to unauthorized or incorrect entries being proposed, as there are no checks to ensure 'who' is a valid address or meets certain criteria.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    },
    {
        "function_name": "applyWithEtherFor",
        "code": "function applyWithEtherFor(address who) public payable returns (uint) { uint fee = governance.proposalFee(); exchange.ethToTokenSwapOutput.value(msg.value)(fee, block.timestamp); uint proposalId = applyFor(who); msg.sender.send(address(this).balance); return proposalId; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The applyWithEtherFor function sends remaining ether back to the sender after invoking external calls. This allows for potential reentrancy attacks where the attacker could re-enter this function and cause it to execute multiple times, possibly depleting funds or causing other unexpected behaviors.",
        "file_name": "0x9d661f7773be14439b4223f5b516bc7ef67b0369.sol"
    }
]