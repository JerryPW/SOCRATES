[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { address steve = 0x925B10044669F6b98796881Dd62536E02c782D74; address samuraicats = 0x1405A3B36E7dc20c53541F4078Da28652Bf2A3Ad; require ( msg.sender == steve || msg.sender == samuraicats , 'not allowed'); uint256 balance = address(this).balance; uint256 steveBal = balance.mul(15).div(100); uint256 samuraiBal = balance.mul(85).div(100); payable(steve).transfer(steveBal); payable(samuraicats).transfer(samuraiBal); address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; uint256 wethBalance = Ierc20(weth).balanceOf(address(this)); steveBal = wethBalance.mul(15).div(100); samuraiBal = wethBalance.mul(85).div(100); Ierc20(weth).transfer(steve, steveBal); Ierc20(weth).transfer(samuraicats, samuraiBal); }",
        "vulnerability": "Lack of Access Control",
        "reason": "The withdraw function only verifies that either 'steve' or 'samuraicats' is executing the function, but it does not ensure that the withdrawals are protected against reentrancy attacks. Additionally, the contract does not use any mechanisms to ensure that only valid calls are being made in the context of a larger system, such as verifying the origin of the funds or the purpose of the withdrawal. This could allow authorized addresses to trigger the function in unintended contexts.",
        "file_name": "0x272922870b1b23db61e41f7aa2c6abf976b6a4ab.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { address steve = 0x925B10044669F6b98796881Dd62536E02c782D74; address samuraicats = 0x1405A3B36E7dc20c53541F4078Da28652Bf2A3Ad; require ( msg.sender == steve || msg.sender == samuraicats , 'not allowed'); uint256 balance = address(this).balance; uint256 steveBal = balance.mul(15).div(100); uint256 samuraiBal = balance.mul(85).div(100); payable(steve).transfer(steveBal); payable(samuraicats).transfer(samuraiBal); address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; uint256 wethBalance = Ierc20(weth).balanceOf(address(this)); steveBal = wethBalance.mul(15).div(100); samuraiBal = wethBalance.mul(85).div(100); Ierc20(weth).transfer(steve, steveBal); Ierc20(weth).transfer(samuraicats, samuraiBal); }",
        "vulnerability": "Ether and ERC20 Balance Dependency",
        "reason": "The function divides the entire balance of Ether and WETH held by the contract without ensuring that there is any minimum threshold in the contract. If the balance is low, it could result in very small transfers that are not cost-effective or could potentially be rounded down to zero. Moreover, if the balance of the contract is zero or very low, it could lead to no transfer being made, which would be an inefficient use of gas.",
        "file_name": "0x272922870b1b23db61e41f7aa2c6abf976b6a4ab.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { address steve = 0x925B10044669F6b98796881Dd62536E02c782D74; address samuraicats = 0x1405A3B36E7dc20c53541F4078Da28652Bf2A3Ad; require ( msg.sender == steve || msg.sender == samuraicats , 'not allowed'); uint256 balance = address(this).balance; uint256 steveBal = balance.mul(15).div(100); uint256 samuraiBal = balance.mul(85).div(100); payable(steve).transfer(steveBal); payable(samuraicats).transfer(samuraiBal); address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; uint256 wethBalance = Ierc20(weth).balanceOf(address(this)); steveBal = wethBalance.mul(15).div(100); samuraiBal = wethBalance.mul(85).div(100); Ierc20(weth).transfer(steve, steveBal); Ierc20(weth).transfer(samuraicats, samuraiBal); }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function directly transfers Ether before performing all state changes, which makes it vulnerable to reentrancy attacks. An attacker could potentially re-enter the function through a fallback function, repeatedly withdrawing funds before the final state is reached. The lack of a reentrancy guard or pattern to update the state before transferring funds increases the risk of such an attack.",
        "file_name": "0x272922870b1b23db61e41f7aa2c6abf976b6a4ab.sol"
    }
]