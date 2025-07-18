[
    {
        "function_name": "refund",
        "code": "function refund() public inState(State.Refunding) {\n    uint256 weiValue = investedAmountOf[msg.sender];\n    if (weiValue == 0) throw;\n    investedAmountOf[msg.sender] = 0;\n    weiRefunded = weiRefunded.plus(weiValue);\n    Refund(msg.sender, weiValue);\n    if (!msg.sender.send(weiValue)) throw;\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The refund function contains a reentrancy vulnerability. The function sends ether to an address before updating the weiRefunded state. This allows an attacker to use a fallback function to re-enter the refund function before the state is updated, potentially draining the contract's funds.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint _value) returns (bool success) {\n    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n    allowed[msg.sender][_spender] = _value;\n    Approval(msg.sender, _spender, _value);\n    return true;\n}",
        "vulnerability": "Race condition vulnerability",
        "reason": "The approve function is susceptible to the race condition vulnerability where an approved spender can execute a transaction using the old allowance before the new allowance is set, leading to potential double-spending of the allowance.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    },
    {
        "function_name": "setCrowdsale",
        "code": "function setCrowdsale(Crowdsale _crowdsale) public onlyOwner {\n    crowdsale = _crowdsale;\n    if(!crowdsale.isCrowdsale()) true;\n}",
        "vulnerability": "Incorrect function logic",
        "reason": "The setCrowdsale function contains an incorrect logic for checking the isCrowdsale function. The line 'if(!crowdsale.isCrowdsale()) true;' does not perform any meaningful check or action, potentially leading to incorrect assumptions about the crowdsale contract's validity.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    }
]