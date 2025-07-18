[
    {
        "function_name": "transferOwnership",
        "code": "function transferOwnership(address newOwner) onlyOwner public { owner = newOwner; }",
        "vulnerability": "Lack of ownership transfer confirmation",
        "reason": "The function allows the current owner to transfer ownership to a new owner address without any confirmation or check on the validity of the new owner address. An attacker could manipulate this by setting the new owner to be an invalid address like 0x0, which would effectively lock the ownership and remove access control, or transfer ownership to an address they control.",
        "file_name": "0xfb0f7189b354660e649ae14261a9fe0e8febf369.sol"
    },
    {
        "function_name": "collectBack",
        "code": "function collectBack() onlyOwner public{ require(totalCandyNo > 0); require(collectorAddress != 0x0); tokenReward.transfer(collectorAddress, totalCandyNo * 1e18); totalCandyNo = 0; }",
        "vulnerability": "Potential loss of tokens due to incorrect collector address",
        "reason": "The function allows the owner to transfer remaining tokens to a collector address without validation. If the collector address is set incorrectly or maliciously to an address controlled by an attacker, the tokens can be siphoned off. There is no mechanism to ensure collectorAddress is legitimate, and since it is set in the constructor, it cannot be changed later unless redeployed.",
        "file_name": "0xfb0f7189b354660e649ae14261a9fe0e8febf369.sol"
    },
    {
        "function_name": "function () payable",
        "code": "function () payable public { require(totalCandyNo > 0); uint amount = getCurrentCandyAmount(); require(amount > 0); require(balanceOf[msg.sender] == 0); totalCandyNo -= amount; balanceOf[msg.sender] = amount; tokenReward.transfer(msg.sender, amount * 1e18); emit FundTransfer(msg.sender, amount, true); }",
        "vulnerability": "Denial of service by exhausting totalCandyNo",
        "reason": "The fallback function logic allows an attacker to call it once and receive the maximum candy amount without any cost, effectively exhausting the totalCandyNo and preventing other users from getting any tokens. This is possible because the function does not restrict the number of times it can be called with the same sender address or require any contribution.",
        "file_name": "0xfb0f7189b354660e649ae14261a9fe0e8febf369.sol"
    }
]