[
    {
        "function_name": "getMyDividends",
        "code": "function getMyDividends() public notFromContract balanceChanged {\n    uint dividends = calcDividends(msg.sender);\n    require (dividends.notZero(), \"cannot to pay zero dividends\");\n    assert(m_investors.setPaymentTime(msg.sender, now));\n    if (address(this).balance <= dividends) {\n        nextWave();\n        dividends = address(this).balance;\n    }\n    msg.sender.transfer(dividends);\n    emit LogPayDividends(msg.sender, now, dividends);\n}",
        "vulnerability": "Reentrancy",
        "reason": "The `getMyDividends` function transfers Ether to the caller before updating the state variables (`setPaymentTime`). This allows an attacker to re-enter the function and drain funds by repeatedly calling `getMyDividends` before the state is updated.",
        "file_name": "0x10819fae72282b9a594e34c647a7bc446ef4ad2e.sol"
    },
    {
        "function_name": "addInvestment2",
        "code": "function addInvestment2(uint investment, address investorAddr) public onlyOwner {\n    investorAddr.transfer(investment);\n}",
        "vulnerability": "Arbitrary Ether Transfer",
        "reason": "The `addInvestment2` function allows the contract owner to transfer an arbitrary amount of Ether to any address without any checks or balances. This can be exploited if the owner account is compromised, leading to unauthorized Ether transfers.",
        "file_name": "0x10819fae72282b9a594e34c647a7bc446ef4ad2e.sol"
    },
    {
        "function_name": "doInvest",
        "code": "function doInvest(address referrerAddr) public payable notFromContract balanceChanged {\n    uint investment = msg.value;\n    uint receivedEther = msg.value;\n    require(investment >= minInvesment, \"investment must be >= minInvesment\");\n    require(address(this).balance <= maxBalance, \"the contract eth balance limit\");\n    if (receivedEther > investment) {\n        uint excess = receivedEther - investment;\n        msg.sender.transfer(excess);\n        receivedEther = investment;\n        emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);\n    }\n    advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));\n    adminsAddress.transfer(m_adminsPercent.mul(receivedEther));\n    if (msg.value > 0) {\n        if (msg.data.length == 20) {\n            referrerAddr.transfer(m_referrer_percent.mmul(investment));\n        } else if (msg.data.length == 0) {\n            adminsAddress.transfer(m_referrer_percent.mmul(investment));\n        } else {\n            assert(false);\n        }}\n    bool senderIsInvestor = m_investors.isInvestor(msg.sender);\n    if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] && referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {\n        m_referrals[msg.sender] = true;\n        uint referrerBonus = m_referrer_percent.mmul(investment);\n        if (investment > 10 ether) {\n            referrerBonus = m_referrer_percentMax.mmul(investment);\n        }}\n    uint dividends = calcDividends(msg.sender);\n    if (senderIsInvestor && dividends.notZero()) {\n        investment = (investment += dividends) * 70/100;\n        emit LogAutomaticReinvest(msg.sender, now, dividends);\n    }\n    if (senderIsInvestor) {\n        assert(m_investors.addInvestment(msg.sender, investment));\n        assert(m_investors.setPaymentTime(msg.sender, now));\n    } else {\n        assert(m_investors.newInvestor(msg.sender, investment, now));\n        emit LogNewInvestor(msg.sender, now);\n    }\n    investmentsNumber++;\n    emit LogNewInvesment(msg.sender, now, investment, receivedEther);\n}",
        "vulnerability": "Referrer Address Validation and Transfer",
        "reason": "The `doInvest` function transfers Ether to a `referrerAddr` based on `msg.data.length`, assuming it contains a valid address. If `msg.data` is manipulated incorrectly, it could lead to incorrect transfers or unexpected behavior. The lack of validation of `referrerAddr` before transferring Ether can be exploited.",
        "file_name": "0x10819fae72282b9a594e34c647a7bc446ef4ad2e.sol"
    }
]