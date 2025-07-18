[
    {
        "function_name": "Crowdsale",
        "code": "function Crowdsale(address _tokenAddress, address _owner, uint _timePeriod) { owner = _owner; sharesTokenAddress = token(_tokenAddress); periodICO = _timePeriod * 1 hours; stopICO = startICO + periodICO; }",
        "vulnerability": "Lack of input validation",
        "reason": "The constructor allows any address to be set as the owner without any validation. If an attacker can influence the address passed to the constructor, they could gain control over the contract, potentially leading to unauthorized token transfers.",
        "file_name": "0x6cd171ef32b2ffa2b54481bea9d72692cd44f053.sol"
    },
    {
        "function_name": "function() payable",
        "code": "function() payable { tokenFree = sharesTokenAddress.balanceOf(this); if (now < startICO) { msg.sender.transfer(msg.value); } else if (now > (stopICO + 1)) { msg.sender.transfer(msg.value); crowdsaleClosed = true; } else if (crowdsaleClosed) { msg.sender.transfer(msg.value); } else { uint256 tokenToBuy = msg.value / price * coeff; require(tokenToBuy > 0); uint256 actualETHTransfer = tokenToBuy * price / coeff; if (tokenFree >= tokenToBuy) { owner.transfer(actualETHTransfer); if (msg.value > actualETHTransfer){ msg.sender.transfer(msg.value - actualETHTransfer); } sharesTokenAddress.transfer(msg.sender, tokenToBuy); tokenSold += tokenToBuy; tokenFree -= tokenToBuy; if(tokenFree==0) crowdsaleClosed = true; } else { uint256 sendETH = tokenFree * price / coeff; owner.transfer(sendETH); sharesTokenAddress.transfer(msg.sender, tokenFree); msg.sender.transfer(msg.value - sendETH); tokenSold += tokenFree; tokenFree = 0; crowdsaleClosed = true; } } TokenFree(tokenFree); CrowdsaleClosed(crowdsaleClosed); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function transfers Ether to the msg.sender before updating the contract's state. This could allow an attacker to re-enter the function and manipulate the contract's state to their advantage, such as buying more tokens than they should be able to.",
        "file_name": "0x6cd171ef32b2ffa2b54481bea9d72692cd44f053.sol"
    },
    {
        "function_name": "unsoldTokensBack",
        "code": "function unsoldTokensBack(){ require(crowdsaleClosed); require(msg.sender == owner); sharesTokenAddress.transfer(owner, sharesTokenAddress.balanceOf(this)); tokenFree = 0; }",
        "vulnerability": "Potential token loss",
        "reason": "If the crowdsale is closed but tokens remaining in the contract are not transferred back to the owner's address, those tokens might remain locked in the contract, effectively being lost. This function relies on external token transfer logic, which could fail or be manipulated.",
        "file_name": "0x6cd171ef32b2ffa2b54481bea9d72692cd44f053.sol"
    }
]