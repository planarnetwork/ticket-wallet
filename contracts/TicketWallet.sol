pragma solidity 0.4.19;

import {ERC721Token} from "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import {Pausable} from "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import {Fare} from "./types/Fare.sol";

/**
 * Manage the creation and storage of tickets.
 */
contract TicketWallet is ERC721Token, Pausable {

  /**
   * Ticket lifecycle
   */
  enum TicketState {Paid, Fulfilled, Cancelled}

  /**
   * Methods of ticket fulfilment
   */
  enum FulfilmentMethod {eTicket, SelfPrint, ToD}

  /**
   * Ensure the given message sender is the owner or retailer of the token
   */
  modifier onlyRetailerOrOwnerOf(uint256 _ticketId) {
    require(tickets[_ticketId].retailer == msg.sender || ownerOf(_ticketId) == msg.sender);
    _;
  }

  /**
   * Ensure the given message sender is the retailer of the token
   */
  modifier onlyRetailerOf(uint256 _ticketId) {
    require(tickets[_ticketId].retailer == msg.sender);
    _;
  }

  /**
   * Ticket information
   */
  struct Ticket {
    bytes32 description;
    uint16 price;
    bytes32 payloadUrl;
    TicketState state;
    uint created;
    FulfilmentMethod fulfilmentMethod;
    bytes32 fulfilmentUrl;
    address retailer;
  }
  
  /**
   * Ticket storage
   */
  Ticket[] public tickets;

  /**
   * Add a ticket to the contract. 
   *
   * This function will ensure the fare option was created by an authorised retailer, convert the fare option to a
   * ticket and store it in the contract storage.
   */
  function createTicket(Fare fare, FulfilmentMethod _fulfilmentMethod) public payable returns (uint) {
    require(fare.checkSignature());
    require(fare.hasNotExpired());
    require(msg.value == fare.price());

    // solium-disable security/no-block-members
    Ticket memory _ticket = Ticket({
      description: fare.description(),
      price: fare.price(),
      payloadUrl: fare.payloadUrl(),
      state: TicketState.Paid,
      fulfilmentMethod: _fulfilmentMethod,
      fulfilmentUrl: 0,
      created: now,
      retailer: fare.retailer()
    });

    uint256 ticketId = tickets.push(_ticket) - 1;

    _mint(msg.sender, ticketId);

    return ticketId;
  }

  /**
   * Fulfil the ticket and attach the fulfilment URL
   */
  function fulfilTicket(uint256 _ticketId, bytes32 _fulfilmentUrl) public onlyRetailerOf(_ticketId) {
    tickets[_ticketId].state = TicketState.Fulfilled;
    tickets[_ticketId].fulfilmentUrl = _fulfilmentUrl;
  }

  /**
   * Return the description of the ticket 
   */
  function getTicketDescriptionById(uint256 _ticketId) public onlyRetailerOrOwnerOf(_ticketId) constant returns (bytes32) {
    return tickets[_ticketId].description;
  }

  /**
   * Return the URL of the full ticket details
   */
  function getTicketPayloadUrlById(uint256 _ticketId) public onlyRetailerOrOwnerOf(_ticketId) constant returns (bytes32) {
    return tickets[_ticketId].payloadUrl;
  }
  
  /**
   * Return the URL containing the fulfilment information
   */
  function getFulfilmentUrlById(uint256 _ticketId) public onlyRetailerOrOwnerOf(_ticketId) constant returns (bytes32) {
    require(tickets[_ticketId].state == TicketState.Fulfilled);

    return tickets[_ticketId].fulfilmentUrl;
  }  
}
