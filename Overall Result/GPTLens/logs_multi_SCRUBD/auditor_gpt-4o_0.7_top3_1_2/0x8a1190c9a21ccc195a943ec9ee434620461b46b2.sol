[
    {
        "function_name": "withdrawBalance",
        "code": "function withdrawBalance() external onlyLeader { leaderAddress.transfer(this.balance); }",
        "vulnerability": "Unsafe Transfer of Ether",
        "reason": "The function withdrawBalance allows the transfer of the entire contract balance to the leaderAddress without any checks on the transfer success. This can result in loss of funds if the transfer fails due to exceeding gas limits or if the leaderAddress is a contract with a fallback function that reverts transactions. Additionally, there's no reentrancy protection, which could be exploited if the leaderAddress is a malicious contract.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    },
    {
        "function_name": "withdrawERC20Balance",
        "code": "function withdrawERC20Balance(uint256 amount) external onlyLeader { uint256 realTotal = erc20.balanceOf(this); require((realTotal - (totalPromo + totalBalance - totalUsed)) >= amount); erc20.transfer(leaderAddress, amount); totalBalance -= amount; totalUsed -= amount; }",
        "vulnerability": "Arithmetic Underflow and Incorrect Balance Management",
        "reason": "In the withdrawERC20Balance function, there is a risk of arithmetic underflow when updating totalBalance and totalUsed, as no checks are in place to ensure that these values do not become negative. Additionally, the condition for transferring ERC20 tokens relies on an inaccurate calculation that could lead to transferring more tokens than the available balance, especially if totalBalance and totalUsed are manipulated.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    },
    {
        "function_name": "orderOnSaleAuction",
        "code": "function orderOnSaleAuction(uint256 _heroId, uint256 orderAmount) public { require(ownerIndexToERC20Balance[msg.sender] >= orderAmount); address saller = saleAuction.getSeller(_heroId); uint256 price = saleAuction.getCurrentPrice(_heroId,1); require(price <= orderAmount && saller != address(0)); if(saleAuction.order(_heroId, orderAmount, msg.sender) && orderAmount > 0) { ownerIndexToERC20Balance[msg.sender] -= orderAmount; ownerIndexToERC20Used[msg.sender] += orderAmount; if(saller == address(this)) { totalUsed += orderAmount; } else { uint256 cut = _computeCut(price); totalUsed += (orderAmount - price + cut); ownerIndexToERC20Balance[saller] += price - cut; } } }",
        "vulnerability": "ERC20 Approval Front-Running Vulnerability",
        "reason": "The function orderOnSaleAuction is vulnerable to a front-running attack where the approval of ERC20 tokens can be manipulated. Since the function does not lock the orderAmount during the transaction process, an attacker could manipulate the balanceOf or allowance of the ERC20 tokens in between the calls to check and transfer the tokens, leading to potential theft or misallocation of tokens.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    }
]