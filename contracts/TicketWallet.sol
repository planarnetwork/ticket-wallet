pragma solidity ^0.4.24;

import {ERC721Token} from "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import {Pausable} from "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import {Retailers} from "./Retailers.sol";
import {ECTools} from "./ECTools.sol";

/**
 * Manage the creation and storage of tickets.
 */
contract TicketWallet is ERC721Token("Ticket wallet", "PLNR-WALLET"), Pausable {

  /**
   * Ticket lifecycle
   */
  enum TicketState {Paid, Fulfilled, Cancelled}

  /**
   * Ensure the given message sender is the owner or retailer of the token
   */
  modifier onlyRetailerOrOwnerOf(uint256 _ticketId) {
    address _retailer = getAddressByRetailerId(tickets[_ticketId].retailerId);

    require(_retailer == msg.sender || ownerOf(_ticketId) == msg.sender, "Must be owner or retailer");
    _;
  }

  /**
   * Ensure the given message sender is the retailer of the token
   */
  modifier onlyRetailerOf(uint256 _ticketId) {
    require(getAddressByRetailerId(tickets[_ticketId].retailerId) == msg.sender, "Must be retailer");
    _;
  }

  /**
   * Ticket information
   */
  struct Ticket {
    bytes32 description;
    uint price;
    bytes32 payloadUrl;
    TicketState state;
    bytes32 fulfilmentUrl;
    uint retailerId;
  }

  /**
   * Fulfilment queues
   */
  mapping(address => uint256[]) fulfilment;

  /**
   * Ticket storage
   */
  Ticket[] public tickets;

  /**
   * Retailers contract address
   */
  address public retailers;

  /**
   * Store a reference to the ERC-721 index of authorised retailers
   */
  constructor(address _retailers) public {
    retailers = _retailers;
  }

  /**
   * Add a ticket to the contract. 
   *
   * This function will ensure the price, expiry time and payload were created by an authorised retailer, create the
   * ticket and store it in the contract storage.
   */
  function createTicket(
    bytes32 _description,
    uint _expiry,
    uint _price,
    uint _retailerId,
    bytes32 _payloadUrl,
    string _signature
  ) 
    public 
    payable 
    returns (uint) 
  {
    bytes32 _expectedHash = keccak256(abi.encodePacked(_payloadUrl, "_", _price, "_", _expiry));
    bytes32 _expectedSignature = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _expectedHash));
    address _retailerAddress = getAddressByRetailerId(_retailerId);

    require(ECTools.isSignedBy(_expectedSignature, _signature, _retailerAddress), "Invalid signature");

    require(_expiry > now, "Offer has expired");
    uint fullPrice = _price + getTxFeeAmountByRetailerId(_retailerId);
    require(msg.value == fullPrice, "Transaction value must cover ticket price and transaction fee");

    Ticket memory _ticket = Ticket({
      description: _description,
      price: fullPrice,
      payloadUrl: _payloadUrl,
      state: TicketState.Paid,
      fulfilmentUrl: "",
      retailerId: _retailerId
    });

    uint256 ticketId = tickets.push(_ticket) - 1;

    _mint(msg.sender, ticketId);
    _retailerAddress.transfer(fullPrice);

    fulfilment[_retailerAddress].push(ticketId);

    return ticketId;
  }

  /**
   * Fulfil the ticket and attach the fulfilment URL
   */
  function fulfilTicket(uint256 _ticketId, bytes32 _fulfilmentUrl) public onlyRetailerOf(_ticketId) {
    uint _indexInFulfilmentQueue = getQueueIndex(_ticketId);

    require(_indexInFulfilmentQueue != fulfilment[msg.sender].length, "Ticket must be queued for fulfilment");
    require(tickets[_ticketId].state == TicketState.Paid, "Ticket state must be Paid");

    tickets[_ticketId].state = TicketState.Fulfilled;
    tickets[_ticketId].fulfilmentUrl = _fulfilmentUrl;

    removeFromQueue(_indexInFulfilmentQueue);
  }

  /**
   * Get the index of the ticket in the queue
   */
  function getQueueIndex(uint256 _ticketId) public view returns (uint) {
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
  function cancelTicket(uint256 _ticketId) public onlyRetailerOf(_ticketId) {
    require(tickets[_ticketId].state == TicketState.Fulfilled, "Ticket state must be fulfilled");

    tickets[_ticketId].state = TicketState.Cancelled;
    tickets[_ticketId].fulfilmentUrl = "";
  }

  /**
   * Get Retailer's address by retailerId
   */
  function getAddressByRetailerId(uint _retailerId) private view returns (address) {
    return Retailers(retailers).ownerOf(_retailerId);
  }

  /**
   * Get Retailer's transaction fee amount by retailerId
   */
  function getTxFeeAmountByRetailerId(uint _retailerId) private view returns (uint) {
    return Retailers(retailers).txFeeAmountById(_retailerId);
  }

  /**
   * Set new address of Retailers contract
   */
  function setRetailerAddress(address _newRetailers) public onlyOwner {
    retailers = _newRetailers;
  }

  /**
   * Return the description of the ticket 
   */
  function getTicketDescriptionById(uint256 _ticketId) public onlyRetailerOrOwnerOf(_ticketId) view returns (bytes32) {
    return tickets[_ticketId].description;
  }

  /**
   * Return the URL of the full ticket details
   */
  function getTicketPayloadUrlById(uint256 _ticketId) public onlyRetailerOrOwnerOf(_ticketId) view returns (bytes32) {
    return tickets[_ticketId].payloadUrl;
  }

  /**
   * Return the state of the ticket
   */
  function getTicketStateById(uint256 _ticketId) public onlyRetailerOrOwnerOf(_ticketId) view returns (TicketState) {
    return tickets[_ticketId].state;
  }
  
  /**
   * Return the URL containing the fulfilment information
   */
  function getFulfilmentUrlById(uint256 _ticketId) public onlyRetailerOrOwnerOf(_ticketId) view returns (bytes32) {
    require(tickets[_ticketId].state == TicketState.Fulfilled, "Ticket state must be fulfilled");

    return tickets[_ticketId].fulfilmentUrl;
  }

  /**
   * Get fulfilment queue of retailer
   */
  function getFulfilmentQueue() public view returns (uint256[]) {
    return fulfilment[msg.sender];
  }

}
