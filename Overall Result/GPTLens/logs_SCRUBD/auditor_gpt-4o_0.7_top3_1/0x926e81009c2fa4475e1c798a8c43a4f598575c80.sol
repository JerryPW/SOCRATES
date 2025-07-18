[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) returns (bool success) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Missing approval race condition check",
        "reason": "The approve function doesn't prevent the known race condition issue in ERC20 tokens, where someone can front-run the change of allowance. This can lead to double-spending if a spender uses the allowance and the owner changes it before the spender sees the new value. Implementing solutions like increasing/decreasing allowance helps mitigate this risk.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    },
    {
        "function_name": "setState",
        "code": "function setState(State _nextState) public { bool icoShouldBeFinished = isIcoFinished(); bool allow = (msg.sender==creator) || (icoShouldBeFinished && (State.ICOFinished==_nextState)); require(allow); bool canSwitchState = (currentState == State.Init && _nextState == State.ICORunning) || (currentState == State.ICORunning && _nextState == State.ICOPaused) || (currentState == State.ICOPaused && _nextState == State.ICORunning) || (currentState == State.ICORunning && _nextState == State.ICOFinished) || (currentState == State.ICORunning && _nextState == State.Refunding); require(canSwitchState); currentState = _nextState; LogStateSwitch(_nextState); if(currentState==State.ICORunning){ startICO(); }else if(currentState==State.ICOFinished){ finishICO(); }else if(currentState==State.ICOPaused){ pauseICO(); }else if(currentState==State.Refunding){ startRefunding(); } }",
        "vulnerability": "State transition unrestricted access",
        "reason": "The setState function allows anyone to set the state to ICOFinished if the ICO is detected as finished by the isIcoFinished function, due to the condition 'icoShouldBeFinished && (State.ICOFinished==_nextState)'. This can allow an attacker to prematurely end the ICO and trigger finish-related processes if they manipulate conditions to make isIcoFinished return true.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    },
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() public { uint64 oneYearPassed = icoIsFinishedDate + 365 days; require(uint(now) >= oneYearPassed); uint total = mntToken.balanceOf(this); mntToken.transfer(teamAccountAddress,total); }",
        "vulnerability": "Potential overflow in timestamp arithmetic",
        "reason": "The calculation of 'oneYearPassed = icoIsFinishedDate + 365 days' can lead to overflow in Solidity versions below 0.8.0 where SafeMath is not applied for time arithmetic, making it possible to bypass the timing check by manipulating icoIsFinishedDate. This could allow premature withdrawal of tokens.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    }
]