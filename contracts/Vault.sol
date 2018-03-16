pragma solidity 0.4.19;

import {Pausable} from "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
// import {ExchangeRateGBP, ExchangeRateETH} from "./ExchageRates.sol";


contract Vault is Pausable {
  function gbpInEth(uint amount) public returns(uint) {
    //return ExchangeRateETH.ETHXBT * ExchangeRateGBP.GBPUSD * amount;
    return 0;
  }

  function usdInEth(uint amount) public returns(uint) {
    // return ExchangeRateETH.ETHXBT * amount;
    return 0;
  }

}