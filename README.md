# liqwid-contracts

## project setup

you will need: 
stack 2.5.1 
ormolu 0.1.2.0
hlint 3.2.3

## how to build:
`hpack -f` to ensure that package.yaml is your source of truth at all times
`stack build` 

## how to run:

currently code can only be tested via the playground, we need to figure out the right way to script tests and run them locally.

## development resources:
plutus repo & docs
https://github.com/input-output-hk/plutus
plutus platform introduction video:
https://www.youtube.com/watch?v=usMPt8KpBeI
cardano plutus tutorial on forging:
https://docs.cardano.org/projects/plutus/en/latest/tutorials/basic-forging-policies.html
jormangundr (local blockchain dev tools):
https://github.com/input-output-hk/jormungandr
experimental smart contracts:
https://github.com/robkorn/plutus-experimental-smart-contracts
plutus playground:
https://playground.plutus.iohkdev.io
