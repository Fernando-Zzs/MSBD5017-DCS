//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
Version 1.0 MVP 实现周期内基本逻辑

合约所有者：
1.初始化合约（仅一次）
2.每个epoch为合约设置必要的状态变量（开始/结束时间戳、参与者，同时初始化参数）

参与者：
1.查看所有参与者，进行投票决策
2.在epoch时间范围内转账给其他人（消耗自己的balances，增加别人的credits）
3.查看最终credits结果

*/

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

	// function withdraw() public isOwner {
	// 	(bool success, ) = owner.call{ value: address(this).balance }("");
	// 	require(success, "Failed to send Ether");
	// }

	// receive() external payable {}
}
