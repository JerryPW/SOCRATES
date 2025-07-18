[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount,address _owner)public olyowner returns(bool){ _owner.send(_amount); return true; }",
        "vulnerability": "Unsafe usage of send function",
        "reason": "The withdraw function uses the send method to transfer ether, which only forwards 2300 gas and might fail in certain cases. Additionally, there is no check for the success of the send operation, leaving the contract in an inconsistent state if the send fails.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function () payable public { if (users[msg.sender].invested != 0) { uint256 amount = users[msg.sender].invested * 25 / 1000 * (now - users[msg.sender].atblock) / 86400; if(this.balance < amount ){ amount = this.balance; } address sender = msg.sender; sender.send(amount); users[msg.sender].tixianzongshu = amount.add(users[msg.sender].tixianzongshu); } users[msg.sender].atblock = now; users[msg.sender].invested += msg.value; users[msg.sender].touzizongshu = msg.value.add(users[msg.sender].touzizongshu); if(msg.value > 0){ amountren++; investeds = investeds.add(msg.value); users[owner].pot = users[owner].pot + (msg.value * commission / 100); address a = users[msg.sender].affadd; for(uint256 i = 0; i < 7; i++){ if(i == 0 && a != address(0)){ a.send(msg.value * 8 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 8 / 100 ); } if(i == 1 && a != address(0)){ a.send(msg.value * 5 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 5 / 100 ); } if(i == 2 && a != address(0)){ a.send(msg.value * 3 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 3 / 100 ); } if(i > 2 && a != address(0)){ a.send(msg.value * 1 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 1 / 100 ); } a = users[a].affadd; } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function makes external calls using the send function, which could result in reentrancy attacks if an attacker manages to exploit the external call by re-entering the contract before the state update occurs.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    },
    {
        "function_name": "commissions",
        "code": "function commissions(uint256 _amount)public olyowner returns(bool){ commission = _amount; }",
        "vulnerability": "Unrestricted change of commission rate by owner",
        "reason": "The commissions function allows the contract owner to set any commission rate without restriction, potentially allowing the owner to drain funds from the contract by increasing the commission to an extremely high value.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    }
]