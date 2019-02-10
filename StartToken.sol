pragma solidity ^0.4.18;

import "./Startable.sol";
import "./StandardToken.sol";

/**
 * @title Startable token
 *
 * @dev StandardToken modified with startable transfers.
 **/

contract StartToken is Startable, StandardToken {
    struct Pay{
        uint256 date;
        uint256 value;
        uint256 category;
    }

    mapping( address => Pay[] ) log;


  function addLog(address id, uint256 _x, uint256 _y, uint256 _z) internal {
        log[id].push(Pay(_x,_y,_z));
  }

  function removeLog(address id, uint256 _x) internal {
        while (_x<log[id].length-1) {
            log[id][_x] = log[id][_x+1];
            _x++;
        }
        log[id].length--;
  }

  function getFreeCoin(address field) private view returns (uint256){
        uint arrayLength = log[field].length;
        uint256 totalValue = 0;
        for (uint i=0; i<arrayLength; i++) {
            uint256 date = log[field][i].date;
            uint256 value = log[field][i].value;
            uint256 category = log[field][i].category;
            // category = 1 acquisto private sale
            // category = 2 acquisto pre-ico
            // category = 3 acquisto ico
            // category = 4 acquisto bounty
            // category = 5 acquisto airdrop
            // category = 6 acquisto team
            // category = 7 acquisto advisor
            // category = 8 fondi bloccati per le aziende
            if( category == 1 || category == 2 ){
                if( (date + 750 days) <= now ){
                    totalValue += value;
                }else if( (date + 510 days) <= now ){
                    totalValue += value.mul(60).div(100);
                }else if( (date + 390 days) <= now ){
                    totalValue += value.mul(30).div(100);
                }
            }
            if( category == 3 ){
                if( (date + 690 days) <= now ){
                    totalValue += value;
                }else if( (date + 480 days) <= now ){
                    totalValue += value.mul(60).div(100);
                }else if( (date + 300 days) <= now ){
                    totalValue += value.mul(30).div(100);
                }
            }
            if( category == 4 || category == 5 ){
                if( (date + 720 days) <= now ){
                    totalValue += value;
                }else if( (date + 540 days) <= now ){
                    totalValue += value.mul(75).div(100);
                }else if( (date + 360 days) <= now ){
                    totalValue += value.mul(50).div(100);
                }
            }
            if( category == 6 ){
                if( (date + 1020 days) <= now ){
                    totalValue += value;
                }else if( (date + 810 days) <= now ){
                    totalValue += value.mul(70).div(100);
                }else if( (date + 630 days) <= now ){
                    totalValue += value.mul(40).div(100);
                }else if( (date + 450 days) <= now ){
                    totalValue += value.mul(20).div(100);
                }
            }
            if( category == 7 ){
                if( (date + 810 days) <= now ){
                    totalValue += value;
                }else if( (date + 600 days) <= now ){
                    totalValue += value.mul(80).div(100);
                }else if( (date + 420 days) <= now ){
                    totalValue += value.mul(40).div(100);
                }
            }
            if( category == 8 ){
                uint256 numOfMonths = now.sub(date).div(60).div(60).div(24).div(30).div(6);
                if( numOfMonths > 20 ){
                    numOfMonths = 20;
                }
                uint256 perc = 5;
                totalValue += value.mul((perc.mul(numOfMonths))).div(100);
            }
            if( category == 0 ){
                totalValue += value;
            }
        }
        return totalValue;
  }

  function deleteCoin(address field,uint256 val) internal {
        uint arrayLength = log[field].length;
        for (uint i=0; i<arrayLength; i++) {
            uint256 value = log[field][i].value;
            if( value >= val ){
                log[field][i].value = value - val;
                break;
            }else{
                val = val - value;
                log[field][i].value = 0;
				removeLog(field,i);
            }
        }
  }

  function getMyFreeCoin(address _addr) public constant returns(uint256) {
      return getFreeCoin(_addr);
  }

  function transfer(address _to, uint256 _value) public whenStarted returns (bool) {
        if( getFreeCoin(msg.sender) >= _value ){
            if( super.transfer(_to, _value) ){
                addLog(_to,now,_value,0);
				deleteCoin(msg.sender,_value);
                return true;
            }else{
                return false;
            }
        }
  }


  function transferCustom(address _to, uint256 _value, uint256 _cat) onlyOwner whenStarted public returns(bool success) {
	    addLog(_to,now,_value,_cat);
	    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public whenStarted returns (bool) {
        if( getFreeCoin(_from) >= _value ){
            if( super.transferFrom(_from, _to, _value) ){
                addLog(_to,now,_value,0);
				deleteCoin(msg.sender,_value);
                return true;
            }else{
                return false;
            }
        }
  }

  function approve(address _spender, uint256 _value) public whenStarted returns (bool) {
      if( getFreeCoin(msg.sender) >= _value ){
          return super.approve(_spender, _value);
      }else{
          revert();
      }
  }

  function increaseApproval(address _spender, uint _addedValue) public whenStarted returns (bool success) {
      if( getFreeCoin(msg.sender) >= allowed[msg.sender][_spender].add(_addedValue) ){
          return super.increaseApproval(_spender, _addedValue);
      }
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public whenStarted returns (bool success) {
    return super.decreaseApproval(_spender, _subtractedValue);
  }

}
