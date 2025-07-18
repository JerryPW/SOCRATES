[
    {
        "function_name": "bebBUYtwo",
        "code": "function bebBUYtwo(address _tokenAddress,address _usdtadderss,address _BETadderss,address _addr){ bebTokenTransfer = tokenTransfer(_tokenAddress); bebTokenTransferUSDT =tokenTransferUSDT(_usdtadderss); bebTokenTransferBET =tokenTransferBET(_BETadderss); ownerstoex=_addr; bebethex=5795; decimals=18; BEBday=20; bebjiage=172540000000000; bebtime=now; usdtex=166; }",
        "vulnerability": "Lack of Visibility Specifier",
        "reason": "The constructor function bebBUYtwo lacks a visibility specifier, which can lead to confusion about access permissions. In Solidity 0.4.24, this can default to public, but it is a best practice to explicitly define it. This oversight can lead to potential misuse or misunderstanding of who can deploy the contract.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    },
    {
        "function_name": "DayQuKuan",
        "code": "function DayQuKuan()public{ if(now-bebtime>86400){ bebtime+=86400; bebjiage+=660000000000; bebethex=1 ether/bebjiage; } BEBuser storage _users=BEBusers[msg.sender]; uint256 _eths=_users.dayamount; require(_eths>0,\"You didn't invest\"); require(_users.bebdays<BEBday,\"Expired\"); uint256 _time=(now-_users.usertime)/86400; require(_time>=1,\"Less than a day\"); uint256 _ddaayy=_users.bebdays+1; if(BEBday==20){ msg.sender.transfer(_users.dayamount); SUMWithdraw+=_users.dayamount; _users.bebdays=_ddaayy; _users.usertime=now; if(_ddaayy==BEBday){ uint256 _bebs=_users.zhiyaBEB*90/100; bebTokenTransfer.transfer(msg.sender,_bebs); _users.amount=0; _users.dayamount=0; _users.bebdays=0; _users.zhiyaBEB=0; } }else{ uint256 _values=SafeMath.safeDiv(_users.zhiyaBEB,BEBday); bebTokenTransfer.transfer(msg.sender,_values); _users.bebdays=_ddaayy; _users.usertime=now; if(_ddaayy==BEBday){ uint256 _bebss=_users.zhiyaBEB*90/100; bebTokenTransfer.transfer(msg.sender,_bebss); _users.amount=0; _users.dayamount=0; _users.bebdays=0; _users.zhiyaBEB=0; } } }",
        "vulnerability": "Reentrancy",
        "reason": "The function DayQuKuan allows for reentrancy attacks due to the use of msg.sender.transfer(), which sends Ether before updating the user's state. An attacker could exploit this by recursively calling DayQuKuan to drain funds. To prevent this, the state should be updated before any external call.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    },
    {
        "function_name": "setVoteZancheng",
        "code": "function setVoteZancheng()public{ BEBuser storage _user=BEBusers[msg.sender]; require(KAIGUAN); uint256 _value=getTokenBalanceBET(msg.sender); require(_value>=1 ether,\"You have no right to vote\"); require(!_user.vote,\"You have voted\"); bebTokenTransferBET.transferFrom(msg.sender,address(this),_value); BEBzanchen+=_value; _user.amounts=_value; _user.vote=true; if(BEBzanchen>=51 ether){ if(huobileixing!=0){ if(huobileixing==1){ shenqingzhichu.transfer(shenqingAmount); KAIGUAN=false; BEBfandui=0; BEBzanchen=0; huobileixing=0; boody=\"\u901a\u8fc7\"; }else{ if(huobileixing==2){ bebTokenTransfer.transfer(shenqingzhichu,shenqingAmount); KAIGUAN=false; BEBfandui=0; BEBzanchen=0; huobileixing=0; boody=\"\u901a\u8fc7\"; }else{ bebTokenTransferUSDT.transfer(shenqingzhichu,shenqingAmount); KAIGUAN=false; BEBfandui=0; BEBzanchen=0; huobileixing=0; boody=\"\u901a\u8fc7\"; } } } } }",
        "vulnerability": "Unrestricted Transfer Execution",
        "reason": "The function setVoteZancheng executes a transfer based on a voting mechanism, but it does not adequately restrict or verify the conditions for transferring large sums of tokens or Ether. An attacker could potentially manipulate the voting process to execute unauthorized transfers. This vulnerability can be mitigated by adding stricter validations and ensuring that the voting process cannot be circumvented or manipulated.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    }
]