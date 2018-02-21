pragma solidity 0.4.19;

import {ERC721Token} from "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import {Pausable} from "zeppelin-solidity/contracts/lifecycle/Pausable.sol";


contract Retailers is ERC721Token, Pausable {
  
  struct Retailer {
    bytes32 name;
    bytes32 description;
    bytes32 url;
    bytes32 pubKey;
  }

  Retailer[] public retailers;

  function addRetailer(
    bytes32 _name, 
    bytes32 _description, 
    bytes32 _url, 
    bytes32 _pubKey) public returns (uint retailerId) 
  {
    require(_name[0] != 0);
    require(_pubKey[0] != 0);

    Retailer memory _retailer = Retailer({
      name: _name,
      description: _description,
      url: _url,
      pubKey: _pubKey
    });
    uint256 opId = retailers.push(_retailer) - 1;

    _mint(msg.sender, opId);

    return opId;
  }

  function nameById(uint _retailerId) public constant returns(bytes32) {
    return retailers[_retailerId].name;
  }

  function setNameById(uint _retailerId, bytes32 _name) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].name = _name;
  }

  function descriptionById(uint _retailerId) public constant returns(bytes32) {
    return retailers[_retailerId].description;
  }

  function setDescriptionById(uint _retailerId, bytes32 _description) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].description = _description;
  }

  function urlById(uint _retailerId) public constant returns(bytes32) {
    return retailers[_retailerId].url;
  }

  function setUrlById(uint _retailerId, bytes32 _url) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].url = _url;
  }

  function pubKeyById(uint _retailerId) public constant returns(bytes32) {
    return retailers[_retailerId].pubKey;
  }

  function setPubKey(uint _retailerId, bytes32 _pubKey) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].pubKey = _pubKey;
  }

}
