[
    {
        "function_name": "approve",
        "vulnerability": "Potential race condition in approve",
        "criticism": "The reasoning is correct that the approve function does not protect against the race condition where the allowance can be changed by another transaction before the current transaction is completed. However, the severity and profitability of this vulnerability are moderate, because it requires specific conditions and an external attacker can profit from this vulnerability only under these conditions.",
        "correctness": 7,
        "severity": 5,
        "profitability": 5,
        "reason": "The approve function does not protect against the race condition where the allowance can be changed by another transaction before the current transaction is completed, potentially allowing a spender to transfer more tokens than intended. This is commonly known as the 'ERC20 approve race condition' or 'Double-spend attack'.",
        "code": "function approve(address _spender, uint256 _value) returns (bool success) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    },
    {
        "function_name": "setState",
        "vulnerability": "Improper access control",
        "criticism": "The reasoning is correct that the setState function allows anyone to finish the ICO if the ICO is naturally finished. However, the severity and profitability of this vulnerability are high, because it can lead to unexpected behavior and loss of control over the ICO process, allowing attackers to manipulate the state transitions and potentially finalize the ICO prematurely, hindering its intended functionality and flow of funds.",
        "correctness": 9,
        "severity": 8,
        "profitability": 8,
        "reason": "The setState function allows anyone to finish the ICO if the ICO is naturally finished. This can lead to unexpected behavior and loss of control over the ICO process, allowing attackers to manipulate the state transitions and potentially finalize the ICO prematurely, hindering its intended functionality and flow of funds.",
        "code": "function setState(State _nextState) public { bool icoShouldBeFinished = isIcoFinished(); bool allow = (msg.sender==creator) || (icoShouldBeFinished && (State.ICOFinished==_nextState)); require(allow); bool canSwitchState = (currentState == State.Init && _nextState == State.ICORunning) || (currentState == State.ICORunning && _nextState == State.ICOPaused) || (currentState == State.ICOPaused && _nextState == State.ICORunning) || (currentState == State.ICORunning && _nextState == State.ICOFinished) || (currentState == State.ICORunning && _nextState == State.Refunding); require(canSwitchState); currentState = _nextState; LogStateSwitch(_nextState); if(currentState==State.ICORunning){ startICO(); }else if(currentState==State.ICOFinished){ finishICO(); }else if(currentState==State.ICOPaused){ pauseICO(); }else if(currentState==State.Refunding){ startRefunding(); } }",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    },
    {
        "function_name": "getMyRefund",
        "vulnerability": "Reentrancy risk",
        "criticism": "The reasoning is correct that the getMyRefund function is vulnerable to reentrancy attacks because it transfers Ether before updating the state. However, the severity and profitability of this vulnerability are high, because an attacker can exploit this by making recursive calls to getMyRefund before the state is updated, potentially withdrawing more funds than they are entitled to.",
        "correctness": 9,
        "severity": 9,
        "profitability": 9,
        "reason": "The getMyRefund function is vulnerable to reentrancy attacks because it transfers Ether before updating the state. An attacker can exploit this by making recursive calls to getMyRefund before the state is updated, potentially withdrawing more funds than they are entitled to.",
        "code": "function getMyRefund() public onlyInState(State.Refunding) { address sender = msg.sender; require(0!=buyers[sender].weiSent); require(0!=buyers[sender].tokensGot); sender.transfer(buyers[sender].weiSent); mntToken.burnTokens(sender,buyers[sender].tokensGot); }",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    }
]