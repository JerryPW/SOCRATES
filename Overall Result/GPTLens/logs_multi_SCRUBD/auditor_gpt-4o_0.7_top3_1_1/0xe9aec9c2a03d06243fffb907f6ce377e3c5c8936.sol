[
    {
        "function_name": "withdraw",
        "code": "function withdraw() onlyOwner returns (bool result) { owner.send(this.balance); return true; }",
        "vulnerability": "Unsafe usage of send() for Ether transfer",
        "reason": "The use of send() for transferring Ether is unsafe due to its fixed gas stipend, which can potentially fail, leaving Ether stuck in the contract. This can be exploited by manipulating the gas costs, preventing the withdrawal of funds.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    },
    {
        "function_name": "approve",
        "code": "function approve(address _spender, uint256 _amount) returns (bool success) { allowed[msg.sender][_spender] = _amount; Approval(msg.sender, _spender, _amount); return true; }",
        "vulnerability": "Allowance race condition",
        "reason": "The approve function is vulnerable to the well-known 'ERC20 approve/transferFrom race condition'. An attacker can exploit this by front-running a transaction to change the allowance before the original holder can update it, leading to possible double-spending.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    },
    {
        "function_name": "tokens_buy",
        "code": "function tokens_buy() payable returns (bool) { uint tnow = now; if(tnow > ico_finish) throw; if(_totalSupply >= maxTokens) throw; if(!(msg.value >= token_price)) throw; if(!(msg.value >= minValue)) throw; if(msg.value > maxValue) throw; uint tokens_buy = msg.value/token_price*10**18; if(!(tokens_buy > 0)) throw; if(tnow < ico_start){ if(!(msg.value >= minValuePre)) throw; tokens_buy = tokens_buy*125/100; } if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*2)){ tokens_buy = tokens_buy*120/100; } if((ico_start + 86400*2 <= tnow)&&(tnow < ico_start + 86400*7)){ tokens_buy = tokens_buy*110/100; } if((ico_start + 86400*7 <= tnow)&&(tnow < ico_start + 86400*14)){ tokens_buy = tokens_buy*105/100; } if(_totalSupply.add(tokens_buy) > maxTokens) throw; _totalSupply = _totalSupply.add(tokens_buy); balances[msg.sender] = balances[msg.sender].add(tokens_buy); if((msg.value >= card_gold_minamount) &&(msg.value < card_black_minamount) &&(cards_gold.length < card_gold_first) &&(cards_gold_check[msg.sender] != 1) ) { cards_gold.push(msg.sender); cards_gold_check[msg.sender] = 1; } if((msg.value >= card_black_minamount) &&(msg.value < card_titanium_minamount) &&(cards_black.length < card_black_first) &&(cards_black_check[msg.sender] != 1) ) { cards_black.push(msg.sender); cards_black_check[msg.sender] = 1; } if((msg.value >= card_titanium_minamount) &&(cards_titanium.length < card_titanium_first) &&(cards_titanium_check[msg.sender] != 1) ) { cards_titanium.push(msg.sender); cards_titanium_check[msg.sender] = 1; } if((msg.value >= card_blue_minamount) &&(msg.value < card_gold_minamount) &&(cards_blue.length < card_blue_first) &&(cards_blue_check[msg.sender] != 1) ) { cards_blue.push(msg.sender); cards_blue_check[msg.sender] = 1; } if((msg.value >= card_start_minamount) &&(msg.value < card_blue_minamount) &&(cards_start.length < card_start_first) &&(cards_start_check[msg.sender] != 1) ) { cards_start.push(msg.sender); cards_start_check[msg.sender] = 1; } return true; }",
        "vulnerability": "Incorrect token price calculation",
        "reason": "The token price calculation is incorrect due to integer division. The expression '1/400*10**18' results in zero because of integer division, potentially allowing tokens to be bought at no cost. This vulnerability can be exploited to effectively purchase tokens for free, bypassing the intended price mechanism.",
        "file_name": "0xe9aec9c2a03d06243fffb907f6ce377e3c5c8936.sol"
    }
]