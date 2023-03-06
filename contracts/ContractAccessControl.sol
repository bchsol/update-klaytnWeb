// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@klaytn/contracts/contracts/access/AccessControl.sol";

contract ContractAccessControl is AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");
    bytes32 public constant SMART_CONTRACT_ROLE = keccak256("SMART_CONTRACT_ROLE");

  /// Events for adding and removing various roles
  event AdminRoleGranted(address indexed beneficiary, address indexed caller);

  event AdminRoleRemoved(address indexed beneficiary, address indexed caller);

  event MinterRoleGranted(address indexed beneficiary, address indexed caller);

  event MinterRoleRemove(address indexed beneficiary, address indexed caller);

  event WhitelistRoleGranted(address indexed beneficiary, address indexed caller);

  event WhitelistRoleRemove(address indexed beneficiary, address indexed caller);

  event SmartContractRoleGranted(address indexed beneficiary, address indexed caller);

  event SmartContractRoleRemove(address indexed beneficiary, address indexed caller);

  /// The deployer is automatically given the admin role which will allow them to then grant roles to other addresses
  constructor() {
    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
  }

  /////////////
  // Lookups //
  /////////////

  /// Used to check whether an address has the admin role
  function hasAdminRole(address _address) external view returns (bool) {
    return hasRole(DEFAULT_ADMIN_ROLE, _address);
  }

  /// Used to check whether an address has the minter role
  function hasMinterRole(address _address) external view returns (bool) {
    return hasRole(MINTER_ROLE, _address);
  }
    /// Used to check whether an address has the minter role
  function hasWhitelistRole(address _address) external view returns (bool) {
      return hasRole(WHITELIST_ROLE, _address);
  }

  /// Used to check whether an address has the smart contract role
  function hasSmartContractRole(address _address) external view returns (bool) {
    return hasRole(SMART_CONTRACT_ROLE, _address);
  }

  ///////////////
  // Modifiers //
  ///////////////

  /// Grants the admin role to an address
  function addAdminRole(address _address) external {
    grantRole(DEFAULT_ADMIN_ROLE, _address);
  }

  /// Removes the admin role from an address
  function removeAdminRole(address _address) external {
    grantRole(DEFAULT_ADMIN_ROLE, _address);
  }

  /// Grants the minter role to an address
  function addMinterRole(address _address) external {
    grantRole(MINTER_ROLE, _address);
  }

  /// Grants the whitelist minter role to an address
  function addWhitelist(address _address) external {
      grantRole(WHITELIST_ROLE, _address);
  }

  /// Removes the whitelist minter role to an address
  function removeWhitelist(address _address) external {
      grantRole(WHITELIST_ROLE, _address);
  }

  /// Removes the minter role from an address
  function removeMinterRole(address _address) external {
    grantRole(MINTER_ROLE, _address);
  }

  /// Grants the smart contract role to an address
  function addSmartContractRole(address _address) external {
    grantRole(SMART_CONTRACT_ROLE, _address);
  }

  /// Removes the smart contract role from an address
  function removeSmartContractRole(address _address) external {
    grantRole(SMART_CONTRACT_ROLE, _address);
  }
}