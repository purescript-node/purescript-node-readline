all: lib test

lib:
	mkdir -p js/Node/
	psc src/Node/ReadLine.purs.hs \
	  -o js/Node/ReadLine.js \
	  -e js/Node/ReadLine.e.purs.hs \
	  --module Node.ReadLine --tco --magic-do

test:
	psc src/Node/ReadLine.purs.hs examples/Examples.purs.hs \
	  -o js/Examples.js \
	  --main --module Main --tco --magic-do
