pragma solidity 0.4.19;

import "../cryptography/ECVerify.sol";


contract Fare {
  
  bytes32 public description;
  bytes4 public origin;
  bytes4 public destination;
  uint public departure;
  uint public arrival;
  uint public expiry;
  uint16 public price;
  address public retailer;
  bytes private signature;
  bytes32 public payloadUrl;

  function Fare(
    bytes32 _description,
    bytes4 _origin, 
    bytes4 _destination, 
    uint _departure, 
    uint _arrival, 
    uint _expiry, 
    uint16 _price, 
    address _retailer, 
    bytes _signature,
    bytes32 _payloadUrl) public
  {
    description = _description;
    origin = _origin;
    destination = _destination;
    departure = _departure;
    arrival = _arrival;
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
    return ECVerify.ecverify(getHash(), signature, retailer);
  }
}
