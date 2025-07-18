[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) public returns (bool) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race condition - multiple withdrawal attack",
        "reason": "The approve function allows setting of an allowance for a spender without any checks on the current allowance. This can lead to a race condition where if a spender spends the current allowance and the owner sets a new allowance, the spender could potentially spend both allowances if they act quickly enough. This is a well-known vulnerability in ERC20 tokens and allows attackers to double-spend the allowance.",
        "file_name": "0xc64fd3ff188c4f1f1e34bbff54f67d8c88175696.sol"
    },
    {
        "function_name": "burn",
        "code": "function burn(uint amount) public { totalSupply_ = totalSupply_.sub(amount); balances[msg.sender] = balances[msg.sender].sub(amount); }",
        "vulnerability": "No balance check before burning",
        "reason": "The burn function does not check if the msg.sender has enough balance before calling SafeMath's sub function. If msg.sender has less balance than the amount they are attempting to burn, this will cause an underflow error in versions of Solidity prior to 0.8.0, effectively locking the contract due to the exception. This can be exploited by attackers to disrupt the contract's functionality.",
        "file_name": "0xc64fd3ff188c4f1f1e34bbff54f67d8c88175696.sol"
    },
    {
        "function_name": "withdrawRejected",
        "code": "function withdrawRejected() external { uint value = etherRejected[msg.sender]; etherRejected[msg.sender] = 0; (msg.sender).transfer(value); emit RejectedWithdrawn(msg.sender, value); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The withdrawRejected function transfers Ether before setting etherRejected[msg.sender] to 0. This leaves the contract vulnerable to a reentrancy attack, where an attacker could call the function again before the etherRejected value is reset, allowing them to withdraw more Ether than they are entitled to. This is a common attack vector in Ethereum smart contracts.",
        "file_name": "0xc64fd3ff188c4f1f1e34bbff54f67d8c88175696.sol"
    }
]