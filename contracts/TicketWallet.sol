pragma solidity ^0.5.0;

import {ERC721Full} from "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import {ERC721Mintable} from "openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol";
import {ECDSA} from "openzeppelin-solidity/contracts/cryptography/ECDSA.sol";

/**
 * Manage the creation and storage of tickets.
 */
contract TicketWallet is ERC721Full("Ticket wallet", "PLNR-WALLET"), ERC721Mintable {

  /**
   * Ticket lifecycle
   */
  enum TicketState {Paid, Fulfilled, Cancelled}

  /**
   * Ensure the given message sender is the owner or retailer of the token
   */
  modifier onlyRetailerOrOwnerOf(uint256 _ticketId) {
    require(tickets[_ticketId].retailer == msg.sender || ownerOf(_ticketId) == msg.sender, "Must be owner or retailer");
    _;
  }

  /**
   * Ensure the given message sender is the retailer of the token
   */
  modifier onlyRetailerOf(uint256 _ticketId) {
    require(tickets[_ticketId].retailer == msg.sender, "Must be retailer");
    _;
  }

  /**
   * Ticket information
   */
  struct Ticket {
    string description;
    uint price;
    TicketState state;
    string fulfilmentURI;
    address retailer;
  }

  /**
   * Fulfilment queues
   */
  mapping(address => uint[]) internal fulfilment;

  /**
   * Ticket storage
   */
  Ticket[] internal tickets;

  /**
   * Add a ticket to the contract. 
   *
   * This function will ensure the price, expiry time and payload were created by an authorised retailer, create the
   * ticket and store it in the contract storage.
   */
  function createTicket(
    string memory _description,
    string memory _itemUrl,
    uint _expiry,
    address payable _retailer,
    bytes memory _signature
  ) 
    public 
    payable 
    returns (uint) 
  {
    bytes32 _expectedHash = keccak256(abi.encodePacked(_itemUrl, "_", msg.value, "_", _expiry));
    bytes32 _expectedSignature = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _expectedHash));

    require(ECDSA.recover(_expectedSignature, _signature) == _retailer, "Invalid signature");
    require(_expiry > now, "Offer has expired");

    Ticket memory _ticket = Ticket({
      description: _description,
      price: msg.value,
      state: TicketState.Paid,
      fulfilmentURI: "",
      retailer: _retailer
    });

    uint _ticketId = tickets.push(_ticket) - 1;

    _mint(msg.sender, _ticketId);
    _setTokenURI(_ticketId, _itemUrl);
    _retailer.transfer(msg.value);

    fulfilment[_retailer].push(_ticketId);

    return _ticketId;
  }

  /**
   * Fulfil the ticket and attach the fulfilment URL
   */
  function fulfilTicket(uint _ticketId, string memory _fulfilmentURI) public onlyRetailerOf(_ticketId) {
    uint _indexInFulfilmentQueue = getQueueIndex(_ticketId);

    require(_indexInFulfilmentQueue != fulfilment[msg.sender].length, "Ticket must be queued for fulfilment");
    require(tickets[_ticketId].state == TicketState.Paid, "Ticket state must be Paid");

    tickets[_ticketId].state = TicketState.Fulfilled;
    tickets[_ticketId].fulfilmentURI = _fulfilmentURI;

    removeFromQueue(_indexInFulfilmentQueue);
  }

  /**
   * Get the index of the ticket in the queue
   */
  function getQueueIndex(uint _ticketId) private view returns (uint) {
    for (uint i = 0; i < fulfilment[msg.sender].length; i++) {
      if (fulfilment[msg.sender][i] == _ticketId) {
        return i;
      }
    }

    return fulfilment[msg.sender].length;
  }

  /**
   * Remove the item from the fulfilment queue of the sender
   */
  function removeFromQueue(uint index) private {
    if (index >= fulfilment[msg.sender].length) return;

    fulfilment[msg.sender][index] = fulfilment[msg.sender][fulfilment[msg.sender].length - 1];

    delete fulfilment[msg.sender][fulfilment[msg.sender].length - 1];
    fulfilment[msg.sender].length--;
  }

  /**
   * Cancel the ticket
   */
  function cancelTicket(uint _ticketId) public onlyRetailerOf(_ticketId) {
    require(tickets[_ticketId].state == TicketState.Fulfilled, "Ticket state must be fulfilled");

    tickets[_ticketId].state = TicketState.Cancelled;
    tickets[_ticketId].fulfilmentURI = "";
  }

  /**
   * Return the description of the ticket 
   */
  function getTicketDescriptionById(uint _ticketId) public onlyRetailerOrOwnerOf(_ticketId) view returns (string memory) {
    return tickets[_ticketId].description;
  }

  /**
   * Return the state of the ticket
   */
  function getTicketStateById(uint _ticketId) public onlyRetailerOrOwnerOf(_ticketId) view returns (TicketState) {
    return tickets[_ticketId].state;
  }
  
  /**
   * Return the URI containing the fulfilment information
   */
  function getFulfilmentURIById(uint _ticketId) public onlyRetailerOrOwnerOf(_ticketId) view returns (string memory) {
    require(tickets[_ticketId].state == TicketState.Fulfilled, "Ticket state must be fulfilled");

    return tickets[_ticketId].fulfilmentURI;
  }

  /**
   * Get fulfilment queue of retailer
   */
  function getFulfilmentQueue() public view returns (uint[] memory) {
    return fulfilment[msg.sender];
  }

  /**
   * Get msg.sender token IDs
   */
  function getOwnedTokens() public view returns (uint[] memory) {
    return _tokensOfOwner(msg.sender);
  }


}
