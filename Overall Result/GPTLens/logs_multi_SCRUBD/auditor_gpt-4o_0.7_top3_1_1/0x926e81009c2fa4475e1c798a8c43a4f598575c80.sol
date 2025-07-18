[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) returns (bool success) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Potential race condition in approve",
        "reason": "The approve function does not protect against the race condition where the allowance can be changed by another transaction before the current transaction is completed, potentially allowing a spender to transfer more tokens than intended. This is commonly known as the 'ERC20 approve race condition' or 'Double-spend attack'.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    },
    {
        "function_name": "setState",
        "code": "function setState(State _nextState) public { bool icoShouldBeFinished = isIcoFinished(); bool allow = (msg.sender==creator) || (icoShouldBeFinished && (State.ICOFinished==_nextState)); require(allow); bool canSwitchState = (currentState == State.Init && _nextState == State.ICORunning) || (currentState == State.ICORunning && _nextState == State.ICOPaused) || (currentState == State.ICOPaused && _nextState == State.ICORunning) || (currentState == State.ICORunning && _nextState == State.ICOFinished) || (currentState == State.ICORunning && _nextState == State.Refunding); require(canSwitchState); currentState = _nextState; LogStateSwitch(_nextState); if(currentState==State.ICORunning){ startICO(); }else if(currentState==State.ICOFinished){ finishICO(); }else if(currentState==State.ICOPaused){ pauseICO(); }else if(currentState==State.Refunding){ startRefunding(); } }",
        "vulnerability": "Improper access control",
        "reason": "The setState function allows anyone to finish the ICO if the ICO is naturally finished. This can lead to unexpected behavior and loss of control over the ICO process, allowing attackers to manipulate the state transitions and potentially finalize the ICO prematurely, hindering its intended functionality and flow of funds.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    },
    {
        "function_name": "getMyRefund",
        "code": "function getMyRefund() public onlyInState(State.Refunding) { address sender = msg.sender; require(0!=buyers[sender].weiSent); require(0!=buyers[sender].tokensGot); sender.transfer(buyers[sender].weiSent); mntToken.burnTokens(sender,buyers[sender].tokensGot); }",
        "vulnerability": "Reentrancy risk",
        "reason": "The getMyRefund function is vulnerable to reentrancy attacks because it transfers Ether before updating the state. An attacker can exploit this by making recursive calls to getMyRefund before the state is updated, potentially withdrawing more funds than they are entitled to.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    }
]