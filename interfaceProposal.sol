pragma solidity ^0.4.18;

import "./basic.sol";

contract InterfaceProposal {
	uint256 public proposalNumber;
  	string public proposal;
  	bool public ongoingProposal;
  	bool public investorWithdraw;
  	mapping (uint256 => proposals) registry;

  	event TapRaise(address,uint256,uint256,string);
	event CustomVote(address,uint256,uint256,string);
  	event Destruct(address,uint256,uint256,string);

  	struct proposals {
		address proposalSetter;
   		uint256 votingStart;
   		uint256 votingEnd;
   		string proposalName;
		bool proposalResult;
		uint256 proposalType;
	}

	function _setRaiseProposal() internal;
	function _setCustomVote(string _custom, uint256 _tt) internal;
  	function _setDestructProposal() internal;
   	function _startProposal(string _proposal, uint256 _proposalType) internal;
}
