[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { address steve = 0x925B10044669F6b98796881Dd62536E02c782D74; address samuraicats = 0x1405A3B36E7dc20c53541F4078Da28652Bf2A3Ad; require ( msg.sender == steve || msg.sender == samuraicats , 'not allowed'); uint256 balance = address(this).balance; uint256 steveBal = balance.mul(15).div(100); uint256 samuraiBal = balance.mul(85).div(100); payable(steve).transfer(steveBal); payable(samuraicats).transfer(samuraiBal); address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; uint256 wethBalance = Ierc20(weth).balanceOf(address(this)); steveBal = wethBalance.mul(15).div(100); samuraiBal = wethBalance.mul(85).div(100); Ierc20(weth).transfer(steve, steveBal); Ierc20(weth).transfer(samuraicats, samuraiBal); }",
        "vulnerability": "No access control on function",
        "reason": "The withdraw function is protected only by a require statement that checks the caller against two specified addresses. This allows the function to be executed by anyone with access to one of these private keys, potentially enabling unauthorized withdrawals if the keys are leaked or compromised. Furthermore, there is no protection against reentrancy attacks, as external calls are made to transfer Ether and ERC20 tokens without updating the state beforehand.",
        "file_name": "0x272922870b1b23db61e41f7aa2c6abf976b6a4ab.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { address steve = 0x925B10044669F6b98796881Dd62536E02c782D74; address samuraicats = 0x1405A3B36E7dc20c53541F4078Da28652Bf2A3Ad; require ( msg.sender == steve || msg.sender == samuraicats , 'not allowed'); uint256 balance = address(this).balance; uint256 steveBal = balance.mul(15).div(100); uint256 samuraiBal = balance.mul(85).div(100); payable(steve).transfer(steveBal); payable(samuraicats).transfer(samuraiBal); address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; uint256 wethBalance = Ierc20(weth).balanceOf(address(this)); steveBal = wethBalance.mul(15).div(100); samuraiBal = wethBalance.mul(85).div(100); Ierc20(weth).transfer(steve, steveBal); Ierc20(weth).transfer(samuraicats, samuraiBal); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function makes external calls to transfer Ether and ERC20 tokens before updating the contract's state. An attacker could exploit this by using a reentrancy attack to call the withdraw function multiple times before the state is updated, potentially draining funds from the contract.",
        "file_name": "0x272922870b1b23db61e41f7aa2c6abf976b6a4ab.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { address steve = 0x925B10044669F6b98796881Dd62536E02c782D74; address samuraicats = 0x1405A3B36E7dc20c53541F4078Da28652Bf2A3Ad; require ( msg.sender == steve || msg.sender == samuraicats , 'not allowed'); uint256 balance = address(this).balance; uint256 steveBal = balance.mul(15).div(100); uint256 samuraiBal = balance.mul(85).div(100); payable(steve).transfer(steveBal); payable(samuraicats).transfer(samuraiBal); address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; uint256 wethBalance = Ierc20(weth).balanceOf(address(this)); steveBal = wethBalance.mul(15).div(100); samuraiBal = wethBalance.mul(85).div(100); Ierc20(weth).transfer(steve, steveBal); Ierc20(weth).transfer(samuraicats, samuraiBal); }",
        "vulnerability": "Balance calculation and division rounding",
        "reason": "The division of balances using mul and div functions could lead to rounding errors, resulting in a small amount of Ether or tokens being left in the contract. This discrepancy arises when the total balance is not perfectly divisible by the percentages, potentially leading to loss of funds.",
        "file_name": "0x272922870b1b23db61e41f7aa2c6abf976b6a4ab.sol"
    }
]