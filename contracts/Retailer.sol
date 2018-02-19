pragma solidity 0.4.20;

import {Managed} from "./libs/ownership/Managed.sol";


contract Retailer is Managed {
  string public name;
  string public description;
  string public url;
  bytes32 public pubKey;
  
  function Retailer(
    string _name, 
    string _description, 
    string _url,
    bytes32 _pubKey
    ) public 
  {
    name = _name;
    description = _description;
    url = _url;
    pubKey = _pubKey;
  }
}