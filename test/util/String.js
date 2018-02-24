
/**
 * Convert a sequence of bytes to an ascii string without trailing zeros.
 *
 * note the replace will be removed for version 1.0 of web3
 * see: https://github.com/ethereum/web3.js/issues/337
 */
function toAscii(bytes) {
  return web3.toAscii(bytes).replace(/\u0000/g, '');
}

module.exports = { toAscii };
