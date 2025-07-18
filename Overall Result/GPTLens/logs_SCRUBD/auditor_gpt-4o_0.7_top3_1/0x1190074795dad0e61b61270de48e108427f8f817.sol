[
    {
        "function_name": "transferFrom",
        "code": "function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) { _transfer(_sender, _recipient, _amount); _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, \"ERC20: transfer amount exceeds allowance\")); return true; }",
        "vulnerability": "Allowance race condition",
        "reason": "The `transferFrom` function updates the allowance after the transfer operation. This creates a potential race condition where the allowance could be used up by multiple transactions simultaneously, leading to double-spending issues. This is a well-known issue in ERC20 implementations and can be exploited by attackers to spend more tokens than allowed.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    },
    {
        "function_name": "addLiquidity",
        "code": "function addLiquidity() external onlyOwner() { require(!m_Liquidity,\"trading is already open\"); uint256 _ethBalance = address(this).balance; m_UniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY); m_UniswapV2Pair = IUniswapV2Factory(m_UniswapV2Router.factory()).createPair(address(this), m_UniswapV2Router.WETH()); m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp); EthReflect.init(address(this), 5000, m_UniswapV2Pair, m_UniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY); IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max); m_Liquidity = true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `addLiquidity` function transfers the entire balance of the contract to the liquidity pool without any reentrancy protection. An attacker could potentially exploit this by calling another function that recursively calls `addLiquidity`, resulting in unexpected behavior or draining of funds. This could be mitigated by implementing a reentrancy guard using a mutex pattern.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    },
    {
        "function_name": "teamWithdraw",
        "code": "function teamWithdraw() external { require(m_TeamMember[_msgSender()]); require(m_TeamBalance[_msgSender()] > 0); payable(_msgSender()).transfer(m_TeamBalance[_msgSender()]); m_TeamBalance[_msgSender()] = 0; }",
        "vulnerability": "Lack of access control",
        "reason": "The `teamWithdraw` function allows any team member to withdraw funds without any time or value limit. If a team member's private key is compromised, an attacker can withdraw all available funds attributed to that member. Additionally, there are no safeguards against repeated withdrawals, so a compromised team member account could be drained completely.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    }
]