//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract YourContract {
	/* State Variables */
	address public immutable owner;
	uint public startTime;
	uint public endTime;
	address[] public participants;
	mapping(address => uint) public credits;
	mapping(address => uint) public balances;

	/* Events */

	/* Constructor */
	constructor(address _owner) {
		owner = _owner;
	}

	/* Modifier */
	modifier OwnerOnly() {
		require(msg.sender == owner, "Not the Owner");
		_;
	}

	// 效率较低，浪费gas，在v1.1会改进
	modifier ParticipantOnly() {
		bool isParticipant = false;
		for (uint i = 0; i < participants.length; i++) {
			if (participants[i] == msg.sender) {
				isParticipant = true;
				break;
			}
		}
		require(isParticipant, "Caller is not a participant");
		_;
	}

	/* Function for Owner */
	function initEpochInfo(
		uint _startTime,
		uint _endTime,
		address[] memory _participants
	) public OwnerOnly {
		startTime = _startTime;
		endTime = _endTime;
		participants = _participants;

		initBalances();
		initCredits();
	}

	// 平均分配，在v2.0版本引入DID会改进
	function initBalances() internal {
		for (uint i = 0; i < participants.length; i++) {
			balances[participants[i]] = 100;
		}
	}

	function initCredits() internal {
		for (uint i = 0; i < participants.length; i++) {
			credits[participants[i]] = 0;
		}
	}

	/* Function for Participants */
	function transferTokens(
		address recipient,
		uint amount
	) public ParticipantOnly {
		require(
			block.timestamp >= startTime && block.timestamp < endTime,
			"Transfer not allowed outside the time period"
		);
		require(amount > 0, "Amount must be greater than zero");
		require(balances[msg.sender] >= amount, "Insufficient balance");

		balances[msg.sender] -= amount;
		credits[recipient] += amount;
	}

	function getRecipientRank(address recipient) public view returns (uint) {
    	require(credits[recipient] > 0, "Recipient has no credits");
    
    	uint rank = 1;
    
    	for (uint i = 0; i < participants.length; i++) {
        	if (participants[i] != recipient && credits[participants[i]] > credits[recipient]) {
            	rank++;
        	}
    	}
    
    return rank;
	}

}
