[
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _value) returns (bool success) { allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true; }",
        "vulnerability": "Race Condition - ERC20 approve/transferFrom",
        "reason": "The approve function allows an allowance to be set without considering the current allowance, which can lead to a race condition known as the 'approve/transferFrom' issue. An attacker could exploit this by front-running transactions to change allowances unexpectedly, leading to potential double spending.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    },
    {
        "function_name": "setState",
        "code": "function setState(State _nextState) public { bool icoShouldBeFinished = isIcoFinished(); bool allow = (msg.sender==creator) || (icoShouldBeFinished && (State.ICOFinished==_nextState)); require(allow); bool canSwitchState = (currentState == State.Init && _nextState == State.ICORunning) || (currentState == State.ICORunning && _nextState == State.ICOPaused) || (currentState == State.ICOPaused && _nextState == State.ICORunning) || (currentState == State.ICORunning && _nextState == State.ICOFinished) || (currentState == State.ICORunning && _nextState == State.Refunding); require(canSwitchState); currentState = _nextState; LogStateSwitch(_nextState); if(currentState==State.ICORunning){ startICO(); }else if(currentState==State.ICOFinished){ finishICO(); }else if(currentState==State.ICOPaused){ pauseICO(); }else if(currentState==State.Refunding){ startRefunding(); } }",
        "vulnerability": "Improper Access Control",
        "reason": "The setState function checks if the message sender is the creator or if the ICO should be finished to allow a state transition. However, it does not restrict state transitions strictly to authorized parties after the ICO finishes. This could potentially allow unauthorized state transitions if a condition is fulfilled, leading to unpredictable contract behavior.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    },
    {
        "function_name": "withdrawTokens",
        "code": "function withdrawTokens() public { uint64 oneYearPassed = icoIsFinishedDate + 365 days; require(uint(now) >= oneYearPassed); uint total = mntToken.balanceOf(this); mntToken.transfer(teamAccountAddress,total); }",
        "vulnerability": "No Access Control for Token Withdrawal",
        "reason": "The withdrawTokens function in the GoldmintUnsold contract allows any user to call it after one year from ICO completion to transfer the contract's entire token balance to the team account. This lacks proper access control, which means that anyone could trigger the withdrawal process, potentially leading to misuse or manipulation if the team account address is compromised or incorrect.",
        "file_name": "0x926e81009c2fa4475e1c798a8c43a4f598575c80.sol"
    }
]