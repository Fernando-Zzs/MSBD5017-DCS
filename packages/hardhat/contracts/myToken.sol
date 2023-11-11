//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DCSTOKEN is ERC20 {
	address public owner;

	constructor(address _owner) ERC20("DCSTOKEN", "DCS") {
		owner = _owner;
	}

	function mint(address _contract, uint _amount) public {
		require(msg.sender == owner, "Only owner can mint");
		_mint(_contract, _amount);
	}
}
