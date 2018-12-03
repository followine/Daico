pragma solidity ^0.4.18;

import "./owner.sol";
import "./authorize.sol";

/**
 * @title Startable
 * @dev Base contract which allows owner to implement an start mechanism without ever being stopped more.
 */
contract Startable is Ownable, Authorizable {
  event Start();
  event StopV();

  bool public started = false;

  /**
   * @dev Modifier to make a function callable only when the contract is started.
   */
  modifier whenStarted() {
	require( (started || authorized[msg.sender]) && !blocked[msg.sender] );
    _;
  }

  /**
   * @dev called by the owner to start, go to normal state
   */
  function start() onlyOwner public {
    started = true;
    emit Start();
  }

  function stop() onlyOwner public {
    started = false;
    emit StopV();
  }

}
