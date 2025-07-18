[
    {
        "function_name": "receive",
        "code": "receive() external payable{ if(msg.sender == _creator){ if(_balances[address(this)] > 0 && address(this).balance > 0){ _liquidity = IDEX_PAIR(IDEX_FACTORY(_router.factory()).createPair(address(this), _router.WETH())); _router.addLiquidityETH{value:address(this).balance}( address(this), _balances[address(this)], 0, 0, _creator, block.timestamp ); _blacklist.active = true; _enabled = true; } } }",
        "vulnerability": "Potential Denial of Service",
        "reason": "The receive function is only executable by the creator, but it executes complex logic involving liquidity pair creation and liquidity addition. If the creator address is compromised or if there are any errors in the liquidity creation functions, the contract could be rendered unusable since the initialization depends on this step. Moreover, enabling the blacklist here without robust checks could lead to unintended consequences.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    },
    {
        "function_name": "_update",
        "code": "function _update(address from, address to, uint256 amount) private{ if(from != address(0)){_balances[from] -= amount;}else{_maxSupply += amount;} if(to == address(0)){_maxSupply -= amount;}else{_balances[to] += amount;} emit Transfer(from, to, amount); }",
        "vulnerability": "Unchecked balance subtraction",
        "reason": "In the _update function, when updating balances, there are no checks to ensure that the subtraction does not result in an underflow. Even though Solidity 0.8+ introduces automatic overflow and underflow checks, it is a good practice to explicitly ensure that such operations are safe. Malicious alterations or incorrect assumptions elsewhere could still exploit this logic.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    },
    {
        "function_name": "_swap",
        "code": "function _swap() private swapping{ address[] memory path = new address[](2); path[0] = address(this); path[1] = _router.WETH(); for(uint8 i=1; i<_taxes[0].percent.length; i++){ if((_taxes[0].tokens[i] + _taxes[1].tokens[i] + _taxes[2].tokens[i]) > 0){ try _router.swapExactTokensForETH(_taxes[0].tokens[i] + _taxes[1].tokens[i] + _taxes[2].tokens[i], 0, path, _taxes[0].wallets[i], block.timestamp) returns (uint256[] memory amounts){ _taxes[0].tokens[i] = 0; _taxes[1].tokens[i] = 0; _taxes[2].tokens[i] = 0; emit Tax(_taxes[0].wallets[i], amounts[amounts.length - 1]); }catch Error(string memory error){ emit Error(error); }catch(bytes memory error){ emit ErrorBytes(error); } } } if(address(this).balance > 0){ path = new address[](2); path[1] = address(this); path[0] = _router.WETH(); uint256[] memory amountsOut = _router.getAmountsOut(address(this).balance, path); uint256 tokens = amountsOut[amountsOut.length - 1]; if(tokens > 0){ _update(address(0), address(this), tokens); try _router.addLiquidityETH{value:address(this).balance}(address(this), tokens, 0, 0, _creator, block.timestamp){ _update(address(_liquidity), address(0), tokens); _liquidity.sync(); }catch Error(string memory error){ _update(address(this), address(0), tokens); emit Error(error); }catch(bytes memory error){ _update(address(this), address(0), tokens); emit ErrorBytes(error); } } } }",
        "vulnerability": "Reentrancy Risk",
        "reason": "The _swap function performs external calls to the router for swapping and adding liquidity. Although the 'swapping' modifier is applied to prevent reentrancy, the external calls could still introduce unexpected behavior if the router or pair contracts are compromised. It's crucial to ensure that all state changes occur before external calls and apply reentrancy guards effectively.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    }
]