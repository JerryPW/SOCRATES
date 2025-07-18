[
    {
        "function_name": "function()",
        "code": "function() payable { tokenFree = sharesTokenAddress.balanceOf(this); if (now < startICO) { msg.sender.transfer(msg.value); } else if (now > (stopICO + 1)) { msg.sender.transfer(msg.value); crowdsaleClosed = true; } else if (crowdsaleClosed) { msg.sender.transfer(msg.value); } else { uint256 tokenToBuy = msg.value / price * coeff; require(tokenToBuy > 0); uint256 actualETHTransfer = tokenToBuy * price / coeff; if (tokenFree >= tokenToBuy) { owner.transfer(actualETHTransfer); if (msg.value > actualETHTransfer){ msg.sender.transfer(msg.value - actualETHTransfer); } sharesTokenAddress.transfer(msg.sender, tokenToBuy); tokenSold += tokenToBuy; tokenFree -= tokenToBuy; if(tokenFree==0) crowdsaleClosed = true; } else { uint256 sendETH = tokenFree * price / coeff; owner.transfer(sendETH); sharesTokenAddress.transfer(msg.sender, tokenFree); msg.sender.transfer(msg.value - sendETH); tokenSold += tokenFree; tokenFree = 0; crowdsaleClosed = true; } } TokenFree(tokenFree); CrowdsaleClosed(crowdsaleClosed); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function performs external calls to the msg.sender to transfer Ether before updating the state variables (e.g., tokenSold, tokenFree). This can be exploited by attackers to perform reentrancy attacks, allowing them to repeatedly call the function and drain funds or manipulate token sales before the state is updated.",
        "file_name": "0x6cd171ef32b2ffa2b54481bea9d72692cd44f053.sol"
    },
    {
        "function_name": "function()",
        "code": "function() payable { tokenFree = sharesTokenAddress.balanceOf(this); if (now < startICO) { msg.sender.transfer(msg.value); } else if (now > (stopICO + 1)) { msg.sender.transfer(msg.value); crowdsaleClosed = true; } else if (crowdsaleClosed) { msg.sender.transfer(msg.value); } else { uint256 tokenToBuy = msg.value / price * coeff; require(tokenToBuy > 0); uint256 actualETHTransfer = tokenToBuy * price / coeff; if (tokenFree >= tokenToBuy) { owner.transfer(actualETHTransfer); if (msg.value > actualETHTransfer){ msg.sender.transfer(msg.value - actualETHTransfer); } sharesTokenAddress.transfer(msg.sender, tokenToBuy); tokenSold += tokenToBuy; tokenFree -= tokenToBuy; if(tokenFree==0) crowdsaleClosed = true; } else { uint256 sendETH = tokenFree * price / coeff; owner.transfer(sendETH); sharesTokenAddress.transfer(msg.sender, tokenFree); msg.sender.transfer(msg.value - sendETH); tokenSold += tokenFree; tokenFree = 0; crowdsaleClosed = true; } } TokenFree(tokenFree); CrowdsaleClosed(crowdsaleClosed); }",
        "vulnerability": "Unexpected Ether reception",
        "reason": "The fallback function is marked as payable, allowing the contract to accept Ether from any sender at any time. This lack of restriction could lead to accidental or malicious Ether transfers, causing unexpected contract behavior or allowing attackers to manipulate the contract state by forcing it to execute under certain conditions.",
        "file_name": "0x6cd171ef32b2ffa2b54481bea9d72692cd44f053.sol"
    },
    {
        "function_name": "unsoldTokensBack",
        "code": "function unsoldTokensBack(){ require(crowdsaleClosed); require(msg.sender == owner); sharesTokenAddress.transfer(owner, sharesTokenAddress.balanceOf(this)); tokenFree = 0; }",
        "vulnerability": "Lack of event emission for critical actions",
        "reason": "The unsoldTokensBack function does not emit any event after transferring tokens back to the owner. This lack of transparency can make it difficult to audit the function's execution and could result in loss of accountability, making it harder to detect or prove misuse or unexpected behavior.",
        "file_name": "0x6cd171ef32b2ffa2b54481bea9d72692cd44f053.sol"
    }
]