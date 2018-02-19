pragma solidity 0.4.20;


contract Managed {
  address public owner;
  address public manager;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  event ManagemendTransferred(address indexed previousManager, address indexed newManager);


  function Managed() public {
    owner = msg.sender;
    manager = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  modifier onlyManager() {
    require(msg.sender == manager);
    _;
  }

  modifier onlyManagerOrOwner() {
    require(msg.sender == owner || msg.sender == manager);
    _;
  }

  function transferOwnership(address newOwner) public onlyManagerOrOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  function transferManagement(address newManager) public onlyManager {
    require(newManager != address(0));
    ManagemendTransferred(manager, newManager);
    manager = newManager;
  }
}