[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) onlyOwner public { if (newOwner != address(0)) { owner = newOwner; } }",
        "vulnerability": "Owner can be permanently lost",
        "reason": "The transferOwnership function can set the owner to any non-zero address, but it doesn't check if the new owner is a contract or a user. If the new owner is a contract that does not handle ownership functionality, the ownership can be permanently lost, making it impossible to call onlyOwner functions.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    },
    {
        "function_name": "bebBUYtwo",
        "code": "function bebBUYtwo(address _tokenAddress,address _usdtadderss,address _BETadderss,address _addr){ bebTokenTransfer = tokenTransfer(_tokenAddress); bebTokenTransferUSDT =tokenTransferUSDT(_usdtadderss); bebTokenTransferBET =tokenTransferBET(_BETadderss); ownerstoex=_addr; bebethex=5795; decimals=18; BEBday=20; bebjiage=172540000000000; bebtime=now; usdtex=166; }",
        "vulnerability": "Missing constructor keyword",
        "reason": "The bebBUYtwo function is intended to be a constructor, but it lacks the constructor keyword (or function name same as contract name in older Solidity versions), which means it can be called by anyone at any time. This allows anyone to reinitialize the contract's state variables, potentially redirecting token transfers and causing a denial of service.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    },
    {
        "function_name": "setVoteZancheng",
        "code": "function setVoteZancheng()public{ BEBuser storage _user=BEBusers[msg.sender]; require(KAIGUAN); uint256 _value=getTokenBalanceBET(msg.sender); require(_value>=1 ether,\"You have no right to vote\"); require(!_user.vote,\"You have voted\"); bebTokenTransferBET.transferFrom(msg.sender,address(this),_value); BEBzanchen+=_value; _user.amounts=_value; _user.vote=true; if(BEBzanchen>=51 ether){ if(huobileixing!=0){ if(huobileixing==1){ shenqingzhichu.transfer(shenqingAmount); KAIGUAN=false; BEBfandui=0; BEBzanchen=0; huobileixing=0; boody=\"\u901a\u8fc7\"; }else{ if(huobileixing==2){ bebTokenTransfer.transfer(shenqingzhichu,shenqingAmount); KAIGUAN=false; BEBfandui=0; BEBzanchen=0; huobileixing=0; boody=\"\u901a\u8fc7\"; }else{ bebTokenTransferUSDT.transfer(shenqingzhichu,shenqingAmount); KAIGUAN=false; BEBfandui=0; BEBzanchen=0; huobileixing=0; boody=\"\u901a\u8fc7\"; } } } } }",
        "vulnerability": "Unprotected external call leading to reentrancy",
        "reason": "The function makes external transfers (e.g., shenqingzhichu.transfer) without using a reentrancy guard. It updates state variables after the transfer, which could allow reentrancy attacks that manipulate the contract state unexpectedly if the external address is a contract that can re-enter into this function.",
        "file_name": "0x066416dc99bea2c852e46acf88128480479cf191.sol"
    }
]