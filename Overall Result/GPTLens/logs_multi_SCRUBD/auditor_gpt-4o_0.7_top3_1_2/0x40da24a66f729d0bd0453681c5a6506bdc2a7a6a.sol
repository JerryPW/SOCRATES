[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _from, address _to, uint256 _value) returns (bool) { var _allowance = allowed[_from][msg.sender]; balances[_to] = balances[_to].add(_value); balances[_from] = balances[_from].sub(_value); allowed[_from][msg.sender] = _allowance.sub(_value); Transfer(_from, _to, _value); return true; }",
        "vulnerability": "Allowance Double-Spend",
        "reason": "The transferFrom function does not check if the _from address has enough balance before subtracting the _value, which could lead to an unauthorized transfer if balances[_from] is less than _value at the time of execution. This allows an attacker to potentially spend tokens they do not have.",
        "file_name": "0x40da24a66f729d0bd0453681c5a6506bdc2a7a6a.sol"
    },
    {
        "function_name": "requestPayout",
        "code": "function requestPayout(uint _amount) onlyWithdraw requireState(States.Operational) { msg.sender.transfer(_amount); }",
        "vulnerability": "Unrestricted Payout",
        "reason": "The requestPayout function allows the withdrawControl address to transfer any amount of Ether from the contract balance without any checks on the _amount parameter. This could lead to draining of the contract funds if the withdrawControl account is compromised or behaves maliciously.",
        "file_name": "0x40da24a66f729d0bd0453681c5a6506bdc2a7a6a.sol"
    },
    {
        "function_name": "addBonus",
        "code": "function addBonus(uint256 basisTokens) public constant returns (uint256 resultingTokens) { if (!bonusPhase) return basisTokens; uint256 perMillBonus = getPhaseBonus(); if (basisTokens >= pointMultiplier.mul(1000)) { perMillBonus += Bonus.getBonusFactor(basisTokens); } return basisTokens.mul(per_mill + perMillBonus).div(per_mill); }",
        "vulnerability": "Incorrect Bonus Calculation",
        "reason": "The addBonus function does not properly handle very large values of basisTokens, leading to potential integer overflow when calculating the bonus amount. This could be exploited by an attacker to receive an incorrect number of tokens, potentially exceeding the intended cap.",
        "file_name": "0x40da24a66f729d0bd0453681c5a6506bdc2a7a6a.sol"
    }
]