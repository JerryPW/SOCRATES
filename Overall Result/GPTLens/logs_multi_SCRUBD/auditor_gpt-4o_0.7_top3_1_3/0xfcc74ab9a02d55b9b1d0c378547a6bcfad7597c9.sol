[
    {
        "function_name": "function () payable",
        "code": "function () payable { require(!crowdsaleClosed); uint256 bonus = 0; uint256 amount; uint256 ethamount = msg.value; balanceOf[msg.sender] = balanceOf[msg.sender].add(ethamount); amountRaised = amountRaised.add(ethamount); if(now >= preSaleStartdate && now <= preSaleDeadline ){ amount = ethamount.div(price); bonus = amount.div(8); amount = amount.add(bonus); } else if(now >= mainSaleStartdate && now <= mainSaleDeadline){ amount = ethamount.div(price); } amount = amount.mul(1000000000000000000); tokenReward.transfer(msg.sender, amount); beneficiary.send(ethamount); fundTransferred = fundTransferred.add(ethamount); }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The fallback function sends Ether to the beneficiary using `beneficiary.send(ethamount);` without proper checks-effects-interactions pattern, allowing potential reentrancy attack. If the beneficiary is a contract with malicious code, it could re-enter the contract before state variables are updated, potentially withdrawing funds multiple times.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    },
    {
        "function_name": "getTokensBack",
        "code": "function getTokensBack() { uint256 remaining = tokenReward.balanceOf(this); if(msg.sender == beneficiary){ tokenReward.transfer(beneficiary, remaining); } }",
        "vulnerability": "Potential token loss",
        "reason": "There is no check if the crowdsale is still active or closed. If the crowdsale is active, calling this function will transfer all remaining tokens back to the beneficiary, potentially disrupting the distribution of tokens to investors who have already sent Ether but haven't received their tokens.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    },
    {
        "function_name": "ChangeDates",
        "code": "function ChangeDates(uint256 _preSaleStartdate, uint256 _preSaleDeadline, uint256 _mainSaleStartdate, uint256 _mainSaleDeadline) { if(msg.sender == beneficiary){ if(_preSaleStartdate != 0){ preSaleStartdate = _preSaleStartdate; } if(_preSaleDeadline != 0){ preSaleDeadline = _preSaleDeadline; } if(_mainSaleStartdate != 0){ mainSaleStartdate = _mainSaleStartdate; } if(_mainSaleDeadline != 0){ mainSaleDeadline = _mainSaleDeadline; } if(crowdsaleClosed == true){ crowdsaleClosed = false; } } }",
        "vulnerability": "Arbitrary date change",
        "reason": "The beneficiary can arbitrarily change the start and end dates of both the pre-sale and main sale, potentially to the detriment of investors. This could lead to scenarios where investors are unfairly locked out or the sale is extended indefinitely to collect more funds.",
        "file_name": "0xfcc74ab9a02d55b9b1d0c378547a6bcfad7597c9.sol"
    }
]