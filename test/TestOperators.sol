pragma solidity ^0.4.19;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Operators.sol";

contract TestOperators {
  Operators ops = Operators(DeployedAddresses.Operators());

  // Test addOperator() function
  function testAddOperator() public {
    uint opId0 = ops.addOperator(
      "op1", 
      "desc", 
      "/ipfs/op1", 
      "123"
    );

    uint opId1 = ops.addOperator(
      "op2", 
      "desc", 
      "/ipfs/op2", 
      "456"
    );

    Assert.equal(opId0, 0, "Operator 1 not created.");
    Assert.equal(opId1, 1, "Operator 2 not created.");
  }

  // Test stored values
  function testAddedValues() public {
    Assert.equal(ops.nameById(0), "op1", "Operator 0 name incorrect.");
    Assert.equal(ops.descriptionById(0), "desc", "Operator 0 description incorrect.");
    Assert.equal(ops.urlById(0), "/ipfs/op1", "Operator 0 url incorrect.");
    Assert.equal(ops.pubKeyById(0), "123", "Operator 0 pubKey incorrect.");

    Assert.equal(ops.nameById(1), "op2", "Operator 0 name incorrect.");
    Assert.equal(ops.descriptionById(1), "desc", "Operator 0 description incorrect.");
    Assert.equal(ops.urlById(1), "/ipfs/op2", "Operator 0 url incorrect.");
    Assert.equal(ops.pubKeyById(1), "456", "Operator 0 pubKey incorrect.");
  }
}