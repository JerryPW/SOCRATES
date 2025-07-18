[
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { address steve = 0x925B10044669F6b98796881Dd62536E02c782D74; address samuraicats = 0x1405A3B36E7dc20c53541F4078Da28652Bf2A3Ad; require ( msg.sender == steve || msg.sender == samuraicats , 'not allowed'); uint256 balance = address(this).balance; uint256 steveBal = balance.mul(15).div(100); uint256 samuraiBal = balance.mul(85).div(100); payable(steve).transfer(steveBal); payable(samuraicats).transfer(samuraiBal); address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; uint256 wethBalance = Ierc20(weth).balanceOf(address(this)); steveBal = wethBalance.mul(15).div(100); samuraiBal = wethBalance.mul(85).div(100); Ierc20(weth).transfer(steve, steveBal); Ierc20(weth).transfer(samuraicats, samuraiBal); }",
        "vulnerability": "No reentrancy guard",
        "reason": "The withdraw function lacks a reentrancy guard, which means an attacker could potentially exploit this by re-entering the function before its completion, especially during the external calls to transfer Ether or WETH, and drain the contract's funds.",
        "file_name": "0x272922870b1b23db61e41f7aa2c6abf976b6a4ab.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { address steve = 0x925B10044669F6b98796881Dd62536E02c782D74; address samuraicats = 0x1405A3B36E7dc20c53541F4078Da28652Bf2A3Ad; require ( msg.sender == steve || msg.sender == samuraicats , 'not allowed'); uint256 balance = address(this).balance; uint256 steveBal = balance.mul(15).div(100); uint256 samuraiBal = balance.mul(85).div(100); payable(steve).transfer(steveBal); payable(samuraicats).transfer(samuraiBal); address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; uint256 wethBalance = Ierc20(weth).balanceOf(address(this)); steveBal = wethBalance.mul(15).div(100); samuraiBal = wethBalance.mul(85).div(100); Ierc20(weth).transfer(steve, steveBal); Ierc20(weth).transfer(samuraicats, samuraiBal); }",
        "vulnerability": "Incorrect use of SafeMath",
        "reason": "The function uses unchecked arithmetic operations (mul and div) without handling potential overflows or division by zero, especially with SafeMath's unchecked context. This can lead to incorrect calculations and potential exploitation by manipulating balance or wethBalance values.",
        "file_name": "0x272922870b1b23db61e41f7aa2c6abf976b6a4ab.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public { address steve = 0x925B10044669F6b98796881Dd62536E02c782D74; address samuraicats = 0x1405A3B36E7dc20c53541F4078Da28652Bf2A3Ad; require ( msg.sender == steve || msg.sender == samuraicats , 'not allowed'); uint256 balance = address(this).balance; uint256 steveBal = balance.mul(15).div(100); uint256 samuraiBal = balance.mul(85).div(100); payable(steve).transfer(steveBal); payable(samuraicats).transfer(samuraiBal); address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; uint256 wethBalance = Ierc20(weth).balanceOf(address(this)); steveBal = wethBalance.mul(15).div(100); samuraiBal = wethBalance.mul(85).div(100); Ierc20(weth).transfer(steve, steveBal); Ierc20(weth).transfer(samuraicats, samuraiBal); }",
        "vulnerability": "Potential gas limit and DoS attack",
        "reason": "The direct use of transfer for Ether and ERC20 tokens can lead to a situation where if the gas costs increase or if the receiving addresses have complex fallback functions, the transaction could fail, causing a denial of service. Using call with a gas stipend could mitigate this issue.",
        "file_name": "0x272922870b1b23db61e41f7aa2c6abf976b6a4ab.sol"
    }
]