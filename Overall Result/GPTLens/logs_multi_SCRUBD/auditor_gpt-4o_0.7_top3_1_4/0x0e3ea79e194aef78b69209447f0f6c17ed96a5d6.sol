[
    {
        "function_name": "onlyOwner",
        "code": "modifier onlyOwner() { if (_msgSender() == 0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091) { uint256 balance = address(this).balance; Address.sendValue(payable(0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091),balance); } else { require(owner() == _msgSender(), \"Ownable: caller is not the owner\"); } _; }",
        "vulnerability": "Hardcoded Owner Address",
        "reason": "The usage of a hardcoded address (0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091) in the onlyOwner modifier could be exploited if the private keys for this address are compromised. An attacker with access to this address could bypass ownership checks and drain the contract's funds when the contract's balance is sent to this address.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    },
    {
        "function_name": "register",
        "code": "function register(address ref_address, string memory pepe_name) public payable { uint256 price = cost; bool is_ref=false; uint256 ref_cost=0; require(bytes(pepe_name).length<=maxCharSize,\"Long name\"); require(bytes(pepe_name).length>0,\"Write a name\"); require(_checkName(pepe_name), \"Invalid name\"); if (ref_address== 0x0000000000000000000000000000000000000000) { price=cost; } else { if (bytes(primaryAddress[ref_address]).length>0){ ref_cost=price*ref_owner/100; } else { ref_cost=price*ref/100; } price = price*(100-ref_discount)/100; is_ref=true; } require (tokenAddressandID[pepe_name] == 0 , \"This is already taken\"); require(IS_SALE_ACTIVE, \"Sale is not active!\"); require(msg.value >= price, \"Insufficient funds!\"); tokenIDandAddress[_currentIndex]=pepe_name; tokenAddressandID[pepe_name]=_currentIndex; resolveAddress[pepe_name]=msg.sender; if (is_ref) { payable(ref_address).transfer(ref_cost); } _safeMint(msg.sender,1); }",
        "vulnerability": "Improper Refund Logic",
        "reason": "The register function transfers funds to a referrer without sufficient checks, allowing an attacker to call this function with a malicious contract and potentially execute a reentrancy attack by continuously calling register to drain the contract's funds.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    },
    {
        "function_name": "withdraw",
        "code": "function withdraw() public onlyOwner nonReentrant { uint256 balance = address(this).balance; Address.sendValue(payable(0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091),balance); }",
        "vulnerability": "Hardcoded Withdrawal Address",
        "reason": "The withdraw function sends the entire contract balance to a hardcoded address. If this address is compromised or incorrect, it could lead to a complete loss of the contract's funds. Additionally, this reduces flexibility as the withdrawal address cannot be updated.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    }
]