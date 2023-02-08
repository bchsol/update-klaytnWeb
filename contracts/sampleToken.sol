// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@klaytn/contracts/contracts/KIP/token/KIP7/KIP7.sol";

contract sampleToken is KIP7 {

    constructor() KIP7("sampleToken", "ST"){
        _mint(msg.sender, 1000000000*10**18);
    }
}