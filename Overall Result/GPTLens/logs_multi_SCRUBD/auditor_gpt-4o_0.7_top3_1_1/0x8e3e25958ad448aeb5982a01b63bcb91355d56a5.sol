[
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint copy = price; uint second = price; uint third = price; if (amountRaised <= 100 ether) { uint newvalue = copy / 10; swapaddress.transfer(msg.sender, amount / newvalue); } else if (amountRaised <= 2100 ether) { uint secondvalue = second / 2; swapaddress.transfer(msg.sender, amount / secondvalue); } else { swapaddress.transfer(msg.sender, amount / third); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function contains a call to an external contract (swapaddress.transfer) before updating the state variable 'check[msg.sender]'. This means an attacker could re-enter the function, repeatedly calling it and transferring more tokens than they are entitled to before 'check[msg.sender]' is set to 'true'. This is a classic reentrancy issue.",
        "file_name": "0x8e3e25958ad448aeb5982a01b63bcb91355d56a5.sol"
    },
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint copy = price; uint second = price; uint third = price; if (amountRaised <= 100 ether) { uint newvalue = copy / 10; swapaddress.transfer(msg.sender, amount / newvalue); } else if (amountRaised <= 2100 ether) { uint secondvalue = second / 2; swapaddress.transfer(msg.sender, amount / secondvalue); } else { swapaddress.transfer(msg.sender, amount / third); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Unsafe Ether transfer",
        "reason": "The contract uses 'beneficiary.send(msg.value)', which can fail and does not throw an exception. This can cause Ether to be lost if the send fails and the contract logic continues to execute or if the gas limit is too low for the receiving contract.",
        "file_name": "0x8e3e25958ad448aeb5982a01b63bcb91355d56a5.sol"
    },
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; amountRaised += amount; uint copy = price; uint second = price; uint third = price; if (amountRaised <= 100 ether) { uint newvalue = copy / 10; swapaddress.transfer(msg.sender, amount / newvalue); } else if (amountRaised <= 2100 ether) { uint secondvalue = second / 2; swapaddress.transfer(msg.sender, amount / secondvalue); } else { swapaddress.transfer(msg.sender, amount / third); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Integer division errors",
        "reason": "The contract performs integer division when calculating the number of tokens to transfer. If 'amount' is less than 'newvalue', 'secondvalue', or 'third', the result will be zero due to truncation, leading to no tokens being transferred. This can result in users not receiving tokens when they should.",
        "file_name": "0x8e3e25958ad448aeb5982a01b63bcb91355d56a5.sol"
    }
]