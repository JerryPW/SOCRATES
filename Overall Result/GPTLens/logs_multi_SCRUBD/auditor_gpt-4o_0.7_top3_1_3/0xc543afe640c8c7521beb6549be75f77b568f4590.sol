[
    {
        "function_name": "function ()",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 2 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*PROFIT/100))); uint admin = msg.value*ADMIN_FEE/100; ADMIN.send(admin); pay(); } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function contains a call to an external address (ADMIN.send(admin)), followed by a call to the internal pay() function. If the ADMIN address is controlled by a malicious actor, they could potentially exploit this reentrancy vulnerability by creating a recursive call to the fallback function, potentially draining the contract of its funds.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Reentrancy vulnerability and gas limit manipulation",
        "reason": "The pay function, which is responsible for sending funds to depositors, calls external addresses (dep.depositor.send). This could lead to a reentrancy attack if a depositor's address is a smart contract with a fallback function that interacts with this contract. Additionally, the use of gasleft() to control the loop's execution can be manipulated by attackers to potentially cause the function to behave unpredictably.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    },
    {
        "function_name": "function ()",
        "code": "function () public payable { if(msg.value > 0){ require(gasleft() >= 220000, \"We require more gas!\"); require(msg.value <= 2 ether); queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*PROFIT/100))); uint admin = msg.value*ADMIN_FEE/100; ADMIN.send(admin); pay(); } }",
        "vulnerability": "Arbitrary execution cost",
        "reason": "The fallback function imposes a high gas requirement (require(gasleft() >= 220000)), which could lead to denial of service if the gas limit is not met. This can prevent users from making deposits, effectively stopping the contract's operations. Additionally, it may impose unnecessary costs on users interacting with the contract, reducing its usability.",
        "file_name": "0xc543afe640c8c7521beb6549be75f77b568f4590.sol"
    }
]