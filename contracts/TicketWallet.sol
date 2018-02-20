pragma solidity 0.4.19;

import {ERC721Token} from "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import {Pausable} from "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import {FareOption} from "./types/FareOption.sol";


contract TicketWallet is ERC721Token, Pausable {

  enum TicketState {Created, Paid, Fulfilled}

  modifier onlyAdminOrOwnerOf(uint256 _tokenId) {
    require(owner == msg.sender || ownerOf(_tokenId) == msg.sender);
    _;
  }

  struct Ticket {
    bytes32 name;
    uint16 price;
    string payloadUrl;
    TicketState state;
    uint created;
    uint paid;
    address retailer;
  }

  Ticket[] public tickets;
  
  function createTicket(FareOption fareOption, string _payloadUrl) public payable returns (uint) {
    require(fareOption.checkSignature());
    require(fareOption.hasNotExpired());
    require(msg.value == fareOption.price());

    // solium-disable security/no-block-members
    Ticket memory _ticket = Ticket({
      name: fareOption.name(),
      price: fareOption.price(),
      payloadUrl: _payloadUrl,
      state: TicketState.Paid,
      created: now,
      paid: now,
      retailer: fareOption.retailer()
    });

    uint256 ticketId = tickets.push(_ticket) - 1;

    _mint(msg.sender, ticketId);

    return ticketId;
  }

  function markTicketAsFulfilled(uint256 _ticketId) public onlyOwner {
    tickets[_ticketId].state = TicketState.Fulfilled;
  }

  function getTicketNameById(uint256 _ticketId) public onlyAdminOrOwnerOf(_ticketId) constant returns (bytes32) {
    return tickets[_ticketId].name;
  }

  function getTicketPayloadUrlById(uint256 _ticketId) public onlyAdminOrOwnerOf(_ticketId) constant returns (string) {
    return tickets[_ticketId].payloadUrl;
  }
}
