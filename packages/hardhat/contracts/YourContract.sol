//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./myToken.sol";

contract YourContract {
	/* State Variables */
	address public immutable owner;
	uint public startTime;
	uint public endTime;

	enum Level {
		Basic,
		Silver,
		Gold,
		Platinum
	}
	struct User {
		address userAddress;
		Level level;
		uint balance;
		uint credits;
	}

	mapping(address => User) public users;
	address[] public addresses;

	/* Events */
	event timeChanged(uint startTime, uint endTime);
	event userChanged(address newGuy);
	event initFinished();
	event gradeChanged(address addr, Level level);
	event transferFinished(address from, address to, uint amount);

	/* Constructor */
	constructor(address _owner) {
		owner = _owner;
		startTime = block.timestamp;
		endTime = block.timestamp + 2592000; // 默认30天有效期
	}

	/* Modifier */
	modifier OwnerOnly() {
		require(msg.sender == owner, "Not the Owner");
		_;
	}

	// 效率较低，浪费gas，在v1.1会改进
	modifier ParticipantOnly() {
		bool isParticipant = false;
		for (uint i = 0; i < addresses.length; i++) {
			if (addresses[i] == msg.sender) {
				isParticipant = true;
				break;
			}
		}
		require(isParticipant, "Caller is not a participant");
		_;
	}

	modifier duringActivePeriod() {
		require(
			block.timestamp >= startTime && block.timestamp <= endTime,
			"Contract is not active"
		);
		_;
	}

	/* Function for Owner */
	function setStartTime(uint _startTime) public OwnerOnly {
		startTime = _startTime;
		emit timeChanged(startTime, endTime);
	}

	function setEndTime(uint _endTime) public OwnerOnly {
		endTime = _endTime;
		emit timeChanged(startTime, endTime);
	}

	function initBalancesAndCredits() public OwnerOnly {
		for (uint i = 0; i < addresses.length; i++) {
			address addr = addresses[i];
			users[addr].credits = 0;
			users[addr].balance = dispenseAlgo(users[addr].level);
		}
		emit initFinished();
	}

	function addUsers(address addr, Level level) public OwnerOnly {
		User memory user = User(addr, level, 0, 0);
		users[addr] = user;
		addresses.push(addr);
		emit userChanged(addr);
	}

	function upgradeLevel(address addr) internal OwnerOnly {
		require(users[addr].level != Level.Platinum, "Already highest level");
		uint intValue = uint(users[addr].level);
		intValue += 1;
		users[addr].level = Level(intValue);
		emit gradeChanged(addr, users[addr].level);
	}

	function degradeLevel(address addr) internal OwnerOnly {
		require(users[addr].level != Level.Basic, "Already lowest level");
		uint intValue = uint(users[addr].level);
		intValue -= 1;
		users[addr].level = Level(intValue);
		emit gradeChanged(addr, users[addr].level);
	}

	function dispenseAlgo(Level level) internal pure returns (uint) {
		if (level == Level.Basic) return 100;
		else if (level == Level.Silver) return 200;
		else if (level == Level.Gold) return 300;
		else return 400;
	}

	/* Function for Participants */
	function transferTokens(
		address recipient,
		uint amount
	) public ParticipantOnly duringActivePeriod {
		require(amount > 0, "Amount must be greater than zero");
		require(users[msg.sender].balance >= amount, "Insufficient balance");
		require(msg.sender != recipient, "Can not transfer to yourself");

		users[msg.sender].balance -= amount;
		users[recipient].credits += amount;
		emit transferFinished(msg.sender, recipient, amount);
	}

	// 按照credits数目从大到小排序
	function sortUsersByCredits() public view returns (User[] memory) {
		uint length = addresses.length;
		User[] memory sortedUsers = new User[](length);

		for (uint i = 0; i < length; i++) {
			sortedUsers[i] = users[addresses[i]];
		}

		quickSort(sortedUsers, int(0), int(length - 1));

		return sortedUsers;
	}

	// 快速排序算法
	function quickSort(User[] memory arr, int left, int right) internal pure {
		if (left < right) {
			int pivotIndex = partition(arr, left, right);
			quickSort(arr, left, pivotIndex - 1);
			quickSort(arr, pivotIndex + 1, right);
		}
	}

	function partition(
		User[] memory arr,
		int left,
		int right
	) internal pure returns (int) {
		User memory pivot = arr[uint(right)];
		int i = left - 1;

		for (int j = left; j < right; j++) {
			if (arr[uint(j)].credits >= pivot.credits) {
				i++;
				(arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
			}
		}

		(arr[uint(i + 1)], arr[uint(right)]) = (
			arr[uint(right)],
			arr[uint(i + 1)]
		);

		return i + 1;
	}
}
