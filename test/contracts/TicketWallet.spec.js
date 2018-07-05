const {toAscii, toBytes32} = require("../util/String.js");
const Retailers = artifacts.require("Retailers.sol");
const TicketWallet = artifacts.require("TicketWallet.sol");
const ECTools = artifacts.require("ECTools.sol");
const Web3Utils = require('web3-utils');

contract("TicketWallet", ([owner, retailer]) => {

  it("can create tickets", async () => {
    const retailers = await Retailers.deployed();
    const retailTransactionFee = 100000;

    await retailers.addRetailer(retailer, "A Retailer", retailTransactionFee);

    const ticketWallet = await TicketWallet.deployed();
    const expiry = Math.floor(Date.now() / 1000) + 86400;
    const ticketCost = 5000000;
    const ticketDescription = "Anytime from Brighton to London";
    const ticketPayload = "ipfs://2fkfsd";
    const transactionCost = ticketCost + retailTransactionFee;
    const hash = Web3Utils.soliditySha3(toBytes32(ticketPayload), ticketCost, expiry);
    const signature = web3.eth.sign(retailer, hash);
    const originalWei = await web3.eth.getBalance(retailer);

    await ticketWallet.createTicket(
      ticketDescription,
      expiry,
      ticketCost,
      0,
      ticketPayload,
      signature,
      {
        value: transactionCost,
        from: owner
      }
    );
    
    const [description, payloadUrl] = await Promise.all([
      ticketWallet.getTicketDescriptionById(0, { from: owner }),
      ticketWallet.getTicketPayloadUrlById(0, { from: owner })
    ]);

    const finalWei = await web3.eth.getBalance(retailer);

    assert.equal(finalWei.toNumber(), originalWei.toNumber() + transactionCost);
    assert.equal(toAscii(description), ticketDescription);
    assert.equal(toAscii(payloadUrl), ticketPayload);
  });
  
  it("ensures amount sent covers the cost of the ticket and the transaction fee", async () => {
    const retailers = await Retailers.deployed();
    const retailTransactionFee = 100;

    await retailers.addRetailer(retailer, "A Retailer", retailTransactionFee);

    const ticketWallet = await TicketWallet.deployed();
    const expiry = Math.floor(Date.now() / 1000) + 86400;
    const ticketCost = 5000000;
    const ticketDescription = "Anytime from Brighton to London";
    const ticketPayload = "ipfs://2fkfsd";
    const hash = Web3Utils.soliditySha3(toBytes32(ticketPayload), ticketCost, expiry);
    const signature = web3.eth.sign(retailer, hash);

    let complete = false;
  
    try {
      await ticketWallet.createTicket(
        ticketDescription,
        expiry,
        ticketCost,
        0,
        ticketPayload,
        signature,
        {
          value: ticketCost,
          from: owner
        }
      );
  
      complete = true;
    }
    catch (err) {}
  
    assert.equal(complete, false);
  });
  
  it("ensures offer has not expired", async () => {
    const retailers = await Retailers.deployed();
    const retailTransactionFee = 100;

    await retailers.addRetailer(retailer, "A Retailer", retailTransactionFee);

    const ticketWallet = await TicketWallet.deployed();
    const expiry = Math.floor(Date.now() / 1000) - 86400;
    const ticketCost = 5000000;
    const ticketDescription = "Anytime from Brighton to London";
    const ticketPayload = "ipfs://2fkfsd";
    const transactionCost = ticketCost + retailTransactionFee;
    const hash = Web3Utils.soliditySha3(toBytes32(ticketPayload), ticketCost, expiry);
    const signature = web3.eth.sign(retailer, hash);

    let complete = false;

    try {
      await ticketWallet.createTicket(
        ticketDescription,
        expiry,
        ticketCost,
        0,
        ticketPayload,
        signature,
        {
          value: transactionCost,
          from: owner
        }
      );

      complete = true;
    }
    catch (err) {}

    assert.equal(complete, false);
  });
  
  xit("retailer can mark the order as fulfilled", async () => {
  
  });

  xit("retailer can mark the order as cancelled", async () => {

  });

});
