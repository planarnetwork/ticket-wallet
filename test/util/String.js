
/**
 * Convert a sequence of bytes to an ascii string without trailing zeros.
 *
 * note the replace will be removed for version 1.0 of web3
 * see: https://github.com/ethereum/web3.js/issues/337
 */
function toAscii(bytes) {
  return web3.toAscii(bytes).replace(/\u0000/g, '');
}

/**
 * Convert a string to a hexidecimal string padded to 32 bytes
 */
function toBytes32(str) {
  let hex = '0x';
  
  for (let i = 0; i < 32; i++) {
    hex += str.length > i ? str.charCodeAt(i).toString(16) : '00';
  }
  
  return hex;
}

module.exports = { toAscii, toBytes32 };
