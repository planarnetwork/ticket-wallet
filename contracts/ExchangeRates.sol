pragma solidity 0.4.19;

import "./oraclizeAPI_0.5.sol";


contract ExchangeRateGBP is usingOraclize {
  
  uint public GBPUSD;
  
  event newOraclizeQuery(string description);
  event emitNewPrice(uint price);

  function ExchangeRateGBP() public {
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    update();
  }

  function __callback(bytes32 myid, string result, bytes proof) public {
    require(msg.sender != oraclize_cbAddress());

    GBPUSD = parseInt(result, 4) * 10000;

    emitNewPrice(GBPUSD);
    update();
  }
    
  function update() public payable {
    if (oraclize.getPrice("URL") > this.balance) {
      newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
    } else {
      newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
      oraclize_query(60, "URL", "json(https://api.fixer.io/latest?base=USD&symbols=GBP).rates.GBP");
    }
  }    
} 


contract ExchangeRateETH is usingOraclize {
    
  uint public ETHXBT;
  
  event newOraclizeQuery(string description);
  event emitNewPrice(uint price);
  
  function ExchangeRateETH() public {
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    update();
  }

  function __callback(bytes32 myid, string result, bytes proof) public {
    require(msg.sender != oraclize_cbAddress());

    ETHXBT = parseInt(result, 4) * 10000;

    emitNewPrice(ETHXBT);
    update();
  }
  
  function update() public payable {
    if (oraclize.getPrice("URL") > this.balance) {
      newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
    } else {
      newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
      oraclize_query(60, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0");
    }
  }  
} 
