//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MSBD5017Token is ERC20 {
    address public owner;

    constructor(address _owner, uint amount) ERC20("MSBD5017", "M57") {
        owner=_owner;
        _mint(owner, amount);
    }

    function transferToken(address recipient, uint256 amount) public {
        require(recipient != address(0), "Invalid recipient address");
        require(amount > 0, "Invalid token amount");

        require(transferFrom(owner, recipient, amount), "Token transfer failed");
    }
}