[
    {
        "function_name": "function ()",
        "code": "function () public payable {\n    if(msg.value > 0){\n        require(gasleft() >= 220000, \"We require more gas!\");\n        require(msg.value <= 10 ether);\n        queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));\n        uint promo = msg.value*PROMO_PERCENT/100;\n        PROMO.send(promo);\n        pay();\n    }\n}",
        "vulnerability": "Unrestricted Ether withdrawal",
        "reason": "The fallback function does not have any access control. Any user can send Ether to the contract and potentially manipulate the payout sequence by flooding the queue with small deposits. This could lead to a situation where smaller deposits are getting paid out before larger ones, which could be exploited by attackers to drain funds strategically, especially with the multiplier and promo payment logic.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private {\n    uint128 money = uint128(address(this).balance);\n    for(uint i=0; i<queue.length; i++){\n        uint idx = currentReceiverIndex + i;\n        Deposit storage dep = queue[idx];\n        if(money >= dep.expect){\n            dep.depositor.send(dep.expect);\n            money -= dep.expect;\n            delete queue[idx];\n        }else{\n            dep.depositor.send(money);\n            dep.expect -= money;\n            break;\n        }\n        if(gasleft() <= 50000) break;\n    }\n    currentReceiverIndex += i;\n}",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The use of the `.send()` function in the pay() method is intended to mitigate reentrancy risks by limiting the gas provided to the called contract. However, the method logic allows for partial payments and adjusts the deposit expectations. Since the queue is modified during execution, an attacker could potentially exploit the reentrancy vulnerability if they use a fallback function that interacts with the contract, especially when combined with the fallback function's lack of access control.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private {\n    uint128 money = uint128(address(this).balance);\n    for(uint i=0; i<queue.length; i++){\n        uint idx = currentReceiverIndex + i;\n        Deposit storage dep = queue[idx];\n        if(money >= dep.expect){\n            dep.depositor.send(dep.expect);\n            money -= dep.expect;\n            delete queue[idx];\n        }else{\n            dep.depositor.send(money);\n            dep.expect -= money;\n            break;\n        }\n        if(gasleft() <= 50000) break;\n    }\n    currentReceiverIndex += i;\n}",
        "vulnerability": "Integer overflow/underflow vulnerability",
        "reason": "In Solidity version 0.4.25, arithmetic operations do not perform overflow or underflow checks. This could lead to unexpected behavior in calculations, especially in `dep.expect -= money;`. While the code attempts to manage deposits and expectations, an attacker could exploit this by carefully crafting deposit amounts to create overflows or underflows, disrupting the proper flow of funds.",
        "file_name": "0x62b01d0aeb16656aff7a7632c3a61c8b069a8928.sol"
    }
]