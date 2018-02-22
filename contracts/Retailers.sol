pragma solidity 0.4.19;

import {ERC721Token} from "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import {Pausable} from "zeppelin-solidity/contracts/lifecycle/Pausable.sol";


contract Retailers is ERC721Token, Pausable {
  
  struct Retailer {
    address addr;
    bytes32 name;
    uint txFeeAmount;
    bytes32 pubKey;
  }

  Retailer[] public retailers;

  function addRetailer(
    address _address,
    bytes32 _name,
    bytes32 _pubKey) public returns (uint retailerId) 
  {
    return addRetailer(
      _address,
      _name,
      0,
      _pubKey
    );
  }

  function addRetailer(
    address _address,
    bytes32 _name,
    uint _txFeeAmount,
    bytes32 _pubKey) public returns (uint retailerId) 
  {
    require(_name[0] != 0);
    require(_pubKey[0] != 0);

    Retailer memory _retailer = Retailer({
      addr: _address,
      name: _name,
      txFeeAmount: _txFeeAmount,
      pubKey: _pubKey
    });
    uint256 opId = retailers.push(_retailer) - 1;

    _mint(msg.sender, opId);

    return opId;
  }

  function addressById(uint _retailerId) public constant returns(address) {
    return retailers[_retailerId].addr;
  }

  function setAddressById(uint _retailerId, address _address) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].addr = _address;
  }

  function nameById(uint _retailerId) public constant returns(bytes32) {
    return retailers[_retailerId].name;
  }

  function setNameById(uint _retailerId, bytes32 _name) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].name = _name;
  }

  function txFeeAmountById(uint _retailerId) public constant returns(uint) {
    return retailers[_retailerId].txFeeAmount;
  }

  function setTxFeeAmount(uint _retailerId, uint _txFeeAmount) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].txFeeAmount = _txFeeAmount;
  }

  function pubKeyById(uint _retailerId) public constant returns(bytes32) {
    return retailers[_retailerId].pubKey;
  }

  function setPubKey(uint _retailerId, bytes32 _pubKey) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].pubKey = _pubKey;
  }
}
