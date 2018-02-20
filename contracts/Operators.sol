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
  
  function nameById(uint _operatorId) public constant returns(string) {
    return operators[_operatorId].name;
  }

  function setNameById(uint _operatorId, string _name) public onlyOwnerOf(_operatorId) {
    operators[_operatorId].name = _name;
  }

  function descriptionById(uint _operatorId) public constant returns(string) {
    return operators[_operatorId].description;
  }

  function setDescriptionById(uint _operatorId, string _description) public onlyOwnerOf(_operatorId) {
    operators[_operatorId].description = _description;
  }

  function urlById(uint _operatorId) public constant returns(string) {
    return operators[_operatorId].url;
  }

  function setUrlById(uint _operatorId, string _url) public onlyOwnerOf(_operatorId) {
    operators[_operatorId].url = _url;
  }

  function pubKeyById(uint _operatorId) public constant returns(bytes32) {
    return operators[_operatorId].pubKey;
  }

  function setPubKey(uint _operatorId, bytes32 _pubKey) public onlyOwnerOf(_operatorId) {
    operators[_operatorId].pubKey = _pubKey;
  }

}
