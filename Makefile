install:
	npm install

build:
	solc --bin contracts/TicketWallet.sol

clean:
	rm -f node_modules
