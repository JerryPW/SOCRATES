[
    {
        "function_name": "withdraw",
        "code": "function withdraw() onlyOwner returns (bool result) { owner.send(this.balance); return true; }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The withdraw function uses send to transfer Ether, which only forwards 2300 gas and can fail silently if the receiver reverts. This can result in failed withdrawals, potentially locking funds in the contract.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _amount) returns (bool success) { allowed[msg.sender][_spender] = _amount; Approval(msg.sender, _spender, _amount); return true; }",
        "vulnerability": "Race Condition (Multiple Withdrawals)",
        "reason": "The approve function allows changing the allowance without first setting it to zero, which can lead to a race condition where the spender can use the old allowance and the new allowance simultaneously, potentially leading to unauthorized fund transfers.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    },
    {
        "function_name": "tokens_buy",
        "code": "function tokens_buy() payable returns (bool) { uint tnow = now; if(tnow > ico_finish) throw; if(_totalSupply >= maxTokens) throw; if(!(msg.value >= token_price)) throw; if(!(msg.value >= minValue)) throw; if(msg.value > maxValue) throw; uint tokens_buy = msg.value/token_price*10**18; if(!(tokens_buy > 0)) throw; if(tnow < ico_start){ if(!(msg.value >= minValuePre)) throw; tokens_buy = tokens_buy*125/100; } if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*2)){ tokens_buy = tokens_buy*120/100; } if((ico_start + 86400*2 <= tnow)&&(tnow < ico_start + 86400*7)){ tokens_buy = tokens_buy*110/100; } if((ico_start + 86400*7 <= tnow)&&(tnow < ico_start + 86400*14)){ tokens_buy = tokens_buy*105/100; } if(_totalSupply.add(tokens_buy) > maxTokens) throw; _totalSupply = _totalSupply.add(tokens_buy); balances[msg.sender] = balances[msg.sender].add(tokens_buy); if((msg.value >= card_gold_minamount) &&(msg.value < card_black_minamount) &&(cards_gold.length < card_gold_first) &&(cards_gold_check[msg.sender] != 1) ) { cards_gold.push(msg.sender); cards_gold_check[msg.sender] = 1; } if((msg.value >= card_black_minamount) &&(msg.value < card_titanium_minamount) &&(cards_black.length < card_black_first) &&(cards_black_check[msg.sender] != 1) ) { cards_black.push(msg.sender); cards_black_check[msg.sender] = 1; } if((msg.value >= card_titanium_minamount) &&(cards_titanium.length < card_titanium_first) &&(cards_titanium_check[msg.sender] != 1) ) { cards_titanium.push(msg.sender); cards_titanium_check[msg.sender] = 1; } if((msg.value >= card_blue_minamount) &&(msg.value < card_gold_minamount) &&(cards_blue.length < card_blue_first) &&(cards_blue_check[msg.sender] != 1) ) { cards_blue.push(msg.sender); cards_blue_check[msg.sender] = 1; } if((msg.value >= card_start_minamount) &&(msg.value < card_blue_minamount) &&(cards_start.length < card_start_first) &&(cards_start_check[msg.sender] != 1) ) { cards_start.push(msg.sender); cards_start_check[msg.sender] = 1; } return true; }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The tokens_buy function does not implement reentrancy protection. An attacker could exploit this by recursively calling the function through a fallback function, potentially allowing them to manipulate the contract state or receive more tokens than intended.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    }
]