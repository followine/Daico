pragma solidity ^0.4.18;

import "./Ownable.sol";


/**
 * @title Authorizable
 * @dev The Authorizable contract has authorized addresses, and provides basic authorization control
 * functions, this simplifies the implementation of "multiple user permissions".
 */
contract Authorizable is Ownable {
  mapping(address => bool) public authorized;
  mapping(address => bool) public blocked;

  event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);

  /**
   * @dev The Authorizable constructor sets the first `authorized` of the contract to the sender
   * account.
   */
  constructor() public {
	authorized[msg.sender] = true;
  }

  /**
   * @dev Throws if called by any account other than the authorized.
   */
  modifier onlyAuthorized() {
    require(authorized[msg.sender]);
    _;
  }

 /**
   * @dev Allows the current owner to set an authorization.
   * @param addressAuthorized The address to change authorization.
   */
  function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
    emit AuthorizationSet(addressAuthorized, authorization);
    authorized[addressAuthorized] = authorization;
  }

  function setBlocked(address addressAuthorized, bool authorization) onlyOwner public {
    blocked[addressAuthorized] = authorization;
  }

}
