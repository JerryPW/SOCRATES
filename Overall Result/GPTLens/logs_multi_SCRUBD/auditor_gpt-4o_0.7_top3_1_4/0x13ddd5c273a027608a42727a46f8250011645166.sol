[
    {
        "function_name": "fundWithdraw",
        "code": "function fundWithdraw(address addr, uint value) payable public _rA { require(value <= funds); addr.transfer(value); funds -= value; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function `fundWithdraw` transfers Ether to an address before updating the `funds` variable. This allows for a reentrancy attack where an attacker could re-enter the function before the state is updated, potentially draining the contract's funds.",
        "file_name": "0x13ddd5c273a027608a42727a46f8250011645166.sol"
    },
    {
        "function_name": "realbuy",
        "code": "function realbuy(Item storage item) internal returns(uint finalRefund) { uint total = item.priceSell; uint fee = total.sub(item.priceOrg).mul(admin_proportion).div(1000); fundMark(fee); finalRefund = total.sub(fee); item.owner.transfer(finalRefund); item.owner = msg.sender; item.priceOrg = item.priceSell; item.priceSell = newPrice(item.priceOrg, item.priceSell); item.round = item.round + 1; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "Just like `fundWithdraw`, the `realbuy` function transfers Ether to an item owner before updating the item's state. This can be exploited by a reentrancy attack where the item's state is manipulated to drain Ether before the state change is finalized.",
        "file_name": "0x13ddd5c273a027608a42727a46f8250011645166.sol"
    },
    {
        "function_name": "setNewPriceFuncAddress",
        "code": "function setNewPriceFuncAddress(address addrFunc) public _rC { INewPrice counter = INewPrice(addrFunc); require(counter.isNewPrice()); priceCounter = counter; }",
        "vulnerability": "Untrusted contract call",
        "reason": "The function `setNewPriceFuncAddress` allows for setting an external contract address without any validation on the logic or trustworthiness of the new contract. This can lead to malicious contracts being set, which could manipulate price calculations or disrupt the functionality of the contract.",
        "file_name": "0x13ddd5c273a027608a42727a46f8250011645166.sol"
    }
]