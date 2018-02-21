pragma solidity 0.4.19;

import {ERC721Token} from "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import {Pausable} from "zeppelin-solidity/contracts/lifecycle/Pausable.sol";


contract Operators is ERC721Token, Pausable {
  
  struct Operator {
    bytes32 name;
    bytes32 description;
    bytes32 url;
    bytes32 pubKey;
  }

  Operator[] public operators;

  function addOperator(
    bytes32 _name, 
    bytes32 _description, 
    bytes32 _url, 
    bytes32 _pubKey) 
  public returns (uint operatorId) 
  {
    require(_name[0] != 0);
    require(_pubKey[0] != 0);

    Operator memory _operator = Operator({
      name: _name,
      description: _description,
      url: _url,
      pubKey: _pubKey
    });
    uint256 opId = operators.push(_operator) - 1;

    _mint(msg.sender, opId);

    return opId;
  }
  
  function nameById(uint _operatorId) public constant returns(bytes32) {
    return operators[_operatorId].name;
  }

  function setNameById(uint _operatorId, bytes32 _name) public onlyOwnerOf(_operatorId) {
    operators[_operatorId].name = _name;
  }

  function descriptionById(uint _operatorId) public constant returns(bytes32) {
    return operators[_operatorId].description;
  }

  function setDescriptionById(uint _operatorId, bytes32 _description) public onlyOwnerOf(_operatorId) {
    operators[_operatorId].description = _description;
  }

  function urlById(uint _operatorId) public constant returns(bytes32) {
    return operators[_operatorId].url;
  }

  function setUrlById(uint _operatorId, bytes32 _url) public onlyOwnerOf(_operatorId) {
    operators[_operatorId].url = _url;
  }

  function pubKeyById(uint _operatorId) public constant returns(bytes32) {
    return operators[_operatorId].pubKey;
  }

  function setPubKey(uint _operatorId, bytes32 _pubKey) public onlyOwnerOf(_operatorId) {
    operators[_operatorId].pubKey = _pubKey;
  }

}
