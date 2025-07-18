[
    {
        "function_name": "lock",
        "code": "function lock(uint256 time) public virtual onlyOwner { _previousOwner = _owner; _owner = address(0); _lockTime = block.timestamp + time; emit OwnershipTransferred(_owner, address(0)); }",
        "vulnerability": "Owner can lock and disable contract indefinitely",
        "reason": "The lock function allows the owner to set the contract's owner to the zero address, thereby disabling any owner-only functionality. If the owner sets a very large 'time' value, it would effectively lock the contract indefinitely, preventing any further owner actions. This could be used maliciously by a compromised owner account or a malicious owner.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    },
    {
        "function_name": "unlock",
        "code": "function unlock() public virtual { require(_previousOwner == msg.sender, \"You don't have permission to unlock\"); require(block.timestamp > _lockTime , \"Contract is locked until 7 days\"); emit OwnershipTransferred(_owner, _previousOwner); _owner = _previousOwner; }",
        "vulnerability": "Unlock can be exploited by previous owner",
        "reason": "The unlock function allows the _previousOwner to regain ownership after the lock period. If the contract is transferred to a new owner, the previous owner can still unlock the contract after the lock period and regain control. This poses a security risk if the previous owner was malicious or compromised.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    },
    {
        "function_name": "_transfer",
        "code": "function _transfer( address from, address to, uint256 amount ) private { require(from != address(0), \"ERC20: transfer from the zero address\"); require(amount > 0, \"Transfer amount must be greater than zero\"); if(from == uniswapV2Pair && (!_isExcludedFromFee[from]) && (!_isExcludedFromFee[to])){ require(amount <= maxBuyTransactionAmount, \"Buy transfer amount exceeds the maxBuyTransactionAmount.\"); } if ( from != owner() && to != owner() && to != address(0) && to != address(0xdead) && to != uniswapV2Pair ) { uint256 contractBalanceRecepient = balanceOf(to); require( contractBalanceRecepient + amount <= maxWalletToken, \"Exceeds maximum wallet token amount.\" ); } uint256 contractTokenBalance = balanceOf(address(this)); bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount; if ( overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled ) { contractTokenBalance = swapTokensAtAmount; swapAndLiquify(contractTokenBalance); } _tokenTransfer(from,to,amount); }",
        "vulnerability": "Potential denial of service via transfer limits",
        "reason": "The _transfer function imposes restrictions on transfer amounts and wallet holdings. An attacker could exploit these limits to prevent legitimate users from transferring tokens by manipulating token balances or transaction amounts to trigger these restrictions, effectively causing a denial of service for certain users.",
        "file_name": "0x047b957bb18534b4e4add20c101cb5791f12d112.sol"
    }
]