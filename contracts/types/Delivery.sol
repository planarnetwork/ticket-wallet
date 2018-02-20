pragma solidity 0.4.19;

import "../ownership/Managed.sol";


contract Delivery is Managed {
  enum Status {NEW, PROCESSING, SHIPPED, DELIVERED}
  uint public price;
}


contract Printable is Delivery {
  string public pdfUrl;
}


contract Collectable is Delivery {
  string public reference;
  string public location;
}


contract Shippable is Delivery {
  string public name;
  string public addr;
  string public postCode;
  string public city;
  bytes2 public country;
}


contract MobileDelivery is Printable {
  string public pkpassUrl;
}


contract SelfPrintDelivery is Printable {

}


contract ToDDelivery is Collectable {

}


contract CCSTDelivery is Shippable {

}
