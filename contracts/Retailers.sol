pragma solidity 0.4.19;

import {ERC721Token} from "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import {Pausable} from "zeppelin-solidity/contracts/lifecycle/Pausable.sol";

/**
 * Maintains a list of authorised ticket retailers
 */
contract Retailers is ERC721Token, Pausable {

  /**
   * Retailer details
   */
  struct Retailer {
    bytes32 name;
    uint txFeeAmount;
    bytes32 pubKey;
  }

  /**
   * Index of retailers
   */
  Retailer[] public retailers;

  /**
   * Adds the given retailer to the index and returns their ID. Note that the message sender is not the owner of the
   * retailer generated - the owner is the _address property. 
   */
  function addRetailer(
    address _address,
    bytes32 _name,
    uint _txFeeAmount,
    bytes32 _pubKey
  ) 
    public
    onlyOwner()
    returns (uint retailerId) 
  {
    require(_name[0] != 0);
    require(_pubKey[0] != 0);

    Retailer memory _retailer = Retailer({
      name: _name,
      txFeeAmount: _txFeeAmount,
      pubKey: _pubKey
    });
    uint256 opId = retailers.push(_retailer) - 1;

    _mint(_address, opId);

    return opId;
  }

  /**
   * Get the name of the given retailer
   */
  function nameById(uint _retailerId) public constant returns(bytes32) {
    return retailers[_retailerId].name;
  }

  /**
   * Set the name of the given retailer
   */
  function setNameById(uint _retailerId, bytes32 _name) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].name = _name;
  }

  /**
   * Get the transaction fee charged by a retailer
   */
  function txFeeAmountById(uint _retailerId) public constant returns(uint) {
    return retailers[_retailerId].txFeeAmount;
  }

  /**
   * Set the transaction fee of a retailer
   */
  function setTxFeeAmountById(uint _retailerId, uint _txFeeAmount) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].txFeeAmount = _txFeeAmount;
  }

  /**
   * Get a retailers public key
   */
  function pubKeyById(uint _retailerId) public constant returns(bytes32) {
    return retailers[_retailerId].pubKey;
  }

  /**
   * Set the retailers public key
   */
  function setPubKey(uint _retailerId, bytes32 _pubKey) public onlyOwnerOf(_retailerId) {
    retailers[_retailerId].pubKey = _pubKey;
  }
}
