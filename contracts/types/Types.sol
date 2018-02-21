pragma solidity 0.4.19;

import "../cryptography/ECVerify.sol";


library Types {
  // Fare Option
  struct FareOption {
    bytes32 name;
    bytes4 origin;
    bytes4 destination;
    uint departure;
    uint arrival;
    uint expiry;
    uint16 price;

    address retailer;
    bytes signature;
  }

  function fareOptionExpired(FareOption f) public constant returns(bool) {
    // solium-disable-next-line security/no-block-members
    return f.expiry < now;
  }

  function fareOptionHash(FareOption f) internal constant returns(bytes32) {
    return keccak256(
      f.origin, 
      f.destination, 
      f.departure, 
      f.arrival, 
      f.expiry, 
      f.price
    );
  }

  function checkSignature(FareOption f) public view returns (bool) {
    return ECVerify.ecverify(fareOptionHash(f), f.signature, f.retailer);
  }

  // Delivery
  struct Delivery {
    uint price;
    bytes32 pdfUrl;
    bytes32 pkpassUrl;
  }
}
