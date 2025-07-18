[
    {
        "function_name": "withdrawBalance",
        "code": "function withdrawBalance() external onlyLeader { leaderAddress.transfer(this.balance); }",
        "vulnerability": "Unsafe Ether withdrawal",
        "reason": "The function allows the leader to withdraw all Ether from the contract without checks or limits, which means if the leader's private key is compromised, an attacker can drain all Ether from the contract.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    },
    {
        "function_name": "withdrawERC20Balance",
        "code": "function withdrawERC20Balance(uint256 amount) external onlyLeader { uint256 realTotal = erc20.balanceOf(this); require((realTotal - (totalPromo + totalBalance- totalUsed ) ) >=amount); erc20.transfer(leaderAddress, amount); totalBalance -=amount; totalUsed -=amount; }",
        "vulnerability": "Incorrect balance management",
        "reason": "The function reduces totalBalance and totalUsed by 'amount', allowing the leader to potentially withdraw more than the available balance if previous values are not correctly managed. This can lead to inconsistencies and potential loss of funds.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    },
    {
        "function_name": "orderOnSaleAuction",
        "code": "function orderOnSaleAuction( uint256 _heroId, uint256 orderAmount ) public { require(ownerIndexToERC20Balance[msg.sender] >= orderAmount); address saller = saleAuction.getSeller(_heroId); uint256 price = saleAuction.getCurrentPrice(_heroId,1); require( price <= orderAmount && saller != address(0)); if(saleAuction.order(_heroId, orderAmount, msg.sender) &&orderAmount >0 ){ ownerIndexToERC20Balance[msg.sender] -= orderAmount; ownerIndexToERC20Used[msg.sender] += orderAmount; if( saller == address(this)){ totalUsed +=orderAmount; }else{ uint256 cut = _computeCut(price); totalUsed += (orderAmount - price +cut); ownerIndexToERC20Balance[saller] += price -cut; } } }",
        "vulnerability": "ERC20 balance manipulation",
        "reason": "The function allows manipulation of internal account balances without requiring a successful transfer or settlement. This creates an opportunity for attackers to exploit discrepancies between actual and recorded balances, leading to potential fund mismanagement.",
        "file_name": "0x8a1190c9a21ccc195a943ec9ee434620461b46b2.sol"
    }
]