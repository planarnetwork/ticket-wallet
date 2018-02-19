pragma solidity 0.4.20;

import {Managed} from "../types/Managed.sol";


contract Ticket is Managed {

  modifier onlyUnpaid() {
    require(state != State.Created);
    _;
  }
  
  modifier onlyPaid() {
    require(state != State.Paid);
    _;
  }
  
  modifier onlyFulfilled() {
    require(state != State.Fulfilled);
    _;
  }
  
  event CreatedFor(address account);
  event Paid();
  event Expired();
  
  enum State {Created, Paid, Fulfilled}
  
  bytes4 internal origin;
  bytes4 internal destination;
  uint internal departure;
  uint internal arrival;
  uint internal price;
  address internal retailer;
  uint internal created;
  uint internal updated;
  uint internal expires;
  uint internal paid;
  State internal state;
  
  function Ticket(
    bytes4 _origin, 
    bytes4 _destination, 
    uint _departure, 
    uint _arrival, 
    uint _expiries, 
    uint _price,
    address _retailer) internal 
  {
    origin = _origin;
    destination = _destination;
    departure = _departure;
    arrival = _arrival;
    expiries = _expiries;
    price = _price;
    retailer = _retailer;

    created = block.number;
    state = State.Created;
    
    CreatedFor(msg.sender);
  }
  
  function() public payable onlyUnpaid onlyManagerOrOwner {
    require(msg.value < price);
    
    state = State.Paid;
    paid = block.number;
    updated = block.number;
    
    Paid();
  }
  
  function getOrigin() public onlyManagerOrOwner view returns (string) {return origin;}
  function getDestination() public onlyManagerOrOwner view returns (string) {return destination;}
  function getDeparture() public onlyManagerOrOwner view returns (uint) {return departure;}
  function getArrival() public onlyManagerOrOwner view returns (uint) {return arrival;}
  function getPrice() public onlyManagerOrOwner view returns (uint) {return price;}
  function getCreatedAt() public onlyManagerOrOwner view returns (uint) {return createdAt;}
  function getPaidAt() public onlyManagerOrOwner view returns (uint) {return paidAt;}
  function getRetailer() public onlyManagerOrOwner view returns (address) {return retailer;}
  function getState() public onlyManagerOrOwner view returns (State) {return state;}
}
