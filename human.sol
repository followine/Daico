pragma solidity ^0.4.18;

import "./standard.sol";
import "./start.sol";

/**
 * Followine Token (WINE). More info www.followine.io
 */

contract HumanStandardToken is StandardToken, StartToken {
    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        approve(_spender, _value);
        require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData));
        return true;
    }
}
