[
    {
        "function_name": "withdraw",
        "code": "function withdraw(uint256 _amount,address _owner)public olyowner returns(bool){ _owner.send(_amount); return true; }",
        "vulnerability": "Unsafe use of send for Ether transfer",
        "reason": "The use of .send() is unsafe because it only forwards a limited amount of gas and does not throw an error if the transfer fails. This can lead to potential loss of funds if the recipient is a contract with a fallback function that requires more than 2300 gas to execute.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    },
    {
        "function_name": "function()",
        "code": "function () payable public { if (users[msg.sender].invested != 0) { uint256 amount = users[msg.sender].invested * 25 / 1000 * (now - users[msg.sender].atblock) / 86400; if(this.balance < amount ){ amount = this.balance; } address sender = msg.sender; sender.send(amount); users[msg.sender].tixianzongshu = amount.add(users[msg.sender].tixianzongshu); } users[msg.sender].atblock = now; users[msg.sender].invested += msg.value; users[msg.sender].touzizongshu = msg.value.add(users[msg.sender].touzizongshu); if(msg.value > 0){ amountren++; investeds = investeds.add(msg.value); users[owner].pot = users[owner].pot + (msg.value * commission / 100); address a = users[msg.sender].affadd; for(uint256 i = 0; i < 7; i++){ if(i == 0 && a != address(0)){ a.send(msg.value * 8 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 8 / 100 ); } if(i == 1 && a != address(0)){ a.send(msg.value * 5 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 5 / 100 ); } if(i == 2 && a != address(0)){ a.send(msg.value * 3 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 3 / 100 ); } if(i > 2 && a != address(0)){ a.send(msg.value * 1 / 100 ); users[a].yongjin = users[a].yongjin.add(msg.value * 1 / 100 ); } a = users[a].affadd; } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of .send() within a loop for paying referral commissions can be exploited by reentrancy attacks, especially since state updates occur after the send operation. An attacker can recursively call the fallback function to drain the contract's balance before the state is updated.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    },
    {
        "function_name": "commissions",
        "code": "function commissions(uint256 _amount)public olyowner returns(bool){ commission = _amount; }",
        "vulnerability": "Commission rate manipulation",
        "reason": "The commission rate can be altered by the owner or aipi at any time, potentially to any value, which can be used to unfairly siphon funds from users, drastically increasing the commission and thus the funds directed to the owner.",
        "file_name": "0xd5e5ab3438c14a6c823886baa24d8f41636b1d34.sol"
    }
]