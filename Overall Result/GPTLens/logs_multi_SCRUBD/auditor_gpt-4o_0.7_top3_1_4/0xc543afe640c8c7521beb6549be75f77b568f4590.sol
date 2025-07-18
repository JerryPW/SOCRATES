[
    {
        "function_name": "function ()",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 2 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*PROFIT/100))); uint admin = msg.value*ADMIN_FEE/100; ADMIN.send(admin); pay(); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function involves sending Ether to the ADMIN, which uses the 'send' method. Although 'send' only forwards 2300 gas, making reentrancy less likely, it is still considered unsafe due to potential reentrancy in other parts of the contract like the 'pay' function. An attacker could exploit this by recursively calling the payable function, thus affecting the queue and draining funds.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Reentrancy vulnerability and gas limit issues",
        "reason": "The 'pay' function iterates over the queue and sends Ether using 'send'. Even though 'send' forwards limited gas, the function is vulnerable to reentrancy attacks if combined with other vulnerabilities. Furthermore, if an attacker can manipulate gas limits, they could prevent the loop from processing further, effectively halting payouts to other users.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    },
    {
        "function_name": "getDeposits",
        "code": "function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) { uint c = getDepositsCount(depositor); idxs = new uint[](c); deposits = new uint128[](c); expects = new uint128[](c); if(c > 0) { uint j = 0; for(uint i=currentReceiverIndex; i<queue.length; ++i){ Deposit storage dep = queue[i]; if(dep.depositor == depositor){ idxs[j] = i; deposits[j] = dep.deposit; expects[j] = dep.expect; j++; } } } }",
        "vulnerability": "Denial of service due to unbounded iteration",
        "reason": "The 'getDeposits' function iterates over the queue to find deposits for a given address. If the queue is very large, this iteration can consume all the gas provided for the call, resulting in a denial of service (DoS) for users trying to retrieve their deposit information. An attacker could exploit this by filling the queue with numerous deposits, making it gas-intensive to process.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    }
]