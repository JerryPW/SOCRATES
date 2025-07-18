[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) onlyOwner public { if (newOwner != address(0)) { owner = newOwner; } }",
        "vulnerability": "Lack of proper event logging",
        "reason": "The transferOwnership function changes the contract's owner without emitting an event, making it difficult to track changes in ownership. This can lead to potential disputes or lack of transparency, as there's no on-chain record of ownership transitions.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    },
    {
        "function_name": "bebBUYtwo",
        "code": "function bebBUYtwo(address _tokenAddress,address _usdtadderss,address _BETadderss,address _addr){ bebTokenTransfer = tokenTransfer(_tokenAddress); bebTokenTransferUSDT =tokenTransferUSDT(_usdtadderss); bebTokenTransferBET =tokenTransferBET(_BETadderss); ownerstoex=_addr; bebethex=5795; decimals=18; BEBday=20; bebjiage=172540000000000; bebtime=now; usdtex=166; }",
        "vulnerability": "Constructor without access control",
        "reason": "The bebBUYtwo function is intended to be a constructor, but it lacks access control. This means anyone can call this function to reinitialize contract parameters, potentially leading to contract manipulation or loss of funds.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    },
    {
        "function_name": "ChaiwuzhiChu",
        "code": "function ChaiwuzhiChu(address _addr,uint256 _values,uint256 _leixing,string _purpose)public{ require(!KAIGUAN,\"The last round of voting is not over\"); require(getTokenBalanceBET(address(this))<1,\"And bet didn't get it back\"); uint256 _value=getTokenBalanceBET(msg.sender); require(_value>=1 ether,\"You have no right to apply\"); KAIGUAN=true; shenqingzhichu=_addr; if(_leixing==3){ uint256 _usdts= SafeMath.safeDiv(_values,1000000000000000000); uint256 _usdttozhichu=_usdts*1000000; shenqingAmount=_usdttozhichu; }else{ shenqingAmount=_values; } huobileixing=_leixing; purpose=_purpose; boody=\"\u6295\u7968\u4e2d...\"; }",
        "vulnerability": "Improper locking mechanism",
        "reason": "The function ChaiwuzhiChu sets the KAIGUAN flag to true, allowing anyone who meets the conditions to trigger a voting cycle. This can be abused to lock the contract in a state where no further withdrawals or changes can be made, especially if malicious users keep triggering new voting cycles.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    }
]