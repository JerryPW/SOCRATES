[
    {
        "function_name": "withdraw",
        "code": "function withdraw() onlyOwner returns (bool result) { owner.send(this.balance); return true; }",
        "vulnerability": "Unsafe Ether transfer",
        "reason": "The use of 'send' for Ether transfer can lead to loss of funds as it only forwards 2300 gas, reverting on failure. It's recommended to use 'transfer' or 'call' with proper checks.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _amount) returns (bool success) { allowed[msg.sender][_spender] = _amount; Approval(msg.sender, _spender, _amount); return true; }",
        "vulnerability": "Allowance double-spend vulnerability",
        "reason": "This function does not protect against the race condition where the spender could use both the old and new allowance if they exploit the timing between transactions. This is a known issue with the ERC20 approve method. Use 'increaseAllowance' and 'decreaseAllowance' to mitigate this.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    },
    {
        "function_name": "tokens_buy",
        "code": "function tokens_buy() payable returns (bool) { uint tnow = now; if(tnow > ico_finish) throw; if(_totalSupply >= maxTokens) throw; if(!(msg.value >= token_price)) throw; if(!(msg.value >= minValue)) throw; if(msg.value > maxValue) throw; uint tokens_buy = msg.value/token_price*10**18; if(!(tokens_buy > 0)) throw; if(tnow < ico_start){ if(!(msg.value >= minValuePre)) throw; tokens_buy = tokens_buy*125/100; } if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*2)){ tokens_buy = tokens_buy*120/100; } if((ico_start + 86400*2 <= tnow)&&(tnow < ico_start + 86400*7)){ tokens_buy = tokens_buy*110/100; } if((ico_start + 86400*7 <= tnow)&&(tnow < ico_start + 86400*14)){ tokens_buy = tokens_buy*105/100; } if(_totalSupply.add(tokens_buy) > maxTokens) throw; _totalSupply = _totalSupply.add(tokens_buy); balances[msg.sender] = balances[msg.sender].add(tokens_buy); if((msg.value >= card_gold_minamount) &&(msg.value < card_black_minamount) &&(cards_gold.length < card_gold_first) &&(cards_gold_check[msg.sender] != 1) ) { cards_gold.push(msg.sender); cards_gold_check[msg.sender] = 1; } if((msg.value >= card_black_minamount) &&(msg.value < card_titanium_minamount) &&(cards_black.length < card_black_first) &&(cards_black_check[msg.sender] != 1) ) { cards_black.push(msg.sender); cards_black_check[msg.sender] = 1; } if((msg.value >= card_titanium_minamount) &&(cards_titanium.length < card_titanium_first) &&(cards_titanium_check[msg.sender] != 1) ) { cards_titanium.push(msg.sender); cards_titanium_check[msg.sender] = 1; } if((msg.value >= card_blue_minamount) &&(msg.value < card_gold_minamount) &&(cards_blue.length < card_blue_first) &&(cards_blue_check[msg.sender] != 1) ) { cards_blue.push(msg.sender); cards_blue_check[msg.sender] = 1; } if((msg.value >= card_start_minamount) &&(msg.value < card_blue_minamount) &&(cards_start.length < card_start_first) &&(cards_start_check[msg.sender] != 1) ) { cards_start.push(msg.sender); cards_start_check[msg.sender] = 1; } return true; }",
        "vulnerability": "Integer division and multiplication errors in token calculation",
        "reason": "The token price and bonus calculations use integer division and multiplication which can lead to incorrect token distribution due to rounding errors. This can be exploited during calculations of token bonuses, especially with fractional token prices.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    }
]