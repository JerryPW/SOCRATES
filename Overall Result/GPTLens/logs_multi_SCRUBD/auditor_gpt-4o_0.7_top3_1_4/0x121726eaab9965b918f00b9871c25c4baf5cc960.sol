[
    {
        "function_name": "distribute",
        "code": "function distribute () external { require(block.timestamp >= end); require(totalClaps > 0); uint256 totalReward = address(this).balance; emit Distribution(totalReward); for (uint256 i; i < attendees.length; i = i.add(1)) { if (states[attendees[i]] == ATTENDEE_REWARDED) continue; if (claps[attendees[i]] == 0) continue; uint256 reward = claps[attendees[i]] .mul(totalReward) .div(totalClaps); states[attendees[i]] = ATTENDEE_REWARDED; (bool success, ) = attendees[i].call.value(reward)(\"\"); if (success) { emit Transfer(attendees[i], reward); } } }",
        "vulnerability": "Reentrancy Attack",
        "reason": "The distribute function uses low-level call to transfer Ether, which is susceptible to reentrancy attacks. An attacker could re-enter the distribute function before the state is updated, potentially withdrawing more funds than allowed.",
        "file_name": "0x121726eaab9965b918f00b9871c25c4baf5cc960.sol"
    },
    {
        "function_name": "register",
        "code": "function register (address payable _attendee, uint256 _fee) internal { require(_fee == fee); require(states[_attendee] == ATTENDEE_UNREGISTERED); require(attendees.length < MAX_ATTENDEES); require(block.timestamp < end); states[_attendee] = ATTENDEE_REGISTERED; attendees.push(_attendee); }",
        "vulnerability": "Insufficient Fee Check",
        "reason": "The register function checks if the sent fee equals the required fee, but it does not ensure that the user pays the right amount of Ether, which could lead to incorrect registrations if the fee is incorrectly supplied or manipulated elsewhere.",
        "file_name": "0x121726eaab9965b918f00b9871c25c4baf5cc960.sol"
    },
    {
        "function_name": "clap",
        "code": "function clap ( address _clapper, address[] memory _attendees, uint256[] memory _claps ) internal { require(states[_clapper] == ATTENDEE_REGISTERED); require(_attendees.length == _claps.length); states[_clapper] = ATTENDEE_CLAPPED; uint256 givenClaps; for (uint256 i; i < _attendees.length; i = i.add(1)) { givenClaps = givenClaps.add(_claps[i]); if (_attendees[i] == _clapper) continue; if (states[_attendees[i]] == ATTENDEE_UNREGISTERED) continue; claps[_attendees[i]] = claps[_attendees[i]].add(_claps[i]); } require(givenClaps <= attendees.length.mul(CLAPS_PER_ATTENDEE)); totalClaps = totalClaps.add(givenClaps); }",
        "vulnerability": "State Manipulation",
        "reason": "The clap function updates the state of the clapper before the loop is completed, which could lead to inconsistencies if an error occurs later in the function. This premature state change could be exploited to manipulate the expected behavior of the contract, potentially allowing an attacker to bypass certain checks.",
        "file_name": "0x121726eaab9965b918f00b9871c25c4baf5cc960.sol"
    }
]