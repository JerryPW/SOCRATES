[
    {
        "function_name": "receive",
        "code": "receive() external payable{ if(msg.sender == _creator){ if(_balances[address(this)] > 0 && address(this).balance > 0){ _liquidity = IDEX_PAIR(IDEX_FACTORY(_router.factory()).createPair(address(this), _router.WETH())); _router.addLiquidityETH{value:address(this).balance}( address(this), _balances[address(this)], 0, 0, _creator, block.timestamp ); _blacklist.active = true; _enabled = true; } } }",
        "vulnerability": "Misuse of receive function to activate blacklist and enable trading",
        "reason": "The receive function is misused to activate the blacklist and enable trading when the creator sends ether. This can be exploited by the creator to manipulate the contract state unexpectedly, potentially enabling or disabling trading and blacklist in ways not anticipated by other participants.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    },
    {
        "function_name": "_update",
        "code": "function _update(address from, address to, uint256 amount) private{ if(from != address(0)){_balances[from] -= amount;}else{_maxSupply += amount;} if(to == address(0)){_maxSupply -= amount;}else{_balances[to] += amount;} emit Transfer(from, to, amount); }",
        "vulnerability": "Incorrect balance and supply management",
        "reason": "The _update function has incorrect logic for managing balances and total supply. When updating balances, it doesn't check for underflows, potentially causing negative balances. Moreover, the supply is manipulated without constraints, leading to inflation or deflation attacks where total supply can be artificially altered.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    },
    {
        "function_name": "_swap",
        "code": "function _swap() private swapping{ address[] memory path = new address[](2); path[0] = address(this); path[1] = _router.WETH(); for(uint8 i=1; i<_taxes[0].percent.length; i++){ if((_taxes[0].tokens[i] + _taxes[1].tokens[i] + _taxes[2].tokens[i]) > 0){ try _router.swapExactTokensForETH(_taxes[0].tokens[i] + _taxes[1].tokens[i] + _taxes[2].tokens[i], 0, path, _taxes[0].wallets[i], block.timestamp) returns (uint256[] memory amounts){ _taxes[0].tokens[i] = 0; _taxes[1].tokens[i] = 0; _taxes[2].tokens[i] = 0; emit Tax(_taxes[0].wallets[i], amounts[amounts.length - 1]); }catch Error(string memory error){ emit Error(error); }catch(bytes memory error){ emit ErrorBytes(error); } } } if(address(this).balance > 0){ path = new address[](2); path[1] = address(this); path[0] = _router.WETH(); uint256[] memory amountsOut = _router.getAmountsOut(address(this).balance, path); uint256 tokens = amountsOut[amountsOut.length - 1]; if(tokens > 0){ _update(address(0), address(this), tokens); try _router.addLiquidityETH{value:address(this).balance}(address(this), tokens, 0, 0, _creator, block.timestamp){ _update(address(_liquidity), address(0), tokens); _liquidity.sync(); }catch Error(string memory error){ _update(address(this), address(0), tokens); emit Error(error); }catch(bytes memory error){ _update(address(this), address(0), tokens); emit ErrorBytes(error); } } } }",
        "vulnerability": "Potential infinite loop and reentrancy in _swap",
        "reason": "The _swap function is susceptible to reentrancy and potential infinite loops. The use of try-catch blocks around external calls without proper checks can lead to reentrant calls if an external contract exploits this. Additionally, the function loops over taxes, potentially causing an infinite loop if tax amounts are improperly managed, leading to denial of service.",
        "file_name": "0x122ad2495b1af2a14c5c4b4ca59adfcd79c2dcb3.sol"
    }
]