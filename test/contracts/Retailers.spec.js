const {toAscii} = require("../util/String.js");
const Retailers = artifacts.require("../Retailers.sol");

contract("Retailers", ([owner, retailer, newRetailerAddress]) => {

  it("adds retailers", async () => {
    const retailers = await Retailers.deployed();
    
    await retailers.addRetailer.sendTransaction(
      retailer,
      "A Retailer",
      10000,
      "5d4f6s8df4524w6fd5s4f6ws8e4f65s4"
    );
    
    const [address, name, fee, publicKey] = await Promise.all([
      retailers.ownerOf.call(0),
      retailers.nameById.call(0),
      retailers.txFeeAmountById.call(0),
      retailers.pubKeyById.call(0)
    ]);
    
    assert.equal(address, retailer);
    assert.equal(toAscii(name), "A Retailer");
    assert.equal(fee, 10000);
    assert.equal(toAscii(publicKey), "5d4f6s8df4524w6fd5s4f6ws8e4f65s4");
  });

  it("sets a retailer's name", async () => {
    const retailers = await Retailers.deployed();
    
    await retailers.setNameById.sendTransaction(0, "New Name", { from: retailer });
    
    const name = await retailers.nameById.call(0);
    
    assert.equal(toAscii(name), "New Name");
  });

  it("ensures only the retailer can change their name", async () => {
    const retailers = await Retailers.deployed();
    let set = false;
    
    try {
      await retailers.setNameById.sendTransaction(0, "New Name", { from: owner });
      set = true;
    }
    catch (err) {}
    
    assert.equal(set, false);
  });

  it("sets a retailer's fee", async () => {
    const retailers = await Retailers.deployed();
    
    await retailers.setTxFeeAmountById.sendTransaction(0, 0, { from: retailer });
    
    const fee = await retailers.txFeeAmountById.call(0);
    
    assert.equal(fee, 0);
  });

  it("ensures only the retailer can change their fee", async () => {
    const retailers = await Retailers.deployed();
    let set = false;
    
    try {
      await retailers.setTxFeeAmountById.sendTransaction(0, 100, { from: owner });
      set = true;
    }
    catch (err) {}
    
    assert.equal(set, false);
  });

  it("sets a retailer's public key", async () => {
    const retailers = await Retailers.deployed();
    
    await retailers.setPubKey.sendTransaction(0, "46f5d44e554gju421334151as534f5j6", { from: retailer });
    
    const key = await retailers.pubKeyById.call(0);
    
    assert.equal(toAscii(key), "46f5d44e554gju421334151as534f5j6");
  });

  it("ensures only the retailer can change their public key", async () => {
    const retailers = await Retailers.deployed();
    let set = false;
    
    try {
      await retailers.setPubKey.sendTransaction(0, "46f5d44e554gju421334151as534f5j6", { from: owner });
      set = true;
    }
    catch (err) {}
    
    assert.equal(set, false);
  });

  it("transfer ownership of a retailer", async () => {
    const retailers = await Retailers.deployed();
    
    await retailers.transfer.sendTransaction(newRetailerAddress, 0, { from: retailer });
    
    const address = await retailers.ownerOf.call(0);
    
    assert.equal(address, newRetailerAddress);
  });

});
