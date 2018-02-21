pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/TicketWallet.sol";

contract TestTicketWallet {
  TicketWallet tw = TicketWallet(DeployedAddresses.TicketWallet());

  // Test createTicket() function
  function testCreateTicket() public {
    
  }
}