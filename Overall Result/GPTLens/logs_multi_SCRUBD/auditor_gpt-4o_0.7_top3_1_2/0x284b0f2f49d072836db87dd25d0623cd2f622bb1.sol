[
    {
        "function_name": "transfer",
        "code": "function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyIfTransfersAllowed { balances[msg.sender] = balances[msg.sender].sub(_value); balances[_to] = balances[_to].add(_value); Transfer(msg.sender, _to, _value); }",
        "vulnerability": "Lack of transfer check on balance",
        "reason": "The transfer function does not check if the sender has sufficient balance to transfer the specified amount. This can allow a sender to transfer more tokens than they actually have, leading to a negative balance and potential loss of funds for the recipient.",
        "file_name": "0x284b0f2f49d072836db87dd25d0623cd2f622bb1.sol"
    },
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) onlyIfTransfersAllowed { var _allowance = allowed[_from][msg.sender]; balances[_to] = balances[_to].add(_value); balances[_from] = balances[_from].sub(_value); allowed[_from][msg.sender] = _allowance.sub(_value); Transfer(_from, _to, _value); }",
        "vulnerability": "Lack of allowance check",
        "reason": "The transferFrom function does not check if the _allowance is sufficient for the transfer. This can allow the msg.sender to transfer more tokens than authorized by the _from address, leading to unauthorized transfers and potential loss of funds.",
        "file_name": "0x284b0f2f49d072836db87dd25d0623cd2f622bb1.sol"
    },
    {
        "function_name": "doPurchase",
        "code": "function doPurchase(address _sender) private stopInEmergency { require(tokensSelling != 0); require(msg.value >= 0.01 * 1 ether); uint tokens = msg.value * 1 ether / tokenPrice; require(token.balanceOf(_sender).add(tokens) <= purchaseLimit); tokensSelling = tokensSelling.sub(tokens); tokensSoldTotal = tokensSoldTotal.add(tokens); if (token.balanceOf(_sender) == 0) investorCount++; weiRaisedTotal = weiRaisedTotal.add(msg.value); token.transfer(_sender, tokens); beneficiary.transfer(msg.value); NewContribution(_sender, tokens, msg.value); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The doPurchase function transfers Ether to the beneficiary before updating the state variables. This can lead to a reentrancy attack where an attacker can repeatedly call the fallback function to drain the contract's funds before the state variables are updated.",
        "file_name": "0x284b0f2f49d072836db87dd25d0623cd2f622bb1.sol"
    }
]