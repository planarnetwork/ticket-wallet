pragma solidity 0.4.20;

import {RailTravelTicket} from "./RailTravelTicket.sol";


contract UKRailTravelTicket is RailTravelTicket {

  struct Journey {
    bytes32 id;
    Leg[] legs;
  }

  struct Fare {
    bytes32 id;
    bytes4 originNlc;
    bytes4 destinationNlc;
    bytes4 routeCode;
    bytes3 statusCode;
    uint price;
    uint originalPrice;
    Railcard railcard;
  }

  struct Leg {
    bytes32 id;
    bytes4 originNlc;
    bytes4 destinationNlc;
  }

  struct Railcard {
    bytes32 id;
    bytes3 code;
    string name;
    string description;
    uint8 minAdults;
    uint8 maxAdults;
    uint8 minChildren;
    uint8 maxChildren;
    uint8 maxPassengers;
  }

  struct Supplement {
    bytes32 id;
    bytes3 code;
    uint price;
  }

  struct SeatReservation {
    bytes32 id;
    byte coach;
    bytes3 unit;
  }

  Journey internal journey;
  Fare internal fare;
  SeatReservation[] internal seatReservations;
  Supplement[] internal supplements;
  Delivery internal delivery;

  bytes13 internal UTN;
  bytes5 internal transactionNumber;
  

  function UKRailTravelTicket(
    address _operator, 
    string _origin, 
    string _destination, 
    uint _departureDate, 
    uint _arrivalDate, 
    uint8 _numberOfAdults, 
    uint8 _numberOfChildren
    )
    RailTravelTicket(_operator, _origin, _destination, _departureDate, _arrivalDate, _numberOfAdults, _numberOfChildren)
    public 
  {
    price = 1000;
  }

  function getUTN() public onlyOwner view returns (bytes13) { return UTN; }
  function getTransactionNumber() public onlyOwner view returns (bytes5) { return transactionNumber; }
  
  function getDelivery() public view returns (Delivery) { return delivery; }
  function setDelivery(Delivery _delivery) public onlyOwner {
    delivery = _delivery;
  }
}