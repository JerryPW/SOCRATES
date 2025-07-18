[
    {
        "function_name": "oraclize_setNetwork",
        "code": "function oraclize_setNetwork(uint8 networkID) internal returns(bool){ return oraclize_setNetwork(); networkID; }\nfunction oraclize_setNetwork() internal returns(bool){ if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed); oraclize_setNetworkName(\"eth_mainnet\"); return true; } if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1); oraclize_setNetworkName(\"eth_ropsten3\"); return true; } if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e); oraclize_setNetworkName(\"eth_kovan\"); return true; } if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48); oraclize_setNetworkName(\"eth_rinkeby\"); return true; } if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475); return true; } if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF); return true; } if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA); return true; } return false; }",
        "vulnerability": "Hardcoded Addresses and Lack of Address Validation",
        "reason": "The function relies on hardcoded addresses to determine network connections. This approach is inflexible and can be insecure if any of the addresses change or are compromised. Additionally, there is no validation of the addresses, which could lead to misconfigurations or potential security risks if an incorrect or malicious address is used.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    },
    {
        "function_name": "buyTicket",
        "code": "function buyTicket(uint in_amount) public payable { uint amount = in_amount; if(in_amount > ticketPool.sub(ticketsBought)){ amount = ticketPool.sub(ticketsBought); queueAmount[queueLength] = in_amount.sub(amount); queueAddress[queueLength] = msg.sender; queueFunds = queueFunds.add((in_amount.sub(amount)).mul(ticketPrice)); queueLength = queueLength.add(1); } require(msg.value == (ticketPrice.mul(in_amount))); require(amount <= ticketPool.sub(ticketsBought)); require(in_amount > 0); if(amount > 0){ ticketsBought = ticketsBought.add(amount); buyers[buyerNumber] = msg.sender; amounts[buyerNumber] = amount; buyerNumber++; BuyTickets(address(this), msg.sender, amount); if(ticketsBought >= ticketPool){ jackpot = jackpot.add(jackpotCut); token.awardToken(msg.sender, 1); ledgerCount = 0; getRandom(); } token.awardToken(msg.sender, amount); } }",
        "vulnerability": "Reentrancy Vulnerability",
        "reason": "The function allows external calls to token.awardToken after updating the state with ticketsBought and buyerNumber. An attacker could exploit this by calling the function recursively, potentially manipulating ticket purchases to their advantage. This could lead to inconsistencies in the state and unexpected behavior, especially if the external token contract is not trusted or has its own vulnerabilities.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    },
    {
        "function_name": "takeAll",
        "code": "function takeAll() public onlyOwner { msg.sender.transfer(address(this).balance); }",
        "vulnerability": "Potential Denial of Service (DoS) via Gas Limit",
        "reason": "The function allows the owner to withdraw the entire contract balance, but if the balance is large, the transfer function could exceed the gas limit, leading to a denial of service. This could prevent the owner from retrieving funds, locking them in the contract indefinitely. The use of .transfer can also be problematic if gas costs change or if the recipient is a contract with a fallback function that requires more gas.",
        "file_name": "0x00195777bed7025e78819156281192c85fb3cf9b.sol"
    }
]