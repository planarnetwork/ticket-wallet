const {toAscii, toBytes32} = require("../util/String.js");
const Retailers = artifacts.require("Retailers.sol");
const TicketWallet = artifacts.require("TicketWallet.sol");
const ECTools = artifacts.require("ECTools.sol");
const Web3Utils = require('web3-utils');

contract("TicketWallet", ([owner, retailer]) => {

  it("can create tickets", async () => {
    const retailers = await Retailers.deployed();
    const retailTransactionFeeEth = 0.01;
    const retailTransactionFeeWei = Web3Utils.toWei(retailTransactionFeeEth.toString(), "ether");

    await retailers.addRetailer(retailer, "A Retailer", retailTransactionFeeWei);

    const ticketWallet = await TicketWallet.deployed();
    const expiry = Math.floor(Date.now() / 1000) + 86400;
    const ticketCostEth = 10;
    const ticketCostWei = Web3Utils.toWei(ticketCostEth.toString(), "ether");
    const ticketDescription = "Anytime from Brighton to London";
    const ticketPayload = "ipfs://2fkfsd";
    const transactionCostEth = ticketCostEth + retailTransactionFeeEth;
    const transactionCostWei = Web3Utils.toWei(transactionCostEth.toString(), "ether");
    const hash = Web3Utils.soliditySha3(toBytes32(ticketPayload), "_", ticketCostWei, "_", expiry);
    const signature = web3.eth.sign(retailer, hash);
    const originalWei = await web3.eth.getBalance(retailer);

    await ticketWallet.createTicket(
      ticketDescription,
      expiry,
      ticketCostWei,
      0,
      ticketPayload,
      signature,
      {
        value: transactionCostWei,
        from: owner
      }
    );
    
    const [description, payloadUrl] = await Promise.all([
      ticketWallet.getTicketDescriptionById(0, { from: owner }),
      ticketWallet.getTicketPayloadUrlById(0, { from: owner })
    ]);

    const finalWei = await web3.eth.getBalance(retailer);
    const expectedEth = parseFloat(Web3Utils.fromWei(originalWei.toString(), "ether")) + transactionCostEth;
    const expectedWei = Web3Utils.toWei(expectedEth.toString(), "ether");

    assert.equal(finalWei.toNumber(), expectedWei);
    assert.equal(toAscii(description), ticketDescription);
    assert.equal(toAscii(payloadUrl), ticketPayload);
  });
  
  it("ensures amount sent covers the cost of the ticket and the transaction fee", async () => {
    const retailers = await Retailers.deployed();
    const retailTransactionFee = 100;

    await retailers.addRetailer(retailer, "A Retailer", retailTransactionFee);

    const ticketWallet = await TicketWallet.deployed();
    const expiry = Math.floor(Date.now() / 1000) + 86400;
    const ticketCost = Web3Utils.toWei("50", "ether");
    const ticketDescription = "Anytime from Brighton to London";
    const ticketPayload = "ipfs://2fkfsd";
    const hash = Web3Utils.soliditySha3(toBytes32(ticketPayload), "_", ticketCost, "_", expiry);
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
    const ticketCost = Web3Utils.toWei("50", "ether");
    const ticketDescription = "Anytime from Brighton to London";
    const ticketPayload = "ipfs://2fkfsd";
    const transactionCost = ticketCost + retailTransactionFee;
    const hash = Web3Utils.soliditySha3(toBytes32(ticketPayload), "_", ticketCost, "_", expiry);
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

  it("retailers can access their fulfilment queue", async () => {
    const ticketWallet = await TicketWallet.deployed();
    const items = await ticketWallet.getFulfilmentQueue({ from: retailer });

    assert.equal(items.length, 1);

    const payloadUrl = await ticketWallet.getTicketPayloadUrlById(items[0].toNumber(), { from: retailer });

    assert.equal(toAscii(payloadUrl), "ipfs://2fkfsd");
  });

  it("retailer can mark the order as fulfilled", async () => {
    const ticketWallet = await TicketWallet.deployed();
    const items = await ticketWallet.getFulfilmentQueue({ from: retailer });

    assert.equal(items.length, 1);

    const ticketId = items[0].toNumber();
    const inputState = await ticketWallet.getTicketStateById(ticketId, { from: retailer });

    assert.equal(inputState.toNumber(), 0);

    await ticketWallet.fulfilTicket(ticketId, toBytes32("ipfs://fulfilment"), { from: retailer });
    const outputState = await ticketWallet.getTicketStateById(ticketId, { from: retailer });

    assert.equal(outputState.toNumber(), 1);

    const fulfilmentUrl = await ticketWallet.getFulfilmentUrlById(ticketId, { from: owner });

    assert.equal(toAscii(fulfilmentUrl), "ipfs://fulfilment");

    const queue = await ticketWallet.getFulfilmentQueue({ from: retailer });

    assert.equal(queue.length, 0);
  });

  it("retailer can mark the order as cancelled", async () => {
    const ticketWallet = await TicketWallet.deployed();
    const ticketId = 0;
    const inputState = await ticketWallet.getTicketStateById(ticketId, { from: retailer });

    assert.equal(inputState.toNumber(), 1);

    await ticketWallet.cancelTicket(ticketId, { from: retailer });
    const outputState = await ticketWallet.getTicketStateById(ticketId, { from: retailer });

    assert.equal(outputState.toNumber(), 2);
  });

});
