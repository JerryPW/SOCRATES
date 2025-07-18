[
    {
        "function_name": "distribute",
        "code": "function distribute () external { require(block.timestamp >= end); require(totalClaps > 0); uint256 totalReward = address(this).balance; emit Distribution(totalReward); for (uint256 i; i < attendees.length; i = i.add(1)) { if (states[attendees[i]] == ATTENDEE_REWARDED) continue; if (claps[attendees[i]] == 0) continue; uint256 reward = claps[attendees[i]] .mul(totalReward) .div(totalClaps); states[attendees[i]] = ATTENDEE_REWARDED; (bool success, ) = attendees[i].call.value(reward)(\"\"); if (success) { emit Transfer(attendees[i], reward); } } }",
        "vulnerability": "Reentrancy vulnerability",
        "reason": "The `distribute` function sends Ether to attendees using a low-level call without proper reentrancy protection. An attacker can exploit this by re-entering the contract and potentially manipulating rewards or states before the function completes its execution. This can lead to incorrect distribution of rewards or depletion of the contract's balance.",
        "file_name": "0x121726eaab9965b918f00b9871c25c4baf5cc960.sol"
    },
    {
        "function_name": "register",
        "code": "function register (address payable _attendee, uint256 _fee) internal { require(_fee == fee); require(states[_attendee] == ATTENDEE_UNREGISTERED); require(attendees.length < MAX_ATTENDEES); require(block.timestamp < end); states[_attendee] = ATTENDEE_REGISTERED; attendees.push(_attendee); } function register () external payable { register(msg.sender, msg.value); }",
        "vulnerability": "Lack of proper fee handling",
        "reason": "The `register` function does not check if the provided fee matches the expected fee. An attacker can potentially pass a different value as a fee, which can lead to incorrect registration or manipulation of event state. Additionally, there is no handling for excess Ether sent, which could lead to accidental overpayment without refund.",
        "file_name": "0x121726eaab9965b918f00b9871c25c4baf5cc960.sol"
    },
    {
        "function_name": "clap",
        "code": "function clap (address _clapper, address[] memory _attendees, uint256[] memory _claps) internal { require(states[_clapper] == ATTENDEE_REGISTERED); require(_attendees.length == _claps.length); states[_clapper] = ATTENDEE_CLAPPED; uint256 givenClaps; for (uint256 i; i < _attendees.length; i = i.add(1)) { givenClaps = givenClaps.add(_claps[i]); if (_attendees[i] == _clapper) continue; if (states[_attendees[i]] == ATTENDEE_UNREGISTERED) continue; claps[_attendees[i]] = claps[_attendees[i]].add(_claps[i]); } require(givenClaps <= attendees.length.mul(CLAPS_PER_ATTENDEE)); totalClaps = totalClaps.add(givenClaps); } function clap (address[] calldata _attendees, uint256[] calldata _claps) external { clap(msg.sender, _attendees, _claps); }",
        "vulnerability": "Clap distribution manipulation",
        "reason": "The `clap` function allows an attendee to distribute claps to others, but there is no check to prevent double clapping or ensure fairness. An attacker can register multiple accounts and clap for themselves to artificially inflate their claps, thereby receiving a larger share of the reward in the `distribute` function.",
        "file_name": "0x121726eaab9965b918f00b9871c25c4baf5cc960.sol"
    }
]