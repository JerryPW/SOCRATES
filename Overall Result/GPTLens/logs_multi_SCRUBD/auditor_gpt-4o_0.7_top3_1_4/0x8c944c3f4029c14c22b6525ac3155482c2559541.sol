[
    {
        "function_name": "BDSM_Presale",
        "code": "function BDSM_Presale(address _tokenAddress, address _owner, address _stopScamHolder) { owner = _owner; sharesTokenAddress = token(_tokenAddress); safeContract = _stopScamHolder; }",
        "vulnerability": "Unrestricted access to constructor",
        "reason": "The constructor does not have any access controls, allowing anyone to deploy a contract with their specified parameters. This could lead to phishing attacks where an attacker deploys a similar contract and tricks users into sending funds.",
        "file_name": "0x8c944c3f4029c14c22b6525ac3155482c2559541.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable { tokenFree = sharesTokenAddress.balanceOf(this); if (now < presaleStart_6_December) { msg.sender.transfer(msg.value); } else if (now > presaleStop_13_December) { msg.sender.transfer(msg.value); if(!tokensWithdrawn){ sharesTokenAddress.transfer(safeContract, sharesTokenAddress.balanceOf(this)); tokenFree = sharesTokenAddress.balanceOf(this); tokensWithdrawn = true; presaleClosed = true; } } else if (presaleClosed) { msg.sender.transfer(msg.value); } else { uint256 tokenToBuy = msg.value / realPrice * coeff; if(tokenToBuy <= 0) msg.sender.transfer(msg.value); require(tokenToBuy > 0); uint256 actualETHTransfer = tokenToBuy * realPrice / coeff; if (tokenFree >= tokenToBuy) { owner.transfer(actualETHTransfer); if (msg.value > actualETHTransfer){ msg.sender.transfer(msg.value - actualETHTransfer); } sharesTokenAddress.transfer(msg.sender, tokenToBuy); tokenSold += tokenToBuy; tokenFree -= tokenToBuy; if(tokenFree==0) presaleClosed = true; } else { uint256 sendETH = tokenFree * realPrice / coeff; owner.transfer(sendETH); sharesTokenAddress.transfer(msg.sender, tokenFree); msg.sender.transfer(msg.value - sendETH); tokenSold += tokenFree; tokenFree = sharesTokenAddress.balanceOf(this); presaleClosed = true; } } TokenFree(tokenFree); PresaleClosed(presaleClosed); }",
        "vulnerability": "Reentrancy vulnerability in token purchase logic",
        "reason": "The fallback function uses msg.sender.transfer() in multiple locations without using reentrancy guards. If sharesTokenAddress allows reentrant calls, an attacker can exploit this by performing a reentrancy attack to drain the contract's balance.",
        "file_name": "0x8c944c3f4029c14c22b6525ac3155482c2559541.sol"
    },
    {
        "function_name": "fallback function",
        "code": "function() payable { tokenFree = sharesTokenAddress.balanceOf(this); if (now < presaleStart_6_December) { msg.sender.transfer(msg.value); } else if (now > presaleStop_13_December) { msg.sender.transfer(msg.value); if(!tokensWithdrawn){ sharesTokenAddress.transfer(safeContract, sharesTokenAddress.balanceOf(this)); tokenFree = sharesTokenAddress.balanceOf(this); tokensWithdrawn = true; presaleClosed = true; } } else if (presaleClosed) { msg.sender.transfer(msg.value); } else { uint256 tokenToBuy = msg.value / realPrice * coeff; if(tokenToBuy <= 0) msg.sender.transfer(msg.value); require(tokenToBuy > 0); uint256 actualETHTransfer = tokenToBuy * realPrice / coeff; if (tokenFree >= tokenToBuy) { owner.transfer(actualETHTransfer); if (msg.value > actualETHTransfer){ msg.sender.transfer(msg.value - actualETHTransfer); } sharesTokenAddress.transfer(msg.sender, tokenToBuy); tokenSold += tokenToBuy; tokenFree -= tokenToBuy; if(tokenFree==0) presaleClosed = true; } else { uint256 sendETH = tokenFree * realPrice / coeff; owner.transfer(sendETH); sharesTokenAddress.transfer(msg.sender, tokenFree); msg.sender.transfer(msg.value - sendETH); tokenSold += tokenFree; tokenFree = sharesTokenAddress.balanceOf(this); presaleClosed = true; } } TokenFree(tokenFree); PresaleClosed(presaleClosed); }",
        "vulnerability": "Incorrect Ether value transfer calculation",
        "reason": "The calculation of the actualETHTransfer may lead to incorrect transfers due to precision issues when using integer arithmetic with realPrice, which is not an integer. This miscalculation can result in either overpayment or underpayment to the contract, leading to financial losses.",
        "file_name": "0x8c944c3f4029c14c22b6525ac3155482c2559541.sol"
    }
]