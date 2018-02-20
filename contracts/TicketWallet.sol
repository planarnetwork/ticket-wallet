pragma solidity 0.4.19;

import {ERC721Token} from "../libs/token/ERC721/ERC721Token.sol";
import {Pausable} from "../libs/lifecycle/Pausable.sol";
import {FareOption} from "./types/FareOption.sol";


contract TicketWallet is ERC721Token, Pausable {

  modifier onlyAdminOrTicketHolder(uint256 ticketId) {
    require(ownerOf(ticketId) == msg.sender);
    _;
  }

  modifier onlyUnpaid(uint256 _ticketId) {
    Ticket storage ticket = tickets[_ticketId];
    require(ticket.state != State.Created);
    _;
  }
  
  modifier onlyPaid(uint256 _ticketId) {
    Ticket storage ticket = tickets[_ticketId];
    require(ticket.state != State.Paid);
    _;
  }

  event Paid(uint256 ticketId);

  // How to securely store IPFS link so others can't read its content?

  enum State {Created, Paid, Fulfilled}

  struct Ticket {
    bytes32 name;
    uint16 price;
    State state;
    uint created;
    uint paid;
    address retailer;
  }

  Ticket[] public tickets;
  
  function createTicket(FareOption fareOption) public returns (uint) {
    require(fareOption.checkSignature());
    require(fareOption.hasNotExpired());

    Ticket memory _ticket = Ticket({
      name: fareOption.name(),
      price: fareOption.price(),
      state: State.Created,
      created: block.number,
      paid: 0,
      retailer: fareOption.retailer()
    });
    uint256 ticketId = tickets.push(_ticket) - 1;

    _mint(msg.sender, ticketId);

    return ticketId;
  }

  function pay(uint256 _ticketId) public payable onlyUnpaid(_ticketId) {
    Ticket storage ticket = tickets[_ticketId];

    require(msg.value < ticket.price);

    ticket.state = State.Paid;
    ticket.paid = block.number;
    
    Paid(_ticketId);
  }
}
