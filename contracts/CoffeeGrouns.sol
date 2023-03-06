// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@klaytn/contracts/contracts/KIP/token/KIP7/KIP7.sol";
import "./ContractAccessControl.sol";

contract CoffeeGrouns is KIP7{

    ContractAccessControl public accessControls;

    constructor(string memory _name, string memory _symbol, ContractAccessControl _accessControls) KIP7(_name,_symbol) {
        accessControls = _accessControls;
    }

    function mint(uint256 _amount) external {
        require(accessControls.hasAdminRole(_msgSender()), "Sender must have permission to admin");
        _mint(address(this),_amount);

    }
}