//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./myToken.sol";

contract YourContract {
	/* State Variables */
	address public immutable owner;
	uint public startTime;
	uint public endTime;
	uint internal totalParticipants;

	DCSTOKEN dcsToken;

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
	event newEpochStart(uint startTime, uint endTime);
	event userChanged(address newGuy);
	event gradeChanged(address addr, Level level);
	event transferFinished(address from, address to, uint amount);

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

	modifier afterActivePeriod() {
		require(
			block.timestamp < startTime || block.timestamp > endTime,
			"Contract is active"
		);
		_;
	}

	/* Function for Owner */
	function setTokenAddr(address tokenAddress) public OwnerOnly {
		dcsToken = DCSTOKEN(tokenAddress);
	}

	function mockUsers() public OwnerOnly {
		addUsers(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, Level.Platinum);
		addUsers(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, Level.Silver); //6
		addUsers(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, Level.Gold); //8
		addUsers(0x90F79bf6EB2c4f870365E785982E1f101E93b906, Level.Platinum); //10
		addUsers(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65, Level.Basic); //4
		totalParticipants += 5;
	}

	function mockTransfer() public OwnerOnly {
		transferTokens(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 2);
		transferTokens(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 3);
		transferTokens(0x90F79bf6EB2c4f870365E785982E1f101E93b906, 1);
		transferTokens(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65, 3);
	}

	function initEpoch(uint period) public OwnerOnly {
		startTime = block.timestamp;
		endTime = startTime + period;
		for (uint i = 0; i < addresses.length; i++) {
			address addr = addresses[i];
			users[addr].credits = 0;
			users[addr].balance = dispenseAlgo(users[addr].level);
		}
		emit newEpochStart(startTime, endTime);
	}

	function addUsers(address addr, Level level) public OwnerOnly {
		User memory user = User(addr, level, 0, 0);
		users[addr] = user;
		addresses.push(addr);
		totalParticipants++;
		emit userChanged(addr);
	}

	function upgradeLevel(address addr) internal OwnerOnly afterActivePeriod {
		require(users[addr].level != Level.Platinum, "Already highest level");
		uint intValue = uint(users[addr].level);
		intValue += 1;
		users[addr].level = Level(intValue);
		emit gradeChanged(addr, users[addr].level);
	}

	function degradeLevel(address addr) internal OwnerOnly afterActivePeriod {
		require(users[addr].level != Level.Basic, "Already lowest level");
		uint intValue = uint(users[addr].level);
		intValue -= 1;
		users[addr].level = Level(intValue);
		emit gradeChanged(addr, users[addr].level);
	}

	function dispenseAlgo(Level level) internal returns (uint) {
		uint8[4] memory weights = [11, 16, 21, 26];
		if (level == Level.Basic) return (totalParticipants * weights[0]) / 10;
		else if (level == Level.Silver)
			return (totalParticipants * weights[1]) / 10;
		else if (level == Level.Gold)
			return (totalParticipants * weights[2]) / 10;
		else return (totalParticipants * weights[3]) / 10;
	}

	function dispenseTokens(address _recipient, uint _amount) public OwnerOnly {
		bool sent = dcsToken.transfer(_recipient, _amount);
		require(sent, "Failed to transfer token to user");
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

	function updateUserRanking() public view returns (User[] memory) {
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
