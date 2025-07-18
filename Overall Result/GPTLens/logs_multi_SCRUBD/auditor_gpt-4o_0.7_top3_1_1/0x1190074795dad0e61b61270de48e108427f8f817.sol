[
    {
        "function_name": "receive",
        "code": "receive() external payable { m_IncomingEth[msg.sender] += msg.value; }",
        "vulnerability": "Unrestricted Ether Reception",
        "reason": "The receive function allows anyone to send Ether to the contract without any restriction or event logging. This could lead to issues such as accidental Ether transfers or potential misuse by attackers to manipulate Ether balance-related logic.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    },
    {
        "function_name": "teamWithdraw",
        "code": "function teamWithdraw() external { require(m_TeamMember[_msgSender()]); require(m_TeamBalance[_msgSender()] > 0); payable(_msgSender()).transfer(m_TeamBalance[_msgSender()]); m_TeamBalance[_msgSender()] = 0; }",
        "vulnerability": "Lack of Reentrancy Protection",
        "reason": "The teamWithdraw function allows transferring Ether to the sender without implementing reentrancy protection. This could be exploited by attackers to reenter the function and withdraw more funds than intended by manipulating the control flow.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    },
    {
        "function_name": "_disperseEth",
        "code": "function _disperseEth() private { uint256 _currentAmount = m_IncomingEth[address(m_UniswapV2Router)].sub(m_PreviousBalance); uint256 _redistBalance = _currentAmount.div(2); uint256 _ethBalance = _currentAmount.sub(_redistBalance); uint256 _devBalance = _ethBalance.mul(1000).div(3333); uint256 _teamBalance = _ethBalance.mul(10).div(126).add(_ethBalance.div(10)).add(_ethBalance.mul(100).div(1666)); uint256 _projectBalance = _ethBalance.sub(_teamBalance).sub(_devBalance); m_EthReflectAmount = _redistBalance; m_TeamBalance[0xbAAAaEb86551aB8f0C04Bb45C1BC10167E9377c7] = m_TeamBalance[0xbAAAaEb86551aB8f0C04Bb45C1BC10167E9377c7].add(_ethBalance.mul(10).div(126)); m_TeamBalance[0xf101308187ef98d1acFa34b774CF3334Ec7279e4] = m_TeamBalance[0xf101308187ef98d1acFa34b774CF3334Ec7279e4].add(_ethBalance.div(10)); m_TeamBalance[0x16E7451D072eA28f2952eefCd7cC4A30B1F6A557] = m_TeamBalance[0x16E7451D072eA28f2952eefCd7cC4A30B1F6A557].add(_ethBalance.mul(100).div(1666)); payable(address(External)).transfer(_devBalance); External.deposit(_devBalance); payable(address(EthReflect)).transfer(_redistBalance); m_ProjectWallet.transfer(_projectBalance); m_PreviousBalance = m_IncomingEth[address(m_UniswapV2Router)]; }",
        "vulnerability": "Incorrect Ether Disbursement Logic",
        "reason": "The _disperseEth function calculates Ether balances and distributes them without validating the correctness of the calculations, which might lead to incorrect fund distribution. A miscalculation or manipulation of m_IncomingEth could result in financial losses or incorrect fund allocations.",
        "file_name": "0x1190074795dad0e61b61270de48e108427f8f817.sol"
    }
]