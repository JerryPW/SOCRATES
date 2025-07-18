[
    {
        "function_name": "receive",
        "vulnerability": "Reentrancy vulnerability",
        "criticism": "The reasoning is partially correct. The receive function does call the deposit function, but without the code of the deposit function, it's impossible to confirm if there is a reentrancy vulnerability. The severity and profitability of this vulnerability are also uncertain without more information.",
        "correctness": 5,
        "severity": 5,
        "profitability": 5,
        "reason": "The receive function allows for depositing Ether and calls the deposit function. There is a risk of reentrancy if the deposit function or any internal functions it calls transfer Ether to an untrusted contract, which could then recursively call back into this contract's receive function.",
        "code": "receive() external payable{ require(tempUpline[msg.sender] != address(0),\"Setup upline first!\"); deposit(tempUpline[msg.sender]); }",
        "file_name": "0x00b6358d1ac8d3731defd6b4d593b6ba04f9b8ea.sol"
    },
    {
        "function_name": "_deposit",
        "vulnerability": "Unchecked external calls",
        "criticism": "The reasoning is correct. The _deposit function makes external calls to admin1 and admin2 without checking the return value or using a reentrancy guard. This could allow an attacker to exploit these calls to perform reentrancy attacks or cause the contract to malfunction if the calls fail. The severity and profitability of this vulnerability are high.",
        "correctness": 9,
        "severity": 9,
        "profitability": 9,
        "reason": "The _deposit function makes external calls to admin1 and admin2 without checking the return value or using a reentrancy guard. This could allow an attacker to exploit these calls to perform reentrancy attacks or cause the contract to malfunction if the calls fail.",
        "code": "function _deposit(address _addr, uint256 _amount, uint8 method) private { require(tempUpline[_addr] != address(0) || _addr == owner(), \"No upline\"); if(users[_addr].deposit_time > 0) { users[_addr].cycle++; require(users[_addr].payouts >= this.maxPayoutOf(users[_addr].deposit_amount), \"Deposit already exists\"); if(method == 0){ require(!isEthDepoPaused,\"Depositing Ether is paused\"); } require(_amount >= users[_addr].deposit_amount && _amount <= cycles[users[_addr].cycle > 3 ? 3 : users[_addr].cycle], \"Bad amount\"); } else { _setUpline(_addr, tempUpline[_addr]); if(method == 0){ require(_amount >= minDeposit && _amount <= cycles[0], \"Bad amount\"); require(!isEthDepoPaused,\"Depositing Ether is paused\"); matrixUser[_addr].first_deposit_time = block.timestamp; } else if(method == 1){ require(_amount >= minDeposit && _amount <= cycles[0], \"Bad amount\"); }else{ revert(); } } users[_addr].payouts = 0; users[_addr].deposit_amount = _amount; users[_addr].deposit_payouts = 0; users[_addr].deposit_time = uint40(block.timestamp); users[_addr].total_deposits += _amount; users[_addr].isWithdrawActive = true; for(uint8 i=0;i<10;i++){ if(users[_addr].total_deposits >= level_bonuses[i]){ matrixUser[_addr].level = i+6; } } emit NewDeposit(_addr, _amount); if(users[_addr].upline != address(0)) { users[users[_addr].upline].direct_bonus += _amount / 10; emit DirectPayout(users[_addr].upline, _addr, _amount / 10); } _poolDeposits(_addr, _amount); _teamLeaderBonus(_addr,_amount); if(last_draw + 7 days < block.timestamp) { _drawPool(); } if(method == 0){ admin1.transfer(_amount.mul(95).div(1000)); admin2.transfer(_amount.mul(5).div(1000)); }else if(method == 1){ _token.send(admin1,_amount.mul(95).div(1000),\"Admin 1 commision\"); _token.send(admin2,_amount.mul(5).div(1000),\"Admin 2 commision\"); }else{ revert(); } }",
        "file_name": "0x00b6358d1ac8d3731defd6b4d593b6ba04f9b8ea.sol"
    },
    {
        "function_name": "tokensReceived",
        "vulnerability": "Lack of access control",
        "criticism": "The reasoning is correct. The tokensReceived function does not have adequate access control, allowing any IERC777 token transfer to trigger a deposit. This could allow attackers to manipulate deposits by sending tokens without proper authorization checks. The severity and profitability of this vulnerability are high.",
        "correctness": 9,
        "severity": 9,
        "profitability": 9,
        "reason": "The tokensReceived function does not have adequate access control, allowing any IERC777 token transfer to trigger a deposit. This could allow attackers to manipulate deposits by sending tokens without proper authorization checks.",
        "code": "function tokensReceived(address operator, address from, address to, uint256 amount, bytes calldata userData, bytes calldata operatorData) external { require(msg.sender == address(_token), \"Invalid token\"); require(tempUpline[from] != address(0),\"No referral found\"); _deposit(from,amount,1); }",
        "file_name": "0x00b6358d1ac8d3731defd6b4d593b6ba04f9b8ea.sol"
    }
]