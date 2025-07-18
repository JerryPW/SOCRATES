[
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; uint second = price; uint third = price; if (counter <= 6000) { counter += 1; swapaddress.transfer(msg.sender, 5000000); msg.sender.send(msg.value); } else if (amountRaised <= 8000 ether) { amountRaised += amount; uint secondvalue = second / 5; swapaddress.transfer(msg.sender, amount / secondvalue); } else { amountRaised += amount; uint thirdvalue = third / 3; swapaddress.transfer(msg.sender, amount / thirdvalue); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function includes a call to msg.sender.send(msg.value) before updating critical state variables like balanceOf and check. An attacker could exploit this reentrancy vulnerability to perform multiple contributions by re-entering the function before the check[msg.sender] is set to true, thus bypassing the require(check[msg.sender] == false) condition.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    },
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; uint second = price; uint third = price; if (counter <= 6000) { counter += 1; swapaddress.transfer(msg.sender, 5000000); msg.sender.send(msg.value); } else if (amountRaised <= 8000 ether) { amountRaised += amount; uint secondvalue = second / 5; swapaddress.transfer(msg.sender, amount / secondvalue); } else { amountRaised += amount; uint thirdvalue = third / 3; swapaddress.transfer(msg.sender, amount / thirdvalue); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Arbitrary token transfer vulnerability",
        "reason": "The swapaddress.transfer(msg.sender, 5000000) and similar calls are made without checking the result or verifying the allowance. This allows an attacker to potentially transfer more tokens than intended if the collectible contract contains bugs or malicious logic. Additionally, this could lead to loss of tokens if the collectible contract does not operate as expected.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    },
    {
        "function_name": "function () payable external",
        "code": "function () payable external { require(check[msg.sender] == false); require(msg.value < 1000000000000000001 wei); uint amount = msg.value; balanceOf[msg.sender] += amount; uint second = price; uint third = price; if (counter <= 6000) { counter += 1; swapaddress.transfer(msg.sender, 5000000); msg.sender.send(msg.value); } else if (amountRaised <= 8000 ether) { amountRaised += amount; uint secondvalue = second / 5; swapaddress.transfer(msg.sender, amount / secondvalue); } else { amountRaised += amount; uint thirdvalue = third / 3; swapaddress.transfer(msg.sender, amount / thirdvalue); } beneficiary.send(msg.value); emit FundTransfer(msg.sender, amount, true); check[msg.sender] = true; }",
        "vulnerability": "Unrestricted gas usage in send call",
        "reason": "The call to msg.sender.send(msg.value) uses the .send() method which provides only 2300 gas, which might not be sufficient for certain operations in the fallback function of msg.sender. Although this is often a security measure, it can cause legitimate transactions to fail, potentially leading to denial of service for users with complex fallback functions.",
        "file_name": "0x78e6d2bfe731e578a50a4129df89bb4950591d18.sol"
    }
]