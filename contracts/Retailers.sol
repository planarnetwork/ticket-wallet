pragma solidity 0.4.19;

import {ERC721Token} from "../libs/token/ERC721/ERC721Token.sol";
import {Pausable} from "../libs/lifecycle/Pausable.sol";


contract Retailers is ERC721Token, Pausable {
  
  struct Retailer {
    string name;
    string description;
    string url;
    bytes32 pubKey;
  }

  Retailer[] public retailers;

  function addRetailer(string _name, string _description, string _url, bytes32 _pubKey) public returns (uint retailerId) {
    bytes memory name = bytes(_name);
    require(bytes(name).length > 0);
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

  function nameById(uint _retailerId) public constant returns(string) {
    return retailers[_retailerId].name;
  }

  function setNameById(uint _retailerId, string _name) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].name = _name;
  }

  function descriptionById(uint _retailerId) public constant returns(string) {
    return retailers[_retailerId].description;
  }

  function setDescriptionById(uint _retailerId, string _description) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].description = _description;
  }

  function urlById(uint _retailerId) public constant returns(string) {
    return retailers[_retailerId].url;
  }

  function setUrlById(uint _retailerId, string _url) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].url = _url;
  }

  function pubKeyById(uint _retailerId) public constant returns(bytes32) {
    return retailers[_retailerId].pubKey;
  }

  function setPubKey(uint _retailerId, bytes32 _pubKey) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].pubKey = _pubKey;
  }

}
