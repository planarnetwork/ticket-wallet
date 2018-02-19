pragma solidity 0.4.20;

import {TravelTicket} from "./TravelTicket.sol";


contract RailTravelTicket is TravelTicket {
  function RailTravelTicket(
    address _operator, 
    string _origin, 
    string _destination, 
    uint _departureDate, 
    uint _arrivalDate, 
    uint8 _numberOfAdults, 
    uint8 _numberOfChildren
    ) public 
  {
    operator = _operator;
    transportType = Transport.Type.Rail;
    origin = _origin;
    destination = _destination;
    departureDate = _departureDate;
    arrivalDate = _arrivalDate;
    numberOfAdults = _numberOfAdults;
    numberOfChildren = _numberOfChildren;
  }
}