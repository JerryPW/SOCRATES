[
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; uint second = price; uint third = price; if (counter <= 6000) { counter += 1; swapaddress.transfer(msg.sender, 5000000); msg.sender.send(msg.value); } else if (amountRaised <= 8000 ether) { amountRaised += amount; uint secondvalue = second / 5; swapaddress.transfer(msg.sender, amount / secondvalue); } else { amountRaised += amount; uint thirdvalue = third / 3; swapaddress.transfer(msg.sender, amount / thirdvalue); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The contract uses 'msg.sender.send(msg.value)' which can lead to reentrancy attacks, as it sends ether before updating state variables like 'check[msg.sender]' and 'balanceOf[msg.sender]'. An attacker can exploit this by recursively calling the fallback function to withdraw more funds than allowed.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    },
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; uint second = price; uint third = price; if (counter <= 6000) { counter += 1; swapaddress.transfer(msg.sender, 5000000); msg.sender.send(msg.value); } else if (amountRaised <= 8000 ether) { amountRaised += amount; uint secondvalue = second / 5; swapaddress.transfer(msg.sender, amount / secondvalue); } else { amountRaised += amount; uint thirdvalue = third / 3; swapaddress.transfer(msg.sender, amount / thirdvalue); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Unchecked send",
        "reason": "The use of 'beneficiary.send(msg.value)' does not check the return value. If the send operation fails, the contract will not revert, leading to potential inconsistencies and loss of funds intended for the beneficiary.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    },
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; uint second = price; uint third = price; if (counter <= 6000) { counter += 1; swapaddress.transfer(msg.sender, 5000000); msg.sender.send(msg.value); } else if (amountRaised <= 8000 ether) { amountRaised += amount; uint secondvalue = second / 5; swapaddress.transfer(msg.sender, amount / secondvalue); } else { amountRaised += amount; uint thirdvalue = third / 3; swapaddress.transfer(msg.sender, amount / thirdvalue); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Gas limit on send",
        "reason": "The use of 'send' imposes a 2300 gas limit, which might not be enough for the recipient to perform needed operations, especially if the recipient is a smart contract with a fallback function. This could lead to failed transactions for legitimate users.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    }
]