.PHONY: all build clean

install:
	npm install

build:
	solc --bin --overwrite -o /tmp/solcoutput dapp-bin=./build ./contracts/TicketWallet.sol
	solc --bin --overwrite -o /tmp/solcoutput dapp-bin=./build ./contracts/Operators.sol
	solc --bin --overwrite -o /tmp/solcoutput dapp-bin=./build ./contracts/Retailers.sol

clean:
	rm -f node_modules
