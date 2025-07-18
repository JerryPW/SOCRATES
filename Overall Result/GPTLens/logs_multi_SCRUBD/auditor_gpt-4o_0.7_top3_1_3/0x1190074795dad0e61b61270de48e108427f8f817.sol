[
    {
        "function_name": "receive",
        "code": "receive() external payable { m_IncomingEth[msg.sender] += msg.value; }",
        "vulnerability": "Potential DoS via Gas Limit",
        "reason": "The receive function blindly increments the m_IncomingEth balance for any incoming ETH. If too many transactions occur from different addresses, it could result in a potential denial of service due to high gas consumption when accessing the mapping with multiple unique keys. This can be exploited by attackers to fill up the storage or make specific operations cost-prohibitive.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    },
    {
        "function_name": "_disperseEth",
        "code": "function _disperseEth() private { uint256 _currentAmount = m_IncomingEth[address(m_UniswapV2Router)].sub(m_PreviousBalance); uint256 _redistBalance = _currentAmount.div(2); uint256 _ethBalance = _currentAmount.sub(_redistBalance); uint256 _devBalance = _ethBalance.mul(1000).div(3333); uint256 _teamBalance = _ethBalance.mul(10).div(126).add(_ethBalance.div(10)).add(_ethBalance.mul(100).div(1666)); uint256 _projectBalance = _ethBalance.sub(_teamBalance).sub(_devBalance); m_EthReflectAmount = _redistBalance; m_TeamBalance[0xbAAAaEb86551aB8f0C04Bb45C1BC10167E9377c7] = m_TeamBalance[0xbAAAaEb86551aB8f0C04Bb45C1BC10167E9377c7].add(_ethBalance.mul(10).div(126)); m_TeamBalance[0xf101308187ef98d1acFa34b774CF3334Ec7279e4] = m_TeamBalance[0xf101308187ef98d1acFa34b774CF3334Ec7279e4].add(_ethBalance.div(10)); m_TeamBalance[0x16E7451D072eA28f2952eefCd7cC4A30B1F6A557] = m_TeamBalance[0x16E7451D072eA28f2952eefCd7cC4A30B1F6A557].add(_ethBalance.mul(100).div(1666)); payable(address(External)).transfer(_devBalance); External.deposit(_devBalance); payable(address(EthReflect)).transfer(_redistBalance); m_ProjectWallet.transfer(_projectBalance); m_PreviousBalance = m_IncomingEth[address(m_UniswapV2Router)]; }",
        "vulnerability": "Incorrect ETH Distribution",
        "reason": "The _disperseEth function calculates ETH balances to be distributed based on incoming amounts. However, it directly subtracts from a map value without proper checks, thus if m_IncomingEth[address(m_UniswapV2Router)] is lower than m_PreviousBalance, it could underflow in older versions or cause incorrect distribution. Additionally, there's no check for the success of ETH transfers, which might lead to ETH getting stuck or misallocated if the transfers fail.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    },
    {
        "function_name": "teamWithdraw",
        "code": "function teamWithdraw() external { require(m_TeamMember[_msgSender()]); require(m_TeamBalance[_msgSender()] > 0); payable(_msgSender()).transfer(m_TeamBalance[_msgSender()]); m_TeamBalance[_msgSender()] = 0; }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The teamWithdraw function allows a team member to withdraw their balance, but it directly transfers ETH before setting m_TeamBalance to zero. This sequence opens up the potential for a reentrancy attack, where an attacker could re-enter the function via a fallback function and withdraw more than intended by exploiting the fact that m_TeamBalance is reset only after the transfer.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    }
]