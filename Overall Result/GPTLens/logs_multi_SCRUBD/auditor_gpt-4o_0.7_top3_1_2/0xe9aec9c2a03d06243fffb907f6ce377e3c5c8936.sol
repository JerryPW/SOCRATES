[
    {
        "function_name": "withdraw",
        "code": "function withdraw() onlyOwner returns (bool result) { owner.send(this.balance); return true; }",
        "vulnerability": "Unsafe Ether Transfer",
        "reason": "The withdraw function uses address.send() which forwards only 2300 gas to the receiver, potentially causing it to fail if the recipient is a contract with a fallback function that requires more gas. This could lead to Ether being stuck in the contract. Additionally, there is no check to ensure the send was successful, meaning the function will return true even if the transfer fails. Using address.call.value() or address.transfer() with proper error handling is recommended.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _amount) returns (bool success) { allowed[msg.sender][_spender] = _amount; Approval(msg.sender, _spender, _amount); return true; }",
        "vulnerability": "Race Condition with approve",
        "reason": "The approve function does not prevent race conditions and allows the possibility of the 'approval race condition' attack. If a spender is approved for a certain amount and spends it, they could quickly call approve again before the allowance is reset, leading to double-spending. A better practice would be to first set the spender's allowance to zero and then set the desired value.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    },
    {
        "function_name": "tokens_buy",
        "code": "function tokens_buy() payable returns (bool) { uint tnow = now; if(tnow > ico_finish) throw; if(_totalSupply >= maxTokens) throw; if(!(msg.value >= token_price)) throw; if(!(msg.value >= minValue)) throw; if(msg.value > maxValue) throw; uint tokens_buy = msg.value/token_price*10**18; if(!(tokens_buy > 0)) throw; if(tnow < ico_start){ if(!(msg.value >= minValuePre)) throw; tokens_buy = tokens_buy*125/100; } if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*2)){ tokens_buy = tokens_buy*120/100; } if((ico_start + 86400*2 <= tnow)&&(tnow < ico_start + 86400*7)){ tokens_buy = tokens_buy*110/100; } if((ico_start + 86400*7 <= tnow)&&(tnow < ico_start + 86400*14)){ tokens_buy = tokens_buy*105/100; } if(_totalSupply.add(tokens_buy) > maxTokens) throw; _totalSupply = _totalSupply.add(tokens_buy); balances[msg.sender] = balances[msg.sender].add(tokens_buy); if((msg.value >= card_gold_minamount) &&(msg.value < card_black_minamount) &&(cards_gold.length < card_gold_first) &&(cards_gold_check[msg.sender] != 1) ) { cards_gold.push(msg.sender); cards_gold_check[msg.sender] = 1; } if((msg.value >= card_black_minamount) &&(msg.value < card_titanium_minamount) &&(cards_black.length < card_black_first) &&(cards_black_check[msg.sender] != 1) ) { cards_black.push(msg.sender); cards_black_check[msg.sender] = 1; } if((msg.value >= card_titanium_minamount) &&(cards_titanium.length < card_titanium_first) &&(cards_titanium_check[msg.sender] != 1) ) { cards_titanium.push(msg.sender); cards_titanium_check[msg.sender] = 1; } if((msg.value >= card_blue_minamount) &&(msg.value < card_gold_minamount) &&(cards_blue.length < card_blue_first) &&(cards_blue_check[msg.sender] != 1) ) { cards_blue.push(msg.sender); cards_blue_check[msg.sender] = 1; } if((msg.value >= card_start_minamount) &&(msg.value < card_blue_minamount) &&(cards_start.length < card_start_first) &&(cards_start_check[msg.sender] != 1) ) { cards_start.push(msg.sender); cards_start_check[msg.sender] = 1; } return true; }",
        "vulnerability": "Incorrect Token Pricing",
        "reason": "The token_price is defined as 1/400*10**18, which evaluates to zero due to integer division in Solidity. This means that the token price is effectively set to zero, allowing anyone to purchase tokens for free. This is a critical vulnerability that would lead to the loss of funds and devaluation of the token.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    }
]