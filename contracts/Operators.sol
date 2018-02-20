pragma solidity 0.4.20;

import {ERC721Token} from "./libs/token/ERC721/ERC721Token.sol";
import {Pausable} from "./libs/lifecycle/Pausable.sol";


contract Operators is ERC721Token, Pausable {
  
  struct Operator {
    string name;
    string description;
    string url;
    bytes32 pubKey;
  }

  Operator[] public operators;

  function addOperator(string _name, string _description, string _url, bytes32 _pubKey) public returns (uint operatorId) {
    bytes memory name = bytes(_name);
    require(bytes(name).length > 0);
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

  function operatorById(uint _operatorId) internal onlyOwnerOf(_operatorId) returns(Operator) {
    return operators[_operatorId];
  }
  
  function nameById(uint _operatorId) public returns(string) {
    return operatorById(_operatorId).name;
  }

  function setNameById(uint _operatorId, string _name) public onlyOwnerOf(_operatorId) {
    operatorById(_operatorId).name = _name;
  }

  function descriptionById(uint _operatorId) public returns(string) {
    return operatorById(_operatorId).description;
  }

  function setDescriptionById(uint _operatorId, string _description) public onlyOwnerOf(_operatorId) {
    operatorById(_operatorId).description = _description;
  }

  function urlById(uint _operatorId) public onlyOwnerOf(_operatorId) returns(string) {
    return operatorById(_operatorId).url;
  }

  function setUrlById(uint _operatorId, string _url) public onlyOwnerOf(_operatorId) {
    operatorById(_operatorId).url = _url;
  }

  function pubKeyById(uint _operatorId) public onlyOwnerOf(_operatorId) returns(bytes32) {
    return operatorById(_operatorId).pubKey;
  }

  function setPubKey(uint _operatorId, bytes32 _pubKey) public onlyOwnerOf(_operatorId) {
    operatorById(_operatorId).pubKey = _pubKey;
  }

}
