pragma solidity 0.4.19;

import {ECTools} from "../cryptography/ECTools.sol";


contract Fare {
  
  bytes32 public description;
  uint public expiry;
  uint16 public price;
  address public retailer;
  bytes private signature;
  bytes32 public payloadUrl;

  function Fare(
    bytes32 _description,
    uint _expiry, 
    uint16 _price, 
    address _retailer,
    bytes _signature,
    bytes32 _payloadUrl) public
  {
    description = _description;
    expiry = _expiry;
    price = _price;
    retailer = _retailer;
    signature = _signature;
    payloadUrl = _payloadUrl;
  }

  function hasNotExpired() public constant returns(bool) {
    // solium-disable-next-line security/no-block-members
    return expiry < now;
  }

  function getHash() internal constant returns(bytes32) {
    return keccak256(payloadUrl, price);
  }

  function checkSignature() public view returns (bool) {
    return ECTools.isSignedBy(getHash(), string(signature), retailer);
  }
}
