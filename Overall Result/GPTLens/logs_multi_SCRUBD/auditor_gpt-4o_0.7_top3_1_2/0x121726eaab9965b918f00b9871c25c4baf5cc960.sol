[
    {
        "function_name": "distribute",
        "code": "function distribute () external { require(block.timestamp >= end); require(totalClaps > 0); uint256 totalReward = address(this).balance; emit Distribution(totalReward); for (uint256 i; i < attendees.length; i = i.add(1)) { if (states[attendees[i]] == ATTENDEE_REWARDED) continue; if (claps[attendees[i]] == 0) continue; uint256 reward = claps[attendees[i]] .mul(totalReward) .div(totalClaps); states[attendees[i]] = ATTENDEE_REWARDED; (bool success, ) = attendees[i].call.value(reward)(\"\"); if (success) { emit Transfer(attendees[i], reward); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `distribute` function uses `call.value` to transfer funds, which can be exploited by a reentrancy attack. An attacker could reenter the contract before the state is updated, allowing them to collect multiple rewards.",
        "file_name": "0x121726eaab9965b918f00b9871c25c4baf5cc960.sol"
    },
    {
        "function_name": "register",
        "code": "function register (address payable _attendee, uint256 _fee) internal { require(_fee == fee); require(states[_attendee] == ATTENDEE_UNREGISTERED); require(attendees.length < MAX_ATTENDEES); require(block.timestamp < end); states[_attendee] = ATTENDEE_REGISTERED; attendees.push(_attendee); }",
        "vulnerability": "Lack of access control",
        "reason": "The internal `register` function can be called by any address, allowing unauthorized registrations if exposed through inherited or extended contracts. This can be exploited in the `ProxyEvent` contract via the `registerFor` function.",
        "file_name": "0x121726eaab9965b918f00b9871c25c4baf5cc960.sol"
    },
    {
        "function_name": "clap",
        "code": "function clap ( address _clapper, address[] memory _attendees, uint256[] memory _claps ) internal { require(states[_clapper] == ATTENDEE_REGISTERED); require(_attendees.length == _claps.length); states[_clapper] = ATTENDEE_CLAPPED; uint256 givenClaps; for (uint256 i; i < _attendees.length; i = i.add(1)) { givenClaps = givenClaps.add(_claps[i]); if (_attendees[i] == _clapper) continue; if (states[_attendees[i]] == ATTENDEE_UNREGISTERED) continue; claps[_attendees[i]] = claps[_attendees[i]].add(_claps[i]); } require(givenClaps <= attendees.length.mul(CLAPS_PER_ATTENDEE)); totalClaps = totalClaps.add(givenClaps); }",
        "vulnerability": "Incorrect state transition",
        "reason": "The function sets the state of the `_clapper` to `ATTENDEE_CLAPPED` before validating the claps. An attacker can exploit this by submitting invalid claps, which would transition their state without adding valid claps, potentially affecting reward distribution.",
        "file_name": "0x121726eaab9965b918f00b9871c25c4baf5cc960.sol"
    }
]