[
    {
        "function_name": "removeOrder",
        "code": "function removeOrder(uint256 indexOfOrder) public { if (indexOfOrder >= _userActions.length) return; require(_userActions[indexOfOrder].user == msg.sender || msg.sender == owner() || msg.sender == address(this)); if(msg.sender != address(this)){ _userActions[indexOfOrder].user.call{value: _transactionFee}(\"\"); } for (uint i = indexOfOrder; i<_userActions.length-1; i++){ _userActions[i] = _userActions[i+1]; } _userActions.pop(); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function removeOrder makes an external call to a user-provided address before completing the important action of removing an order from _userActions. This allows for reentrancy attacks where a malicious user could re-enter the function and manipulate the _userActions array.",
        "file_name": "0x12d82d7cf17d909fb5808707136200ed200b6d52.sol"
    },
    {
        "function_name": "removeFromPoolInstantly",
        "code": "function removeFromPoolInstantly(uint256 amountToRemove, swapInfoEntry[] memory swapInfo) public { require(balanceOf(msg.sender) > 0); require(amountToRemove > 0); require(amountToRemove <= balanceOf(msg.sender)); require(swapInfo.length == _tokensHeld.length); _burn(msg.sender, amountToRemove); if(balanceOf(msg.sender) == 0){ _totalHolders--; } uint256 userShare = amountToRemove * 10**18 / (totalSupply() + amountToRemove); uint256 wethPayout = IERC20(WETHAddress).balanceOf(address(this)) * userShare / 10**18; address[] memory tokensHeldSnapshot = _tokensHeld; for (uint i = 0; i < tokensHeldSnapshot.length; i++){ require(swapInfo[i].token == tokensHeldSnapshot[i]); if((swapInfo[i].toWETHMinimumAmountOut == 0 && swapInfo[i].fromWETHMinimumAmountOut == 0) == false){ IERC20 tokenContract = IERC20(tokensHeldSnapshot[i]); uint256 wethRecieved = _swapTokens( swapInfo[i].pathToWETHV2, swapInfo[i].pathToWETHV3, tokenContract.balanceOf(address(this)) * userShare / 10**18, swapInfo[i].toWETHMinimumAmountOut ); wethPayout += wethRecieved; } } uint256 poolOwnerFeeAmount = wethPayout * _poolFee / 10**18; uint256 factoryFeeAmount = wethPayout * _factoryFee / 10**18; uint256 amountToPayToUser = wethPayout - factoryFeeAmount - poolOwnerFeeAmount; IWETH WETHContract = IWETH(WETHAddress); IERC20(WETHAddress).transfer(owner(), poolOwnerFeeAmount); processFee(factoryFeeAmount); WETHContract.withdraw(amountToPayToUser); msg.sender.call{value: amountToPayToUser}(\"\"); emit feePaidToOwner(msg.sender, owner(), poolOwnerFeeAmount); emit poolRemovedFrom(msg.sender, amountToRemove, amountToPayToUser); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The removeFromPoolInstantly function makes an external call to msg.sender after burning tokens and calculating the payout, which could allow a reentrancy attack where the attacker drains the contract by re-entering before state changes are finalized.",
        "file_name": "0x12d82d7cf17d909fb5808707136200ed200b6d52.sol"
    },
    {
        "function_name": "submitOrder",
        "code": "function submitOrder(uint256 amount, uint256 deadline, bool deposit) public payable{ if(deposit){ require(msg.value > _transactionFee); require(acceptingNewDeposits == true); IWETH WETHContract = IWETH(WETHAddress); WETHContract.deposit{value: msg.value - _transactionFee}(); IERC20(WETHAddress).transfer(msg.sender, msg.value - _transactionFee); } else { require(amount <= balanceOf(msg.sender)); require(msg.value == _transactionFee); } _userActions.push(userInteractionInfo(msg.sender, deposit ? msg.value - _transactionFee : amount, deposit, deadline)); }",
        "vulnerability": "Incorrect ETH Handling",
        "reason": "The function submitOrder allows a deposit with ETH but immediately transfers WETH back to the msg.sender, potentially creating a scenario where the deposited ETH is not properly accounted, causing inconsistencies in the contract's balance management.",
        "file_name": "0x12d82d7cf17d909fb5808707136200ed200b6d52.sol"
    }
]