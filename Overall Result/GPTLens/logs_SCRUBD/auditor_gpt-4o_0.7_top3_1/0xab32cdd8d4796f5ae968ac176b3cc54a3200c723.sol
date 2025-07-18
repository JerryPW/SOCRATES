[
    {
        "function_name": "ICO",
        "code": "function ICO( address _erc20, address _treasury, uint _startSec, uint _durationSec, uint _tokpereth ) public { require( isContract(_erc20) ); require( _tokpereth > 0 ); if (_treasury != address(0)) require( isContract(_treasury) ); tokenSC = ERC20( _erc20 ); treasury = _treasury; start = _startSec; duration = _durationSec; tokpereth = _tokpereth; minfinney = 25; }",
        "vulnerability": "Incorrect treasury address check",
        "reason": "The constructor checks if the treasury address is a contract only if it is not zero, which means a non-zero but externally owned address can be set as treasury. This could potentially lead to loss of funds since the fallback function assumes that treasury is a contract, which can handle Ether sent to it.",
        "file_name": "0xab32cdd8d4796f5ae968ac176b3cc54a3200c723.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw( uint amount ) public onlyOwner returns (bool) { require ( treasury == address(0) && amount <= address(this).balance ); return owner.send( amount ); }",
        "vulnerability": "Unsafe Ether transfer",
        "reason": "The withdraw function uses the send method for transferring Ether, which forwards only 2300 gas and does not revert in case of failure, potentially causing the owner to miss the Ether withdrawal if the transfer fails.",
        "file_name": "0xab32cdd8d4796f5ae968ac176b3cc54a3200c723.sol"
    },
    {
        "function_name": "function()",
        "code": "function() public payable { require( msg.value >= minfinney ); if (now < start || now > (start + duration)) revert(); uint qty = multiply( divide( multiply( msg.value, tokpereth ), 1e20), (bonus() + 100) ); if (qty > tokenSC.balanceOf(address(this)) || qty < 1) revert(); tokenSC.transfer( msg.sender, qty ); if (treasury != address(0)) treasury.transfer( msg.value ); }",
        "vulnerability": "Reentrancy risk in fallback function",
        "reason": "The fallback function transfers Ether to the treasury after transferring tokens to the user, which introduces a reentrancy risk if the token transfer triggers a fallback function in a token contract that can re-enter the fallback function of this contract.",
        "file_name": "0xab32cdd8d4796f5ae968ac176b3cc54a3200c723.sol"
    }
]