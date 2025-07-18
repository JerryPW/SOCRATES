[
    {
        "function_name": "approve",
        "code": "function approve(address spender, uint256 amount) public override returns (bool) { _allowances[msg.sender][spender] = amount; emit Approval(msg.sender, spender, amount); return true; }",
        "vulnerability": "Missing Approval Event Front-Running Prevention",
        "reason": "The `approve` function can be exploited via front-running attacks where an attacker observes a transaction to approve a certain amount of tokens and quickly executes a transaction to spend tokens before the approval transaction is mined. This can lead to unauthorized token transfers.",
        "file_name": "0x097a5e3d974332aa5612675caaaeb117091dc743.sol"
    },
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address payable adr) public onlyOwner { owner = adr; emit OwnershipTransferred(adr); }",
        "vulnerability": "Ownership Transfer to Arbitrary Address",
        "reason": "The `transferOwnership` function allows transferring ownership to any arbitrary address, including non-human addresses like contracts that can lead to a loss of control over the contract. There is no verification to ensure the new owner is a valid EOAs (Externally Owned Accounts).",
        "file_name": "0x097a5e3d974332aa5612675caaaeb117091dc743.sol"
    },
    {
        "function_name": "swapBack",
        "code": "function swapBack() internal lockTheSwap { uint256 tokenBalance = _balances[address(this)]; uint256 tokensForLiquidity = tokenBalance.mul(toLiquidity).div(100).div(2); uint256 amountToSwap = tokenBalance.sub(tokensForLiquidity); swapTokensForEth(amountToSwap); uint256 totalEthBalance = address(this).balance; uint256 ethForSHIL = totalEthBalance.mul(toReflections).div(100); uint256 ethForUncle = totalEthBalance.mul(toMarketing).div(100); uint256 ethForLiquidity = totalEthBalance.mul(toLiquidity).div(100).div(2); if (totalEthBalance > 0){ payable(uncleWallet).transfer(ethForUncle); } try coolUncle.deposit{value: ethForSHIL}() {} catch {} if (tokensForLiquidity > 0){ addLiquidity(tokensForLiquidity, ethForLiquidity); } }",
        "vulnerability": "Reentrancy Attack Potential",
        "reason": "The `swapBack` function involves multiple external calls (to the router and CoolUncle contract) without checks-effects-interactions pattern, making it vulnerable to reentrancy attacks where an attacker could potentially exploit these external calls to manipulate contract state in their favor.",
        "file_name": "0x097a5e3d974332aa5612675caaaeb117091dc743.sol"
    }
]