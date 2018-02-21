pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Retailers.sol";

contract TestRetailers {
  Retailers rs = Retailers(DeployedAddresses.Retailers());

  // Test addRetailer() function
  function testAddRetailer() public {
    uint retId0 = rs.addRetailer(
      "ret1", 
      "desc", 
      "/ipfs/ret1", 
      "123"
    );

    uint retId1 = rs.addRetailer(
      "ret2", 
      "desc", 
      "/ipfs/ret2", 
      "456"
    );

    Assert.equal(retId0, 0, "Retailer 1 not created.");
    Assert.equal(retId1, 1, "Retailer 2 not created.");
  }

  // Test stored values
  function testAddedValues() public {
    Assert.equal(rs.nameById(0), "ret1", "Retailer 0 name incorrect.");
    Assert.equal(rs.descriptionById(0), "desc", "Retailer 0 description incorrect.");
    Assert.equal(rs.urlById(0), "/ipfs/ret1", "Retailer 0 url incorrect.");
    Assert.equal(rs.pubKeyById(0), "123", "Retailer 0 pubKey incorrect.");

    Assert.equal(rs.nameById(1), "ret2", "Retailer 0 name incorrect.");
    Assert.equal(rs.descriptionById(1), "desc", "Retailer 0 description incorrect.");
    Assert.equal(rs.urlById(1), "/ipfs/ret2", "Retailer 0 url incorrect.");
    Assert.equal(rs.pubKeyById(1), "456", "Retailer 0 pubKey incorrect.");
  }
}