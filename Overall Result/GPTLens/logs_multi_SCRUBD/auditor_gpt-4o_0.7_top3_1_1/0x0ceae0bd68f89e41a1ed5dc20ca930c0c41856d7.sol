[
    {
        "function_name": "kill",
        "code": "function kill() onlyOwner { if(totalEscrows > 0) { logDebug(\"totalEscrows > 0\"); return; } if(feeFunds > 0) { logDebug(\"feeFunds > 0\"); return; } suicide(msg.sender); }",
        "vulnerability": "Improper contract destruction",
        "reason": "The kill function uses the suicide opcode (now known as selfdestruct) to destroy the contract. This can lead to the loss of all funds held by the contract if called improperly. Although it checks for totalEscrows and feeFunds before proceeding, its reliance on these checks without auditing their possible manipulation leaves it vulnerable. If the seller manipulates these values or if there is a logical error elsewhere in the contract, the contract can be destroyed unexpectedly.",
        "file_name": "0x0ceae0bd68f89e41a1ed5dc20ca930c0c41856d7.sol"
    },
    {
        "function_name": "safeSend",
        "code": "function safeSend(address addr, uint value) internal { if(atomicLock) throw; atomicLock = true; if (!(addr.call.gas(safeGas).value(value)())) { atomicLock = false; throw; } atomicLock = false; }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The safeSend function is designed to transfer funds, but it uses call.value()(), which is known to be vulnerable to reentrancy attacks. Although there is an atomicLock mechanism intended to prevent reentrancy, the lock is released before the external call completes. If an attacker can manipulate the atomicLock state or the flow of the function, they may execute a reentrant call and drain funds from the contract.",
        "file_name": "0x0ceae0bd68f89e41a1ed5dc20ca930c0c41856d7.sol"
    },
    {
        "function_name": "buy",
        "code": "function buy(uint _lockId, string _dataInfo, uint _version, uint16 _count) payable { if(status != Available) throw; if(msg.value < (price * _count)) throw; if(_count > availableCount) throw; if(_count == 0) throw; if(feePromille > 1000) throw; if(rewardPromille > 1000) throw; if((feePromille + rewardPromille) > 1000) throw; EscrowInfo info = escrows[_lockId]; if(info.lockedFunds > 0) throw; uint fee = (msg.value * feePromille) / 1000; if(fee > msg.value) throw; uint funds = (msg.value - fee); feeFunds += fee; totalEscrows += 1; info.buyer = msg.sender; info.lockedFunds = funds; info.frozenFunds = 0; info.buyerNo = false; info.sellerNo = false; info.count = _count; pendingCount += _count; buyers[msg.sender] = true; logEvent(_lockId, _dataInfo, _version, Buy, msg.sender, _count, msg.value); }",
        "vulnerability": "Overflow and incorrect fee calculation",
        "reason": "The buy function does not properly handle edge cases for fee calculations. If feePromille is set to a value greater than 1000, it will result in a fee that exceeds the amount sent (msg.value), causing an overflow in the subtraction (msg.value - fee), leading to an incorrect funds value. Additionally, it does not handle cases where the fee calculation itself overflows, which may lead to unexpected behavior or denial of service.",
        "file_name": "0x0ceae0bd68f89e41a1ed5dc20ca930c0c41856d7.sol"
    }
]