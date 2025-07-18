[
    {
        "function_name": "transfer",
        "code": "function transfer(address receiver, uint amount);",
        "vulnerability": "Missing return value check for ERC20 transfer function",
        "reason": "In the smart contract, the transfer function of the token interfaces (tokenTransfer, tokenTransferUSDT, tokenTransferBET) is called without checking the return value. This is problematic because the ERC20 token standard allows for the transfer function to return a boolean indicating success. If the transfer fails and returns false, the contract will not handle it, potentially leading to unexpected behavior or loss of funds.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    },
    {
        "function_name": "setUSDT",
        "code": "function setUSDT(uint256 _value) public{ require(_value>=10000000); uint256 _valueToBEB=SafeMath.safeDiv(_value,1000000); uint256 _valueToBEBs=_valueToBEB*10**18; uint256 _usdts=SafeMath.safeMul(_value,120); uint256 _usdt=SafeMath.safeDiv(_usdts,100); uint256 _bebex=SafeMath.safeMul(bebjiage,usdtex); uint256 _usdtexs=SafeMath.safeDiv(1000000000000000000,_bebex); uint256 _usdtex=SafeMath.safeMul(_usdtexs,_valueToBEBs); USDTuser storage _user=USDTusers[msg.sender]; require(_user.amount==0,\"Already invested \"); bebTokenTransferUSDT.transferFrom(msg.sender,address(this),_value); bebTokenTransfer.transferFrom(msg.sender,address(this),_usdtex); _user.zhiyaBEB=_usdtex; _user.amount=_value; _user.dayamount=SafeMath.safeDiv(_usdt,BEBday); _user.usertime=now; _user.sumProfit+=_value*20/100; ProfitSUMBEB+=_usdtex*10/100; USDTdeposit+=_value; }",
        "vulnerability": "Re-entrancy attack",
        "reason": "The setUSDT function transfers tokens using the transferFrom function, which may call an external contract. If the external contract is malicious, it could re-enter the contract and manipulate state variables such as USDTdeposit or ProfitSUMBEB, leading to a potential re-entrancy vulnerability.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    },
    {
        "function_name": "setVoteZancheng",
        "code": "function setVoteZancheng()public{ BEBuser storage _user=BEBusers[msg.sender]; require(KAIGUAN); uint256 _value=getTokenBalanceBET(msg.sender); require(_value>=1 ether,\"You have no right to vote\"); require(!_user.vote,\"You have voted\"); bebTokenTransferBET.transferFrom(msg.sender,address(this),_value); BEBzanchen+=_value; _user.amounts=_value; _user.vote=true; if(BEBzanchen>=51 ether){ if(huobileixing!=0){ if(huobileixing==1){ shenqingzhichu.transfer(shenqingAmount); KAIGUAN=false; BEBfandui=0; BEBzanchen=0; huobileixing=0; boody=\"\u901a\u8fc7\"; }else{ if(huobileixing==2){ bebTokenTransfer.transfer(shenqingzhichu,shenqingAmount); KAIGUAN=false; BEBfandui=0; BEBzanchen=0; huobileixing=0; boody=\"\u901a\u8fc7\"; }else{ bebTokenTransferUSDT.transfer(shenqingzhichu,shenqingAmount); KAIGUAN=false; BEBfandui=0; BEBzanchen=0; huobileixing=0; boody=\"\u901a\u8fc7\"; } } } } }",
        "vulnerability": "Centralization of control",
        "reason": "The setVoteZancheng function allows for a centralized decision-making process where a few entities with large token holdings can reach the 51 ether threshold and influence contract behavior. This can lead to centralization risks where the contract control is effectively in the hands of a few, undermining decentralization principles.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    }
]