//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MSBD5017Token is ERC20 {
    // constructor() ERC20("MSBD5017", "M57") {
    //     _mint(msg.sender, 10000000000000000000000000);
    // }
    address public owner;

    constructor(address _owner) ERC20("MSBD5017", "M57") {
        owner=_owner;
        _mint(owner, 10000000000000000000000000);
    }
}