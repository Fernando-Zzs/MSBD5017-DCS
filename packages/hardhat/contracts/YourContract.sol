//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

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
}
