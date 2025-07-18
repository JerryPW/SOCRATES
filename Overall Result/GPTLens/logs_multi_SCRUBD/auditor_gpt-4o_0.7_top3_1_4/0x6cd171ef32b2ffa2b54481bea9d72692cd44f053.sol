[
    {
        "function_name": "function()",
        "code": "function() payable { tokenFree = sharesTokenAddress.balanceOf(this); if (now < startICO) { msg.sender.transfer(msg.value); } else if (now > (stopICO + 1)) { msg.sender.transfer(msg.value); crowdsaleClosed = true; } else if (crowdsaleClosed) { msg.sender.transfer(msg.value); } else { uint256 tokenToBuy = msg.value / price * coeff; require(tokenToBuy > 0); uint256 actualETHTransfer = tokenToBuy * price / coeff; if (tokenFree >= tokenToBuy) { owner.transfer(actualETHTransfer); if (msg.value > actualETHTransfer){ msg.sender.transfer(msg.value - actualETHTransfer); } sharesTokenAddress.transfer(msg.sender, tokenToBuy); tokenSold += tokenToBuy; tokenFree -= tokenToBuy; if(tokenFree==0) crowdsaleClosed = true; } else { uint256 sendETH = tokenFree * price / coeff; owner.transfer(sendETH); sharesTokenAddress.transfer(msg.sender, tokenFree); msg.sender.transfer(msg.value - sendETH); tokenSold += tokenFree; tokenFree = 0; crowdsaleClosed = true; } } TokenFree(tokenFree); CrowdsaleClosed(crowdsaleClosed); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function contains multiple external calls to transfer ETH and tokens before updating the state variables like tokenFree and crowdsaleClosed. This can allow reentrancy attacks where an attacker could recursively call the fallback function to drain funds or manipulate the contract state.",
        "file_name": "0x6cd171ef32b2ffa2b54481bea9d72692cd44f053.sol"
    },
    {
        "function_name": "unsoldTokensBack",
        "code": "function unsoldTokensBack(){ require(crowdsaleClosed); require(msg.sender == owner); sharesTokenAddress.transfer(owner, sharesTokenAddress.balanceOf(this)); tokenFree = 0; }",
        "vulnerability": "Lack of access control",
        "reason": "The unsoldTokensBack function allows the transfer of all tokens back to the owner's address, but only checks if the sender is the owner and if the crowdsale is closed. There is no restriction on when the owner can call this function after the crowdsale is closed, potentially allowing the owner to claim unsold tokens prematurely or inappropriately.",
        "file_name": "0x6cd171ef32b2ffa2b54481bea9d72692cd44f053.sol"
    },
    {
        "function_name": "function()",
        "code": "function() payable { tokenFree = sharesTokenAddress.balanceOf(this); if (now < startICO) { msg.sender.transfer(msg.value); } else if (now > (stopICO + 1)) { msg.sender.transfer(msg.value); crowdsaleClosed = true; } else if (crowdsaleClosed) { msg.sender.transfer(msg.value); } else { uint256 tokenToBuy = msg.value / price * coeff; require(tokenToBuy > 0); uint256 actualETHTransfer = tokenToBuy * price / coeff; if (tokenFree >= tokenToBuy) { owner.transfer(actualETHTransfer); if (msg.value > actualETHTransfer){ msg.sender.transfer(msg.value - actualETHTransfer); } sharesTokenAddress.transfer(msg.sender, tokenToBuy); tokenSold += tokenToBuy; tokenFree -= tokenToBuy; if(tokenFree==0) crowdsaleClosed = true; } else { uint256 sendETH = tokenFree * price / coeff; owner.transfer(sendETH); sharesTokenAddress.transfer(msg.sender, tokenFree); msg.sender.transfer(msg.value - sendETH); tokenSold += tokenFree; tokenFree = 0; crowdsaleClosed = true; } } TokenFree(tokenFree); CrowdsaleClosed(crowdsaleClosed); }",
        "vulnerability": "Incorrect time-based logic",
        "reason": "The fallback function uses block timestamp (now) for several conditional checks. This can be manipulated by miners to a certain extent, potentially allowing attackers to exploit the crowdsale process, either by extending or shortening the ICO period.",
        "file_name": "0x6cd171ef32b2ffa2b54481bea9d72692cd44f053.sol"
    }
]