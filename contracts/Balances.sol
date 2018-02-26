pragma solidity 0.4.19;

// IDEA
contract Balances {
  // Who owes what in which currency
  mapping(address => mapping (address => mapping (bytes3 => int))) public balance;
  // List of allowed debit amounts between accounts in given currency
  mapping(address => mapping (address => mapping (bytes3 => int))) public allowedDebit;

  event Borrowed(address from, address to, bytes3 currency);
  event Received(address from, address to, bytes3 currency);
  event NewDebitAmount(address from, address to, bytes3 currency, uint amount);

  // Borrow some funds _from account
  function borrow(address _from, bytes3 _currency, uint _amount) public {
    require(balance[msg.sender][_from][_currency] + allowedDebit[_from][msg.sender][_currency] >= _amount);
    balance[msg.sender][_from][_currency] -= _amount;

    Borrowed(_from, msg.sender, _currency);
  }

  // Call when you receive funds _from account
  function received(address _from, bytes3 _currency, uint _amount) public {
    balance[_from][msg.sender][_currency] += _amount;

    Received(msg.sender, _from, _currency);
  }

  function allowDebit(address _for, bytes3 _currency, uint _amount) public {
    allowedDebit[msg.sender][_for][_currency];

    NewDebitAmount(
      msg.sender,
      _for,
      _currency,
      _amount
    );
  }
}