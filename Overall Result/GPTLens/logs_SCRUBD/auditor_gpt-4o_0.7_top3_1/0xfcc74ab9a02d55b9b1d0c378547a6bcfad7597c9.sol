[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); uint256 bonus = 0; uint256 amount; uint256 ethamount = msg.value; balanceOf[msg.sender] = balanceOf[msg.sender].add(ethamount); amountRaised = amountRaised.add(ethamount); if(now >= preSaleStartdate && now <= preSaleDeadline ){ amount = ethamount.div(price); bonus = amount.div(8); amount = amount.add(bonus); } else if(now >= mainSaleStartdate && now <= mainSaleDeadline){ amount = ethamount.div(price); } amount = amount.mul(1000000000000000000); tokenReward.transfer(msg.sender, amount); beneficiary.send(ethamount); fundTransferred = fundTransferred.add(ethamount); }",
        "vulnerability": "Reentrancy vulnerability in fallback function",
        "reason": "The contract sends Ether to the beneficiary address using the low-level `.send()` function, which only forwards 2300 gas, without using reentrancy guards. This allows a malicious beneficiary contract to perform a reentrancy attack by calling back into the fallback function to execute code before the state variables like `fundTransferred` are updated, potentially causing inconsistent state or draining funds.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    },
    {
        "function_name": "ChangeDates",
        "code": "function ChangeDates(uint256 _preSaleStartdate, uint256 _preSaleDeadline, uint256 _mainSaleStartdate, uint256 _mainSaleDeadline) { if(msg.sender == beneficiary){ if(_preSaleStartdate != 0){ preSaleStartdate = _preSaleStartdate; } if(_preSaleDeadline != 0){ preSaleDeadline = _preSaleDeadline; } if(_mainSaleStartdate != 0){ mainSaleStartdate = _mainSaleStartdate; } if(_mainSaleDeadline != 0){ mainSaleDeadline = _mainSaleDeadline; } if(crowdsaleClosed == true){ crowdsaleClosed = false; } } }",
        "vulnerability": "Potential for reopening closed crowdsale",
        "reason": "The function allows the beneficiary to change the sale dates and reopen a closed crowdsale by setting `crowdsaleClosed` to false. This could be exploited to indefinitely prolong the crowdsale by resetting deadlines, allowing the beneficiary to manipulate the sale periods and potentially defraud investors.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    },
    {
        "function_name": "getTokensBack",
        "code": "function getTokensBack() { uint256 remaining = tokenReward.balanceOf(this); if(msg.sender == beneficiary){ tokenReward.transfer(beneficiary, remaining); } }",
        "vulnerability": "Lack of access control and event logging",
        "reason": "The function allows the beneficiary to transfer all remaining tokens back to themselves without any event logging. There is no verification of why tokens are being transferred back, and no transparency, which could lead to misuse of the function by the beneficiary without any accountability or traceability.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    }
]