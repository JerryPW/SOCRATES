[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint _value) returns (bool success) { if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw; allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "race_condition_approval",
        "reason": "The approve function is susceptible to the race condition vulnerability known as the 'multiple withdrawal attack'. An attacker can front-run a transaction to set an allowance, allowing them to spend more tokens than intended. The check for non-zero approval doesn't prevent this attack as it doesn't address the fundamental issue of race conditions with allowance changes.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    },
    {
        "function_name": "buyForEverybody",
        "code": "function buyForEverybody() stopInEmergency public { if(getState() != State.Funding) { throw; } if(address(crowdsale) == 0) throw; crowdsale.invest.value(weiRaisedTotal)(address(this)); tokensBought = getToken().balanceOf(address(this)); if(tokensBought == 0) { throw; } TokensBoughts(tokensBought); }",
        "vulnerability": "reentrancy_vulnerability",
        "reason": "The function buyForEverybody allows external calls to the invest function of the Crowdsale contract via crowdsale.invest.value(weiRaisedTotal)(address(this));. If the Crowdsale contract has any reentrancy vulnerabilities, this could be exploited by an attacker to manipulate the state of the contract leading to potential loss of funds or incorrect distribution of tokens.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    },
    {
        "function_name": "refund",
        "code": "function refund() stopInEmergency { if(getState() != State.Refunding) throw; address investor = msg.sender; if(balances[investor] == 0) throw; uint amount = balances[investor]; delete balances[investor]; if(!investor.send(amount)) throw; Refunded(investor, amount); }",
        "vulnerability": "potential_dos_send_failure",
        "reason": "The use of send to transfer Ether can fail if the recipient is a contract with a fallback function that uses more than 2300 gas, or if the recipient is a non-existent address. This can make the refund function susceptible to a denial of service (DoS) attack where funds can be locked in the contract if a refund to a particular address consistently fails.",
        "file_name": "0x3085c9403871c00f7fd2e84dac1bdaa05f5f652e.sol"
    }
]