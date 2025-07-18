[
    {
        "function_name": "verify",
        "code": "function verify(address addr) public payable { if (msg.sender != owner()) { require(msg.value == verificationPrice); support.send(verificationPrice); } verified[addr] = true; emit RefVerified(addr); }",
        "vulnerability": "Uncontrolled external call",
        "reason": "The function sends ether to the 'support' address using 'send', which forwards only 2300 gas. This can cause transactions to fail if more gas is needed for execution on the receiving end. Additionally, the use of 'send' does not check the return value, potentially leaving funds locked if the transfer fails.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    },
    {
        "function_name": "function",
        "code": "function () public payable { require(!isContract(msg.sender)); if(msg.value == verificationPrice) { verify(msg.sender); return; } if (msg.value == 0 && msg.sender == owner()) { address a = bytesToAddress(bytes(msg.data)); verify(a); return; } if (referrer[msg.sender] == address(0)) { require(setRef()); } if(msg.value > 0){ require(gasleft() >= 300000, \"We require more gas!\"); require(msg.value <= 10 ether); if (block.timestamp >= cycleStart + actualCycle) { if (queue.length.sub(lastCycle) >= frontier) { actualCycle = actualCycle * 2; if (actualCycle > maxCycle) { actualCycle = maxCycle; } } else { actualCycle = actualCycle / 2; if (actualCycle < minCycle) { actualCycle = minCycle; } } uint amountOfPlayers = queue.length - lastCycle; lastCycle = queue.length; cycleStart = block.timestamp; currentReceiverIndex = lastCycle; cycles++; if (amountOfPlayers != 1) { currentRefundIndex = lastCycle.sub(1); refunding(); } else { singleRefunding(); } emit NewCycle(cycleStart, actualCycle, cycles); } if (currentRefundIndex != 0) { refunding(); } uint percent = queue.length.sub(lastCycle).add(1); if (percent >= 33) { percent = 33; } queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * (100 + percent) / 100))); uint _support = msg.value * supportPercent / 100; support.send(_support); uint _refBonus = msg.value * refBonus / 1000; referrer[msg.sender].send(_refBonus); emit RefBonusPayed(msg.sender, referrer[msg.sender], _refBonus, 1); if (referrer[referrer[msg.sender]] != address(0)) { referrer[referrer[msg.sender]].send(_refBonus); emit RefBonusPayed(msg.sender, referrer[referrer[msg.sender]], _refBonus, 2); } emit NewDeposit(msg.sender, queue.length - 1, msg.value, msg.value * (100 + percent) / 100, cycles); if (currentRefundIndex == 0) { reserved += msg.value * 96 / 100 / 2; if (delayed != 0) { reserved != delayed; delayed = 0; } pay(); } else { delayed += msg.value * 96 / 100 / 2; } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The function processes ether transfers to multiple addresses including the 'support' and referrer addresses. Because these transfers are made using 'send', an attacker could potentially exploit reentrancy by crafting a contract that calls back into the contract, leading to inconsistent state changes and potential double-spending.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    },
    {
        "function_name": "pay",
        "code": "function pay() private { uint128 money = uint128(address(this).balance - reserved); for(uint i=0; i<queue.length; i++){ uint idx = currentReceiverIndex + i; Deposit storage dep = queue[idx]; if(money >= dep.expect){ dep.depositor.send(dep.expect); money -= dep.expect; emit Payed(dep.depositor, dep.expect, cycles); delete queue[idx]; }else{ dep.depositor.send(money); dep.expect -= money; emit Payed(dep.depositor, money, cycles); break; } if(gasleft() <= 50000) break; } currentReceiverIndex += i; }",
        "vulnerability": "Gas limit and funds lock",
        "reason": "The use of 'send' to transfer ether means only 2300 gas is forwarded, which might not be enough for the recipient to process the transaction, especially if it is a contract. This can result in funds being locked in the contract, as the recipient will not receive the money and the queue will not be properly updated.",
        "file_name": "0x07a6ebf8549dd5cfdf201f6de9e7487113434dd7.sol"
    }
]