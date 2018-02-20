pragma solidity 0.4.19;

import "../cryptography/ECVerify.sol";


contract FareOption {
  
  bytes32 public name;
  bytes4 public origin;
  bytes4 public destination;
  uint public departure;
  uint public arrival;
  uint public expiry;
  uint16 public price;

  address public retailer;
  bytes private signature;

  function FareOption(
    bytes32 _name,
    bytes4 _origin, 
    bytes4 _destination, 
    uint _departure, 
    uint _arrival, 
    uint _expiry, 
    uint16 _price, 
    address _retailer, 
    bytes _signature) public
  {
    name = _name;
    origin = _origin;
    destination = _destination;
    departure = _departure;
    arrival = _arrival;
    expiry = _expiry;
    price = _price;
    retailer = _retailer;

    signature = _signature;
  }

  function hasNotExpired() public constant returns(bool) {
    return expiry < now;
  }

  function getHash() internal constant returns(bytes32) {
    return keccak256(origin, destination, departure, arrival, expiry, price);
  }

  function checkSignature() public view returns (bool) {
    return ECVerify.ecverify(getHash(), signature, retailer);
  }
}
