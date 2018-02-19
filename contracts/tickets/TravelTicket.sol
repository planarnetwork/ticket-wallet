pragma solidity 0.4.20;

import {Delivery} from "../types/Delivery.sol";
import {Transport} from "../types/Transport.sol";
import {Ticket} from "../Ticket.sol";


contract TravelTicket is Ticket {
  address internal operator;
  Transport.Type internal transportType;
  string internal  origin;
  string internal destination;
  uint internal departureDate;
  uint internal arrivalDate;
  uint8 internal numberOfAdults;
  uint8 internal numberOfChildren;
  Delivery internal delivery;

  function TravelTicket(
    address _operator, 
    Transport.Type _transportType, 
    string _origin, 
    string _destination, 
    uint _departureDate, 
    uint _arrivalDate, 
    uint8 _numberOfAdults, 
    uint8 _numberOfChildren
    ) public 
  {
    operator = _operator;
    transportType = _transportType;
    origin = _origin;
    destination = _destination;
    departureDate = _departureDate;
    arrivalDate = _arrivalDate;
    numberOfAdults = _numberOfAdults;
    numberOfChildren = _numberOfChildren;
  }

  function getOperator() public onlyOwner view returns (address) { return operator; }
  function getTransportType() public onlyOwner view returns (Transport.Type) { return transportType; }
  function getOrigin() public onlyOwner view returns (string) { return origin; }
  function getDestination() public onlyOwner view returns (string) { return destination; }
  function getDepartureDate() public onlyOwner view returns (uint) { return departureDate; }
  function getArrivalDate() public onlyOwner view returns (uint) { return arrivalDate; }
  function getNumberOfAdults() public onlyOwner view returns (uint8) { return numberOfAdults; }
  function getNumberOfChildren() public onlyOwner view returns (uint8) { return numberOfChildren; }
}



