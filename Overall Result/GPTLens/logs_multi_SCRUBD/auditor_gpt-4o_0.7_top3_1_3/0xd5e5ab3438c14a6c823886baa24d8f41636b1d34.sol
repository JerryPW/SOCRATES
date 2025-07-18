[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount,address _owner)public olyowner returns(bool){ _owner.send(_amount); return true; }",
        "vulnerability": "Missing check for send() success",
        "reason": "The function uses .send() to transfer Ether, which only forwards 2300 gas and returns a boolean indicating success or failure. If the send fails, the function does not handle this failure, potentially resulting in lost funds or unexpected behavior.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    },
    {
        "function_name": "commissions",
        "code": "function commissions(uint256 _amount)public olyowner returns(bool){ commission = _amount; }",
        "vulnerability": "Lack of validation on commission rate",
        "reason": "The function allows the owner to set any commission rate without any validation or limits. This could be exploited by the contract owner to set an excessively high commission rate, effectively siphoning funds from users.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    },
    {
        "function_name": "investedbuy",
        "code": "function investedbuy(address _owner)public payable { require(msg.sender != _owner); amountren++; investeds = investeds.add(msg.value); users[msg.sender].affadd = _owner; users[owner].pot = users[owner].pot + (msg.value * commission / 100); address a = users[msg.sender].affadd; for(uint256 i = 0; i < 7; i++){ if(i == 0 && a != address(0)){ a.send(msg.value * 8 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 8 / 100 ); } if(i == 1 && a != address(0)){ a.send(msg.value * 5 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 5 / 100 ); } if(i == 2 && a != address(0)){ a.send(msg.value * 3 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 3 / 100 ); } if(i > 2 && a != address(0)){ a.send(msg.value * 1 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 1 / 100 ); } a = users[a].affadd; } users[msg.sender].touzizongshu = msg.value.add(users[msg.sender].touzizongshu); if (users[msg.sender].invested != 0) { uint256 amount = users[msg.sender].invested * 25 / 1000 * (now - users[msg.sender].atblock) / 86400; if(this.balance < amount ){ amount = this.balance; } address sender = msg.sender; sender.send(amount); users[msg.sender].tixianzongshu = amount.add(users[msg.sender].tixianzongshu); } users[msg.sender].atblock = now; users[msg.sender].invested += msg.value; }",
        "vulnerability": "Reentrancy through send() calls",
        "reason": "The function uses .send() in multiple places without proper checks or the use of a reentrancy guard. This could allow an attacker to exploit reentrancy during the send, especially when there are multiple send() calls in a loop, potentially manipulating the state and extracting more funds than intended.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    }
]