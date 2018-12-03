pragma solidity ^0.4.18;

import "./basic.sol";
import "./interfaceProposal.sol";
import "./math.sol";

contract proposal is InterfaceProposal, BasicToken {
	using SafeMath for uint256;

	modifier noCurrentProposal {
    	require(!ongoingProposal);
      	require(balanceOf(msg.sender) >= 1000000); //1000 token
      	_;
  	}
  	modifier currentProposal {
      	require(ongoingProposal);
      	require(registry[proposalNumber].votingEnd > block.timestamp);
	    _;
  	}
	// Proposal to raise Tap
  	function _setRaiseProposal() internal noCurrentProposal {
		_startProposal("Raise",2);
      	emit TapRaise(msg.sender, registry[proposalNumber].votingStart, registry[proposalNumber].votingEnd,"Vote To Raise Tap");
  	}

	function _setCustomVote(string _custom, uint256 _tt) internal noCurrentProposal {
		_startProposal(_custom,_tt);
      	emit CustomVote(msg.sender, registry[proposalNumber].votingStart, registry[proposalNumber].votingEnd,_custom);
  	}

	// Proposal to destroy the DAICO
  	function _setDestructProposal() internal noCurrentProposal {
		_startProposal("Destruct",1);
      	emit Destruct(msg.sender, registry[proposalNumber].votingStart, registry[proposalNumber].votingEnd,"Vote To destruct DAICO and return funds");
  	}

   	function _startProposal(string _proposal, uint256 _proposalType) internal {
    	ongoingProposal = true;
      	proposalNumber = proposalNumber.add(1);
      	registry[proposalNumber].votingStart = block.timestamp;
		registry[proposalNumber].proposalSetter = msg.sender;
		registry[proposalNumber].proposalName = _proposal;
      	registry[proposalNumber].votingEnd = block.timestamp.add(1296000);
		registry[proposalNumber].proposalType = _proposalType;
      	proposal = _proposal;
  	}

}
