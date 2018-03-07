pragma solidity 0.4.19;

import {ERC721Token} from "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import {Pausable} from "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import {Retailers} from "./Retailers.sol";
import {ECTools} from "./ECTools.sol";

/**
 * Manage the creation and storage of tickets.
 */
contract TicketWallet is ERC721Token, Pausable {

  string public constant name = "Ticket Wallet by Planar Network";

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
    require(getAddressByRetailerId(tickets[_ticketId].retailerId) == msg.sender || ownerOf(_ticketId) == msg.sender);
    _;
  }

  /**
   * Ensure the given message sender is the retailer of the token
   */
  modifier onlyRetailerOf(uint256 _ticketId) {
    require(getAddressByRetailerId(tickets[_ticketId].retailerId) == msg.sender);
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
    uint created;
    FulfilmentMethod fulfilmentMethod;
    bytes32 fulfilmentUrl;
    uint retailerId;
  }

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
  function TicketWallet(address _retailers) public {
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
    /* string _signature, */
    bytes32 _payloadUrl,
    FulfilmentMethod _fulfilmentMethod
  ) 
    public 
    payable 
    returns (uint) 
  {
    /* require(
      ECTools.isSignedBy(
        keccak256(_payloadUrl, _price, _expiry), 
        _signature, 
        getAddressByRetailerId(_retailerId)
      )
    ); */
    // solium-disable-next-line security/no-block-members
    require(_expiry < now);
    /* uint fullPrice = _price + getTxFeeAmountByRetailerId(_retailerId);
    require(msg.value == fullPrice); */

    // solium-disable security/no-block-members
    Ticket memory _ticket = Ticket({
      description: _description,
      /* price: fullPrice, */
      price: _price,
      payloadUrl: _payloadUrl,
      state: TicketState.Paid,
      fulfilmentMethod: _fulfilmentMethod,
      fulfilmentUrl: 0,
      created: now,
      retailerId: _retailerId
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
   * Get Retailer's address by retailerId
   */
  function getAddressByRetailerId(uint _retailerId) private constant returns (address) {
    return Retailers(retailers).ownerOf(_retailerId);
  }

  /**
   * Get Retailer's transaction fee amount by retailerId
   */
  function getTxFeeAmountByRetailerId(uint _retailerId) private constant returns (uint) {
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
