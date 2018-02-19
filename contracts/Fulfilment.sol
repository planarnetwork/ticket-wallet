pragma solidity 0.4.20;

import "../libs/oraclize/oraclizeAPI.sol";


contract Fulfilment {

}

contract MobileFulfilment is Fulfilment, usingOraclize {
  string public EURGBP;
  event LogPriceUpdated(string price);
  event LogNewOraclizeQuery(string description);

  function ExampleContract() payable {
    updatePrice();
  }

  function __callback(bytes32 myid, string result) {
    require (msg.sender != oraclize_cbAddress());
    EURGBP = result;
    LogPriceUpdated(result);
  }

  function updatePrice() payable {
    if (oraclize_getPrice("URL") > this.balance) {
      LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
    } else {
      LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
      oraclize_query("URL", "json(http://api.fixer.io/latest?symbols=USD,GBP).rates.GBP");
    }
  }
}
