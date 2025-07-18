[
    {
        "function_name": "function () payable public",
        "code": "function () payable public { if (users[msg.sender].invested != 0) { uint256 amount = users[msg.sender].invested * 25 / 1000 * (now - users[msg.sender].atblock) / 86400; if(this.balance < amount ){ amount = this.balance; } address sender = msg.sender; sender.send(amount); users[msg.sender].tixianzongshu = amount.add(users[msg.sender].tixianzongshu); } users[msg.sender].atblock = now; users[msg.sender].invested += msg.value; users[msg.sender].touzizongshu = msg.value.add(users[msg.sender].touzizongshu); if(msg.value > 0){ amountren++; investeds = investeds.add(msg.value); users[owner].pot = users[owner].pot + (msg.value * commission / 100); address a = users[msg.sender].affadd; for(uint256 i = 0; i < 7; i++){ if(i == 0 && a != address(0)){ a.send(msg.value * 8 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 8 / 100 ); } if(i == 1 && a != address(0)){ a.send(msg.value * 5 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 5 / 100 ); } if(i == 2 && a != address(0)){ a.send(msg.value * 3 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 3 / 100 ); } if(i > 2 && a != address(0)){ a.send(msg.value * 1 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 1 / 100 ); } a = users[a].affadd; } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function allows reentrancy attacks since it sends Ether before updating the user's `invested` and `atblock` values. An attacker could exploit this by recursively calling into the contract before the state is updated, potentially draining the contract's funds.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    },
    {
        "function_name": "withdraw(uint256 _amount,address _owner)",
        "code": "function withdraw(uint256 _amount,address _owner)public olyowner returns(bool){ _owner.send(_amount); return true; }",
        "vulnerability": "Unchecked send call",
        "reason": "The `withdraw` function uses the `.send` method to transfer Ether to `_owner` without checking if it was successful. This can lead to loss of funds if the send fails, as the function assumes that the send operation is always successful and does not handle failure cases.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    },
    {
        "function_name": "function () payable public",
        "code": "function () payable public { if (users[msg.sender].invested != 0) { uint256 amount = users[msg.sender].invested * 25 / 1000 * (now - users[msg.sender].atblock) / 86400; if(this.balance < amount ){ amount = this.balance; } address sender = msg.sender; sender.send(amount); users[msg.sender].tixianzongshu = amount.add(users[msg.sender].tixianzongshu); } users[msg.sender].atblock = now; users[msg.sender].invested += msg.value; users[msg.sender].touzizongshu = msg.value.add(users[msg.sender].touzizongshu); if(msg.value > 0){ amountren++; investeds = investeds.add(msg.value); users[owner].pot = users[owner].pot + (msg.value * commission / 100); address a = users[msg.sender].affadd; for(uint256 i = 0; i < 7; i++){ if(i == 0 && a != address(0)){ a.send(msg.value * 8 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 8 / 100 ); } if(i == 1 && a != address(0)){ a.send(msg.value * 5 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 5 / 100 ); } if(i == 2 && a != address(0)){ a.send(msg.value * 3 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 3 / 100 ); } if(i > 2 && a != address(0)){ a.send(msg.value * 1 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 1 / 100 ); } a = users[a].affadd; } } }",
        "vulnerability": "Denial of Service via Gas Limit",
        "reason": "The fallback function iterates through a loop up to 7 times, sending Ether to addresses stored in a chain of `affadd` fields. If any of these addresses is a contract that consumes a lot of gas upon receiving Ether, it could cause the transaction to run out of gas and fail, making the function unusable for other users.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    }
]